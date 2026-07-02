import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import '../../../config/app_config.dart';
import '../../../config/environment.dart';
import '../../../models/chat_message.dart';
import '../../../models/user/user_model.dart';
import '../../../shared/network/local/chat_history_db.dart';
import '../../../shared/network/remote/supabase_service.dart';
import '../../../shared/network/remote/supabase_auth_service.dart';
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
  int _remainingFreeChats = 0;
  static const String _prefKey = 'remaining_free_chats';
  bool _isAdLoading = false;
  bool _isClosed = false;

  // ✅ Public flag to indicate loading state of remaining chats
  bool isLoadingRemaining = true;

  AIChatCubit({String? sessionId})
      : _sessionId = sessionId ?? const Uuid().v4(),
        super(const AIChatInitial(remainingFreeChats: 0)) {
    _loadRemainingChats();
    _loadConversation();
  }

  String get sessionId => _sessionId;

  // ---------- Persistence ----------
  Future<void> _loadRemainingChats() async {
    isLoadingRemaining = true;
    final prefs = await SharedPreferences.getInstance();

    // 1. Load from local cache first (instant)
    final localCount = prefs.getInt(_prefKey);
    if (localCount != null) {
      _remainingFreeChats = localCount;
      isLoadingRemaining = false;
      _updateStateWithRemaining();
    }

    // 2. Fetch from Supabase (source of truth)
    final user = CurrentUser.user;
    if (user != null) {
      try {
        final data = await supabaseService.client
            .from('users')
            .select('free_chat_attempts')
            .eq('id', user.id)
            .single();

        final cloudCount = data['free_chat_attempts'] as int?;
        if (cloudCount != null && cloudCount != _remainingFreeChats) {
          _remainingFreeChats = cloudCount;
          await prefs.setInt(_prefKey, cloudCount);
        }
        isLoadingRemaining = false;
        debugPrint('✅ Free chat attempts synced from cloud: $_remainingFreeChats');
      } catch (e) {
        debugPrint('⚠️ Failed to fetch free chat attempts from cloud');
        if (localCount == null) {
          _remainingFreeChats = 3;
          isLoadingRemaining = false;
        }
      }
    } else {
      if (localCount == null) {
        _remainingFreeChats = 3;
        isLoadingRemaining = false;
      }
    }

    isLoadingRemaining = false;
    _updateStateWithRemaining();
  }

  Future<void> _saveRemainingChats(int count) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_prefKey, count);

    final user = CurrentUser.user;
    if (user != null) {
      unawaited(_syncToCloud(count));
    }
  }

  Future<void> _syncToCloud(int count) async {
    try {
      await supabaseService.client
          .from('users')
          .update({'free_chat_attempts': count})
          .eq('id', CurrentUser.user.id);
      debugPrint('✅ Free chat attempts synced to cloud: $count');
    } catch (e) {
      debugPrint('⚠️ Failed to sync free chat attempts: $e');
    }
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
    _safeEmit(AIChatAdLoading(
      messages: _messages,
      remainingFreeChats: _remainingFreeChats,
    ));
    _showRewardedAd();
  }

  // ---------- Core: send message with offline check ----------
  Future<void> sendMessage(String text) async {
    if (_isClosed) return;
    if (text.trim().isEmpty) return;

    // Check if chat is enabled (config)
    if (!AppConfig.isChatEnabled) {
      _safeEmit(AIChatError(
        error: 'Chat feature is currently disabled.',
        messages: _messages,
        remainingFreeChats: _remainingFreeChats,
      ));
      return;
    }

    if (_remainingFreeChats <= 0) {
      return;
    }

    // ✅ Check connectivity before sending
    final hasInternet = await SupabaseAuthService().isConnectedFast();
    if (!hasInternet) {
      _safeEmit(AIChatError(
        error: 'offline_chat',
        messages: _messages,
        remainingFreeChats: _remainingFreeChats,
      ));
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

          final assistantIndex = _messages.indexWhere((m) => m.id == _currentAssistantMessageId);
          if (assistantIndex != -1) {
            final rawContent = _messages[assistantIndex].content;
            final formattedContent = _formatMarkdown(rawContent);
            _messages[assistantIndex] = _messages[assistantIndex].copyWith(
              content: formattedContent,
            );
          }

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
          String errorMsg = error.toString();
          if (error is SocketException || error.toString().contains('SocketException')) {
            errorMsg = 'network_error';
          }
          _safeEmit(AIChatError(
            error: errorMsg,
            messages: _messages,
            remainingFreeChats: _remainingFreeChats,
          ));
        },
      );
    } catch (e) {
      _messages.removeWhere((m) => m.id == _currentAssistantMessageId);
      String errorMsg = e.toString();
      if (e is SocketException || e.toString().contains('SocketException')) {
        errorMsg = 'network_error';
      }
      _safeEmit(AIChatError(
        error: errorMsg,
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
          _safeEmit(AIChatError(
            error: 'ad_not_available',
            messages: _messages,
            remainingFreeChats: _remainingFreeChats,
          ));
        },
      ),
    );
  }

  // ---------- Safe emit ----------
  void _safeEmit(AIChatState state) {
    if (!_isClosed) {
      emit(state);
    }
  }

  // ---------- Helper to update state ----------
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