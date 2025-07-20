import 'dart:convert';
import 'package:http/http.dart' as http;

class OpenAIService {
  final String apiKey;

  OpenAIService(this.apiKey);

  Future<String> getChatResponse(
    String message, {
    List<Map<String, String>>? context,
  }) async {
    final url = Uri.parse("https://api.openai.com/v1/chat/completions");

    final headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer $apiKey",
    };

    final messages = <Map<String, String>>[
      {
        "role": "system",
        "content":
            "Sos un asistente virtual para clientes de una empresa energética. Respondé de forma clara, profesional y solo con base en la información disponible.",
      },
      ...?context,
      {"role": "user", "content": message},
    ];

    final body = jsonEncode({
      "model": "gpt-3.5-turbo",
      "messages": messages,
      "temperature": 0.4,
    });

    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final reply = data['choices'][0]['message']['content'];
      return reply.trim();
    } else {
      throw Exception("Error al consultar OpenAI: ${response.body}");
    }
  }
}
