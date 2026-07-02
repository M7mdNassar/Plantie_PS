import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:plantie/config/app_config.dart';
import 'package:plantie/shared/network/remote/supabase_service.dart';

class AIChatService {
  static String get _baseUrl => AppConfig.chatBaseUrl;
  static String get _chatEndpoint => AppConfig.chatEndpoint;

  Stream<String> sendMessage({
    required String query,
    required String sessionId,
    required String userId,
    required double latitude,
    required double longitude,
  }) async* {
    // First check if chat feature is enabled (config)
    if (!AppConfig.isChatEnabled) {
      yield 'Chat is currently unavailable. Please try again later.';
      return;
    }

    // Check that baseUrl and endpoint are not empty (config may be missing)
    if (_baseUrl.isEmpty || _chatEndpoint.isEmpty) {
      yield 'Chat service is not configured. Please try again later.';
      return;
    }

    // Debug: log the actual URL being used
    final url = Uri.parse('$_baseUrl$_chatEndpoint');
    print('🔗 [AIChatService] Using URL: $url');

    // Get Supabase JWT token
    final session = supabaseService.client.auth.currentSession;
    String? token = session?.accessToken;

    print('🔑 [AIChatService] Supabase JWT Token:');
    print(token ?? 'No token found (offline)');

    if (token == null) {
      try {
        await supabaseService.client.auth.refreshSession();
        final refreshed = supabaseService.client.auth.currentSession;
        token = refreshed?.accessToken;
      } catch (_) {
        // Offline
      }
    }

    final body = jsonEncode({
      'query': query,
      'session_id': sessionId,
      'user_id': userId,
      'location': {
        'latitude': latitude,
        'longitude': longitude,
      },
      'history': [],
      'top_k': 5,
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
        final data = line.substring(6).trim();
        if (data.isNotEmpty && data != '[DONE]') {
          try {
            final json = jsonDecode(data);
            final content = json['content'] ?? json['delta'] ?? json['text'] ?? data;
            yield content.toString();
          } catch (_) {
            yield data;
          }
        }
      } else if (line.isNotEmpty && !line.startsWith(':')) {
        if (!line.startsWith('event:') && !line.startsWith('id:')) {
          yield line;
        }
      }
    }
  }
}