import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import '../../../config/environment.dart';
import '../../../models/chat_message.dart';
import '../../../models/user/user_model.dart';
import '../../../shared/network/local/chat_history_db.dart';
import '../ai_chat_service.dart';
import 'ai_chat_state.dart';

class AIChatCubit extends Cubit<AIChatState> {
  final AIChatService _service = AIChatService();
  final ChatHistoryDB _db = ChatHistoryDB();
  final String _sessionId;
  List<ChatMessage> _messages = [];
  StreamSubscription<String>? _subscription;
  String? _currentAssistantMessageId;

  // ---------- Ad related ----------
  RewardedAd? _rewardedAd;
  int _remainingFreeChats = 3;
  static const String _prefKey = 'remaining_free_chats';
  bool _isAdLoading = false;
  bool _isClosed = false; // to prevent emitting after dispose

  AIChatCubit({String? sessionId})
      : _sessionId = sessionId ?? const Uuid().v4(),
        super(const AIChatInitial()) {
    _loadRemainingChats();
    _loadConversation();
  }

  String get sessionId => _sessionId;

  // ---------- Persistence ----------
  Future<void> _loadRemainingChats() async {
    final prefs = await SharedPreferences.getInstance();
    _remainingFreeChats = prefs.getInt(_prefKey) ?? 3;
    _updateStateWithRemaining();
  }

  Future<void> _saveRemainingChats(int count) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_prefKey, count);
  }

  // ---------- Conversation ----------
  Future<void> _loadConversation() async {
    final saved = await _db.getConversation(_sessionId);
    if (saved != null) {
      _messages = saved;
      _safeEmit(AIChatInitial(
        messages: _messages,
        sessionId: _sessionId,
        remainingFreeChats: _remainingFreeChats,
      ));
    }
  }

  Future<void> _saveConversation() async {
    await _db.saveConversation(_sessionId, _messages);
  }

  // ---------- Public: watch ad to get more attempts ----------
  void watchAdToGetMore() {
    if (_isAdLoading || _isClosed) return;
    if (_remainingFreeChats > 0) return;
    // Emit loading state for ad
    _safeEmit(AIChatAdLoading(
      messages: _messages,
      remainingFreeChats: _remainingFreeChats,
    ));
    _showRewardedAd();
  }

  // ---------- Core: send message ----------
  Future<void> sendMessage(String text) async {
    if (_isClosed) return;
    if (text.trim().isEmpty) return;

    // Check free chats – if none, just return (UI will handle)
    if (_remainingFreeChats <= 0) {
      return;
    }

    // Consume one free chat
    _remainingFreeChats--;
    await _saveRemainingChats(_remainingFreeChats);
    _updateStateWithRemaining();

    final userMessage = ChatMessage.user(text.trim());
    _messages.add(userMessage);

    final assistantPlaceholder = ChatMessage.assistant('');
    _messages.add(assistantPlaceholder);
    _currentAssistantMessageId = assistantPlaceholder.id;

    _safeEmit(AIChatLoading(
      messages: _messages,
      remainingFreeChats: _remainingFreeChats,
    ));

    try {
      final stream = _service.sendMessage(
        query: text,
        sessionId: _sessionId,
        userId: CurrentUser.user.id,
        latitude: 0,
        longitude: 0,
      );

      _subscription = stream.listen(
            (chunk) {
          // Insert spaces to avoid word merging
          final index = _messages.indexWhere((m) => m.id == _currentAssistantMessageId);
          if (index != -1) {
            String currentContent = _messages[index].content;
            if (currentContent.isNotEmpty &&
                chunk.isNotEmpty &&
                !currentContent.endsWith(' ') &&
                !chunk.startsWith(' ')) {
              currentContent += ' ';
            }
            currentContent += chunk;
            _messages[index] = _messages[index].copyWith(content: currentContent);
            _safeEmit(AIChatStreaming(
              messages: _messages,
              partialResponse: currentContent,
              remainingFreeChats: _remainingFreeChats,
            ));
          }
        },
        onDone: () {
          _subscription?.cancel();
          _subscription = null;

          // Format the final assistant message (Markdown cleanup)
          final assistantIndex = _messages.indexWhere((m) => m.id == _currentAssistantMessageId);
          if (assistantIndex != -1) {
            final rawContent = _messages[assistantIndex].content;
            final formattedContent = _formatMarkdown(rawContent);
            _messages[assistantIndex] = _messages[assistantIndex].copyWith(
              content: formattedContent,
            );
          }

          // Remove debug print or use logger
          // print('📦 Full Markdown response: ...');

          _saveConversation();
          _safeEmit(AIChatSuccess(
            messages: _messages,
            remainingFreeChats: _remainingFreeChats,
          ));
        },
        onError: (error) {
          _subscription?.cancel();
          _subscription = null;
          _messages.removeWhere((m) => m.id == _currentAssistantMessageId);
          _safeEmit(AIChatError(
            error: error.toString(),
            messages: _messages,
            remainingFreeChats: _remainingFreeChats,
          ));
        },
      );
    } catch (e) {
      _messages.removeWhere((m) => m.id == _currentAssistantMessageId);
      _safeEmit(AIChatError(
        error: e.toString(),
        messages: _messages,
        remainingFreeChats: _remainingFreeChats,
      ));
    }
  }

  // ---------- Markdown formatter ----------
  String _formatMarkdown(String raw) {
    String text = raw.replaceFirst(RegExp(r'^rag_tool\s*'), '');
    text = text.replaceAllMapped(
      RegExp(r'(?<!\n)(#{1,2}\s)'),
          (match) => '\n${match.group(0)}',
    );
    text = text.replaceAllMapped(
      RegExp(r'(?<!\n)(- )'),
          (match) => '\n${match.group(0)}',
    );
    text = text.replaceAllMapped(
      RegExp(r'(#{1,2}\s[^\n]+)\n?'),
          (match) => '${match.group(0)}\n',
    );
    return text.trim();
  }

  // ---------- Private Ad Logic ----------
  void _showRewardedAd() {
    if (_isAdLoading || _isClosed) return;
    _isAdLoading = true;

    final String adUnitId = Environment.rewardedAdUnitId;

    RewardedAd.load(
      adUnitId: adUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (RewardedAd ad) {
          _rewardedAd = ad;
          _isAdLoading = false;
          _rewardedAd?.show(
            onUserEarnedReward: (ad, reward) {
              _remainingFreeChats += 1;
              _saveRemainingChats(_remainingFreeChats);
              _updateStateWithRemaining();
              _safeEmit(AIChatAdRewardSuccess(
                messages: _messages,
                remainingFreeChats: _remainingFreeChats,
              ));
            },
          );
          _rewardedAd?.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
              _rewardedAd = null;
              _updateStateWithRemaining();
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              ad.dispose();
              _rewardedAd = null;
              _isAdLoading = false;
              // Emit a specific error code
              _safeEmit(AIChatError(
                error: 'ad_failed_to_show',
                messages: _messages,
                remainingFreeChats: _remainingFreeChats,
              ));
            },
          );
        },
        onAdFailedToLoad: (LoadAdError error) {
          _isAdLoading = false;
          // Emit a specific error code
          _safeEmit(AIChatError(
            error: 'ad_not_available',
            messages: _messages,
            remainingFreeChats: _remainingFreeChats,
          ));
        },
      ),
    );
  }

  // ---------- Safe emit (guards against emitting after close) ----------
  void _safeEmit(AIChatState state) {
    if (!_isClosed) {
      emit(state);
    }
  }

  // ---------- Helper to update state with new remaining count ----------
  void _updateStateWithRemaining() {
    final currentState = state;
    if (currentState is AIChatInitial) {
      _safeEmit(AIChatInitial(
        messages: currentState.messages,
        sessionId: currentState.sessionId,
        remainingFreeChats: _remainingFreeChats,
      ));
    } else if (currentState is AIChatLoading) {
      _safeEmit(AIChatLoading(
        messages: currentState.messages,
        remainingFreeChats: _remainingFreeChats,
      ));
    } else if (currentState is AIChatStreaming) {
      _safeEmit(AIChatStreaming(
        messages: currentState.messages,
        partialResponse: currentState.partialResponse,
        remainingFreeChats: _remainingFreeChats,
      ));
    } else if (currentState is AIChatSuccess) {
      _safeEmit(AIChatSuccess(
        messages: currentState.messages,
        remainingFreeChats: _remainingFreeChats,
      ));
    } else if (currentState is AIChatError) {
      _safeEmit(AIChatError(
        error: currentState.error,
        messages: currentState.messages,
        remainingFreeChats: _remainingFreeChats,
      ));
    } else if (currentState is AIChatAdRewardSuccess) {
      _safeEmit(AIChatAdRewardSuccess(
        messages: currentState.messages,
        remainingFreeChats: _remainingFreeChats,
      ));
    } else if (currentState is AIChatAdLoading) {
      _safeEmit(AIChatAdLoading(
        messages: currentState.messages,
        remainingFreeChats: _remainingFreeChats,
      ));
    }
  }

  void clearConversation() async {
    _subscription?.cancel();
    _subscription = null;
    _messages.clear();
    await _db.deleteConversation(_sessionId);
    _safeEmit(AIChatInitial(
      messages: [],
      sessionId: _sessionId,
      remainingFreeChats: _remainingFreeChats,
    ));
  }

  void retry() {
    final userMessages = _messages.where((m) => m.role == MessageRole.user).toList();
    if (userMessages.isNotEmpty) {
      final lastUser = userMessages.last;
      _messages.removeWhere((m) => m.role == MessageRole.assistant && m.content.isEmpty);
      sendMessage(lastUser.content);
    }
  }

  @override
  Future<void> close() {
    _isClosed = true;
    _subscription?.cancel();
    _saveConversation();
    _rewardedAd?.dispose();
    return super.close();
  }
}