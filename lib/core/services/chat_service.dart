import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get_it/get_it.dart';

import 'search_service.dart';

class ChatService {
  final _searchService = GetIt.I<SearchService>();
  final _apiKey = 'TU_API_KEY_DE_OPENAI';

  Future<String> responderConContexto(String pregunta) async {
    // 1. Buscar contexto más relevante
    final resultados = await _searchService.buscarContexto(pregunta);

    final contexto = resultados.map((r) => r['chunk']).join("\n\n");

    final prompt =
        """
Sos un asistente inteligente para responder preguntas de clientes de una empresa energética.
Respondé siempre de forma clara y profesional, basándote únicamente en los siguientes documentos:

$contexto

Usuario: $pregunta
Asistente:
""";

    // 2. Llamar a OpenAI completions
    final url = Uri.parse('https://api.openai.com/v1/chat/completions');

    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $_apiKey',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "model": "gpt-3.5-turbo",
        "messages": [
          {
            "role": "system",
            "content":
                "Sos un asistente que responde preguntas con base en documentos técnicos.",
          },
          {"role": "user", "content": prompt},
        ],
        "temperature": 0.3,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final text = data['choices'][0]['message']['content'];
      return text.trim();
    } else {
      throw Exception('Error de OpenAI: ${response.body}');
    }
  }
}
