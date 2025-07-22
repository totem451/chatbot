import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';

import 'embedding_service.dart';

class SearchService {
  final firestore = FirebaseFirestore.instance;
  final embeddingService = GetIt.I<EmbeddingService>();

  // Paso 1: genera el vector de la pregunta
  Future<List<Map<String, dynamic>>> buscarContexto(
    String pregunta, {
    int maxChunks = 5,
  }) async {
    final inputVector = await embeddingService.getEmbedding(pregunta);

    final chunks = <Map<String, dynamic>>[];

    final docsSnapshot = await firestore.collection('documentos').get();
    for (var doc in docsSnapshot.docs) {
      final embeddingsSnapshot = await doc.reference
          .collection('embeddings')
          .get();
      for (var emb in embeddingsSnapshot.docs) {
        final data = emb.data();
        final vector = List<double>.from(data['vector']);
        final score = _cosineSimilarity(inputVector, vector);
        chunks.add({'chunk': data['chunk'], 'score': score});
      }
    }

    // Ordenamos por mayor score (más similar)
    chunks.sort((a, b) => b['score'].compareTo(a['score']));
    return chunks.take(maxChunks).toList();
  }

  double _cosineSimilarity(List<double> a, List<double> b) {
    double dot = 0, magA = 0, magB = 0;
    for (int i = 0; i < a.length; i++) {
      dot += a[i] * b[i];
      magA += a[i] * a[i];
      magB += b[i] * b[i];
    }
    if (magA == 0 || magB == 0) return 0;
    return dot / (sqrt(magA) * sqrt(magB));
  }
}
