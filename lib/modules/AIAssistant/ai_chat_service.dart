import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class AIChatService {
  static const String _baseUrl = 'https://plantie-rag-agent-production.up.railway.app';
  static const String _chatEndpoint = '/api/v1/chat/stream-temp';

  Stream<String> sendMessage({
    required String query,
    required String sessionId,
    required String userId,
    required double latitude,
    required double longitude,
  }) async* {
    final url = Uri.parse('$_baseUrl$_chatEndpoint');
    final body = jsonEncode({
      'query': query,
      'session_id': sessionId,
      'user_id': userId,
      'location': {
        'latitude': latitude,
        'longitude': longitude,
      },
      'history': [], // Could pass previous messages if needed
      'top_k': 5,
    });

    final request = http.Request('POST', url)
      ..headers.addAll({
        'Content-Type': 'application/json',
        'Accept': 'text/event-stream',
      })
      ..body = body;

    final streamedResponse = await request.send();

    if (streamedResponse.statusCode != 200) {
      final errorBody = await streamedResponse.stream.bytesToString();
      throw Exception('Server error: ${streamedResponse.statusCode} - $errorBody');
    }

    // Parse Server-Sent Events or chunked JSON
    // Assuming the endpoint returns SSE or plain text chunks.
    // We'll parse line by line.
    final stream = streamedResponse.stream
        .transform(utf8.decoder)
        .transform(const LineSplitter());

    String buffer = '';
    await for (final line in stream) {
      if (line.startsWith('data: ')) {
        final data = line.substring(6).trim();
        if (data.isNotEmpty && data != '[DONE]') {
          // If it's JSON, extract the content. Otherwise, treat as plain text.
          try {
            final json = jsonDecode(data);
            final content = json['content'] ?? json['delta'] ?? json['text'] ?? data;
            yield content.toString();
          } catch (_) {
            // If not JSON, yield the raw data
            yield data;
          }
        }
      } else if (line.isNotEmpty && !line.startsWith(':')) {
        // Some APIs send raw text without "data:" prefix.
        // If it's plain text, yield it.
        if (!line.startsWith('event:') && !line.startsWith('id:')) {
          yield line;
        }
      }
    }
  }
}