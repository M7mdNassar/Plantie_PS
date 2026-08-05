import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:plantie/config/app_config.dart';
import 'package:plantie/shared/network/remote/supabase_service.dart';

class AIChatService {
  static String get _baseUrl => AppConfig.chatBaseUrl;
  static String get _chatEndpoint => AppConfig.chatEndpoint;

  // ─── Chat streaming ──────────────────────────────────────────────
  Stream<String> sendMessage({
    required String message,
    required String conversationId,
    required String sessionId,
    required String userId,
    required double latitude,
    required double longitude,
    Map<String, dynamic>? weather,
  }) async* {
    if (!AppConfig.isChatEnabled) {
      yield 'Chat is currently unavailable.';
      return;
    }
    if (_baseUrl.isEmpty || _chatEndpoint.isEmpty) {
      yield 'Chat service is not configured.';
      return;
    }

    final url = Uri.parse('$_baseUrl$_chatEndpoint');

    final token = await _getToken();
    final body = jsonEncode({
      'message': message,
      'conversation_id': conversationId,
      'session_id': sessionId,
      'location': {'latitude': latitude, 'longitude': longitude},
      'weather': weather, // will be null if not provided
    });

    final request = http.Request('POST', url)
      ..headers.addAll({
        'Content-Type': 'application/json',
        'Accept': 'text/event-stream',
        if (token != null) 'Authorization': 'Bearer $token',
      })
      ..body = body;

    http.StreamedResponse? streamedResponse;
    try {
      streamedResponse = await request.send();
    } catch (e) {
      yield 'Network error: Could not reach chat service.';
      return;
    }

    if (streamedResponse.statusCode == 401) {
      yield 'Authentication failed. Please try again.';
      return;
    }
    if (streamedResponse.statusCode != 200) {
      final errorBody = await streamedResponse.stream.bytesToString();
      yield 'Server error: ${streamedResponse.statusCode} - $errorBody';
      return;
    }

    final stream = streamedResponse.stream
        .transform(utf8.decoder)
        .transform(const LineSplitter());

    await for (final line in stream) {
      if (line.startsWith('data: ')) {
        final data = line.substring(6);
        if (data.trim() == '[DONE]') break;
        if (data.isNotEmpty) {
          try {
            final json = jsonDecode(data);
            final content = json['content'] ?? json['delta'] ?? json['text'];
            if (content != null) yield content.toString();
            else yield data;
          } catch (_) {
            // Only reached for a non-JSON backend response — don't trim
            // here either, a raw chunk's leading/trailing space is real
            // content, not incidental whitespace.
            yield data;
          }
        }
      }
    }
  }

  // ─── Conversation list ──────────────────────────────────────────
  Future<List<Map<String, dynamic>>> getConversations({int limit = 20}) async {
    final token = await _getToken();
    final url = Uri.parse('$_baseUrl/api/v1/chat/conversations?limit=$limit');
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return List<Map<String, dynamic>>.from(data['conversations'] ?? []);
    }
    return [];
  }

  // ─── Delete conversation ────────────────────────────────────────
  Future<bool> deleteConversation(String conversationId) async {
    final token = await _getToken();
    final url = Uri.parse('$_baseUrl/api/v1/chat/conversations/$conversationId');
    final response = await http.delete(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    return response.statusCode == 200;
  }

  // ─── Helper ──────────────────────────────────────────────────────
  Future<String?> _getToken() async {
    final session = supabaseService.client.auth.currentSession;
    String? token = session?.accessToken;
    if (token == null) {
      try {
        await supabaseService.client.auth.refreshSession();
        final refreshed = supabaseService.client.auth.currentSession;
        token = refreshed?.accessToken;
      } catch (_) {}
    }
    return token;
  }
}