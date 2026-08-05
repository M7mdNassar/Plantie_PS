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
import '../ai_chat_service.dart';
import 'ai_chat_state.dart';

class AIChatCubit extends Cubit<AIChatState> {
  final AIChatService _service = AIChatService();
  final ChatHistoryDB _db = ChatHistoryDB();
  String _conversationId;
  String _sessionId;
  List<ChatMessage> _messages = [];
  StreamSubscription<String>? _subscription;
  String? _currentAssistantMessageId;
  List<String> _currentSuggestions = [];

  // Ad related
  RewardedAd? _rewardedAd;
  int _remainingFreeChats = 0;
  static const String _prefKey = 'remaining_free_chats';
  bool _isAdLoading = false;
  bool _isClosed = false;
  bool isLoadingRemaining = true;

  // Conversation list (stored locally)
  List<Map<String, dynamic>> _conversations = [];

  AIChatCubit({String? conversationId, String? sessionId})
      : _conversationId = conversationId ?? const Uuid().v4(),
        _sessionId = sessionId ?? const Uuid().v4(),
        super(const AIChatInitial(remainingFreeChats: 0)) {
    _loadRemainingChats();
    _loadConversation();
    loadConversations();
  }

  String get conversationId => _conversationId;
  String get sessionId => _sessionId;

  // ─── Public getter for conversations ────────────────────────────
  List<Map<String, dynamic>> get conversations => _conversations;

  // ─── Conversation list ──────────────────────────────────────────
  Future<void> loadConversations() async {
    _conversations = await _service.getConversations();
    final currentState = state;
    emit(AIChatInitial(
      messages: currentState.messages,
      sessionId: currentState.sessionId,
      remainingFreeChats: currentState.remainingFreeChats,
      conversations: _conversations,
      suggestions: currentState.suggestions,
    ));
  }

  Future<void> deleteConversation(String id) async {
    final success = await _service.deleteConversation(id);
    if (success) {
      if (id == _conversationId) {
        _messages.clear();
        _conversationId = const Uuid().v4();
        await _db.deleteConversation(id);
        emit(AIChatInitial(
          messages: [],
          sessionId: _sessionId,
          remainingFreeChats: _remainingFreeChats,
          conversations: _conversations,
          suggestions: [],
        ));
      }
      await loadConversations();
    }
  }

  void switchToConversation(String id) {
    if (id == _conversationId) return;
    _conversationId = id;
    _messages.clear();
    _currentSuggestions = [];
    _loadConversation();
  }

  // ─── Persistence ────────────────────────────────────────────────
  Future<void> _loadConversation() async {
    final messages = await _db.getConversation(_conversationId);
    if (messages != null && messages.isNotEmpty) {
      _messages = messages;
      emit(AIChatInitial(
        messages: _messages,
        sessionId: _sessionId,
        remainingFreeChats: _remainingFreeChats,
        conversations: _conversations,
        suggestions: _currentSuggestions,
      ));
    }
  }

  Future<void> _saveConversation() async {
    await _db.saveConversation(_conversationId, _messages);
  }

  // ─── Remaining chats ────────────────────────────────────────────
  Future<void> _loadRemainingChats() async {
    isLoadingRemaining = true;
    final prefs = await SharedPreferences.getInstance();

    final localCount = prefs.getInt(_prefKey);
    if (localCount != null) {
      _remainingFreeChats = localCount;
      isLoadingRemaining = false;
      _updateStateWithRemaining();
    }

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
        debugPrint('✅ Free chat attempts synced: $_remainingFreeChats');
      } catch (e) {
        debugPrint('⚠️ Failed to sync free chat attempts: $e');
        if (localCount == null) {
          _remainingFreeChats = 3;
        }
      }
    } else if (localCount == null) {
      _remainingFreeChats = 3;
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
    } catch (e) {
      debugPrint('⚠️ Failed to sync free chat attempts: $e');
    }
  }

  // ─── Ad ──────────────────────────────────────────────────────────
  void watchAdToGetMore() {
    if (_isAdLoading || _isClosed) return;
    if (_remainingFreeChats > 0) return;
    emit(AIChatAdLoading(
      messages: _messages,
      remainingFreeChats: _remainingFreeChats,
      conversations: _conversations,
      suggestions: _currentSuggestions,
    ));
    _showRewardedAd();
  }

  // ─── Send message ───────────────────────────────────────────────
  void sendMessage(String text, {Map<String, dynamic>? weather}) {
    if (_isClosed) return;
    if (text.trim().isEmpty) return;

    if (!AppConfig.isChatEnabled) {
      emit(AIChatError(
        error: 'Chat is currently disabled.',
        messages: _messages,
        remainingFreeChats: _remainingFreeChats,
        conversations: _conversations,
        suggestions: _currentSuggestions,
      ));
      return;
    }

    if (_remainingFreeChats <= 0) {
      return;
    }

    // Consume one free chat
    _remainingFreeChats--;
    _saveRemainingChats(_remainingFreeChats);
    _updateStateWithRemaining();

    final userMessage = ChatMessage.user(text.trim());
    _messages.add(userMessage);

    final assistantPlaceholder = ChatMessage.assistant('');
    _messages.add(assistantPlaceholder);
    _currentAssistantMessageId = assistantPlaceholder.id;

    // Clear old suggestions while streaming
    _currentSuggestions = [];

    emit(AIChatLoading(
      messages: _messages,
      remainingFreeChats: _remainingFreeChats,
      conversations: _conversations,
      suggestions: _currentSuggestions,
    ));

    final user = CurrentUser.user;
    if (user == null) {
      // Should not happen; fallback to anonymous or show error.
      emit(AIChatError(
        error: 'User not authenticated',
        messages: _messages,
        remainingFreeChats: _remainingFreeChats,
        conversations: _conversations,
        suggestions: _currentSuggestions,
      ));
      return;
    }

    _subscription = _service.sendMessage(
      message: text,
      conversationId: _conversationId,
      sessionId: _sessionId,
      userId: user.id,
      latitude: 0,
      longitude: 0,
      weather: weather,
    ).listen(
          (chunk) {
            final index = _messages.indexWhere((m) => m.id == _currentAssistantMessageId);
            if (index != -1) {
              String currentContent = _messages[index].content + chunk;
              _messages[index] = _messages[index].copyWith(content: currentContent);

          emit(AIChatStreaming(
            messages: _messages,
            partialResponse: currentContent,
            remainingFreeChats: _remainingFreeChats,
            conversations: _conversations,
            suggestions: _currentSuggestions,
          ));
        }
      },
      onDone: () {
        _subscription?.cancel();
        _subscription = null;

        final assistantIndex = _messages.indexWhere((m) => m.id == _currentAssistantMessageId);
        if (assistantIndex != -1) {
          String raw = _messages[assistantIndex].content;
          // Extract suggestions by splitting on newlines and looking for "- "
          final lines = raw.split('\n');
          final suggestionLines = <String>[];
          final contentLines = <String>[];
          for (var line in lines) {
            final trimmed = line.trim();
            if (trimmed.startsWith('- ')) {
              suggestionLines.add(trimmed.substring(2).trim());
            } else {
              contentLines.add(line);
            }
          }
          // If no suggestions found, try a fallback regex to find "- " anywhere
          if (suggestionLines.isEmpty) {
            final regex = RegExp(r'-\s+([^\n]+)');
            final matches = regex.allMatches(raw);
            if (matches.isNotEmpty) {
              for (var match in matches) {
                suggestionLines.add(match.group(1)?.trim() ?? '');
              }
              // Remove all "- " patterns from the content
              String cleaned = raw.replaceAll(regex, '');
              // Remove trailing dashes and clean up
              cleaned = cleaned.replaceAll(RegExp(r'-\s*$'), '').trim();
              contentLines.clear();
              contentLines.add(cleaned);
            }
          }
          final cleanedContent = contentLines.join('\n').trim();
          _currentSuggestions = suggestionLines;
          _messages[assistantIndex] = _messages[assistantIndex].copyWith(
            content: cleanedContent,
          );
        }

        _saveConversation();
        emit(AIChatSuccess(
          messages: _messages,
          remainingFreeChats: _remainingFreeChats,
          conversations: _conversations,
          suggestions: _currentSuggestions,
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
        emit(AIChatError(
          error: errorMsg,
          messages: _messages,
          remainingFreeChats: _remainingFreeChats,
          conversations: _conversations,
          suggestions: _currentSuggestions,
        ));
      },
    );
  }

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

  // ─── Ad loading ──────────────────────────────────────────────────
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
              emit(AIChatAdRewardSuccess(
                messages: _messages,
                remainingFreeChats: _remainingFreeChats,
                conversations: _conversations,
                suggestions: _currentSuggestions,
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
              emit(AIChatError(
                error: 'ad_failed_to_show',
                messages: _messages,
                remainingFreeChats: _remainingFreeChats,
                conversations: _conversations,
                suggestions: _currentSuggestions,
              ));
            },
          );
        },
        onAdFailedToLoad: (LoadAdError error) {
          _isAdLoading = false;
          emit(AIChatError(
            error: 'ad_not_available',
            messages: _messages,
            remainingFreeChats: _remainingFreeChats,
            conversations: _conversations,
            suggestions: _currentSuggestions,
          ));
        },
      ),
    ).catchError((error) {
      _isAdLoading = false;
      emit(AIChatError(
        error: 'ad_not_available',
        messages: _messages,
        remainingFreeChats: _remainingFreeChats,
        conversations: _conversations,
        suggestions: _currentSuggestions,
      ));
    });
  }

  void _safeEmit(AIChatState state) {
    if (!_isClosed) emit(state);
  }

  void _updateStateWithRemaining() {
    final currentState = state;
    if (currentState is AIChatInitial) {
      emit(AIChatInitial(
        messages: currentState.messages,
        sessionId: currentState.sessionId,
        remainingFreeChats: _remainingFreeChats,
        conversations: _conversations,
        suggestions: _currentSuggestions,
      ));
    } else if (currentState is AIChatLoading) {
      emit(AIChatLoading(
        messages: currentState.messages,
        remainingFreeChats: _remainingFreeChats,
        conversations: _conversations,
        suggestions: _currentSuggestions,
      ));
    } else if (currentState is AIChatStreaming) {
      emit(AIChatStreaming(
        messages: currentState.messages,
        partialResponse: currentState.partialResponse,
        remainingFreeChats: _remainingFreeChats,
        conversations: _conversations,
        suggestions: _currentSuggestions,
      ));
    } else if (currentState is AIChatSuccess) {
      emit(AIChatSuccess(
        messages: currentState.messages,
        remainingFreeChats: _remainingFreeChats,
        conversations: _conversations,
        suggestions: _currentSuggestions,
      ));
    } else if (currentState is AIChatError) {
      emit(AIChatError(
        error: currentState.error,
        messages: currentState.messages,
        remainingFreeChats: _remainingFreeChats,
        conversations: _conversations,
        suggestions: _currentSuggestions,
      ));
    } else if (currentState is AIChatAdRewardSuccess) {
      emit(AIChatAdRewardSuccess(
        messages: currentState.messages,
        remainingFreeChats: _remainingFreeChats,
        conversations: _conversations,
        suggestions: _currentSuggestions,
      ));
    } else if (currentState is AIChatAdLoading) {
      emit(AIChatAdLoading(
        messages: currentState.messages,
        remainingFreeChats: _remainingFreeChats,
        conversations: _conversations,
        suggestions: _currentSuggestions,
      ));
    }
  }

  void clearConversation() {
    _subscription?.cancel();
    _subscription = null;
    _messages.clear();
    _currentSuggestions = [];
    _db.deleteConversation(_conversationId);
    emit(AIChatInitial(
      messages: [],
      sessionId: _sessionId,
      remainingFreeChats: _remainingFreeChats,
      conversations: _conversations,
      suggestions: _currentSuggestions,
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