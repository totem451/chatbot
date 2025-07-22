import 'dart:convert';
import 'package:http/http.dart' as http;

class EmbeddingService {
  final String apiKey;

  EmbeddingService(this.apiKey);

  Future<List<double>> getEmbedding(String input) async {
    final url = Uri.parse("https://api.openai.com/v1/embeddings");
    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $apiKey',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({"input": input, "model": "text-embedding-ada-002"}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return List<double>.from(data['data'][0]['embedding']);
    } else {
      throw Exception('Error al obtener embedding: ${response.body}');
    }
  }
}
