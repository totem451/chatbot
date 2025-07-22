// lib/features/admin/cubit/document_cubit.dart
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:chatbot/core/services/embedding_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:path/path.dart' as p;

part 'document_state.dart';

class DocumentCubit extends Cubit<DocumentState> {
  final FirebaseFirestore firestore;
  final FirebaseStorage storage;
  final embeddingService = GetIt.I<EmbeddingService>();

  DocumentCubit(this.firestore, this.storage) : super(DocumentInitial());

  Future<void> procesarEmbeddings(String docId, String contenido) async {
    const chunkSize = 500;
    final List<String> chunks = [];

    for (var i = 0; i < contenido.length; i += chunkSize) {
      final end = (i + chunkSize < contenido.length)
          ? i + chunkSize
          : contenido.length;
      chunks.add(contenido.substring(i, end));
    }

    for (int i = 0; i < chunks.length; i++) {
      final chunk = chunks[i];
      final vector = await embeddingService.getEmbedding(chunk);

      await firestore
          .collection('documentos')
          .doc(docId)
          .collection('embeddings')
          .add({'chunk': chunk, 'vector': vector, 'index': i});
    }
  }

  Future<void> loadDocuments() async {
    emit(DocumentLoading());
    try {
      final snapshot = await firestore.collection('documentos').get();
      final docs = snapshot.docs.map((doc) => doc.data()).toList();
      emit(DocumentLoaded(docs));
    } catch (e) {
      emit(DocumentError('Error al cargar documentos: \$e'));
    }
  }

  Future<void> uploadDocument() async {
    emit(DocumentLoading());
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );
      if (result == null || result.files.isEmpty) {
        emit(DocumentError('No se seleccionó ningún archivo'));
        return;
      }

      final fileBytes = result.files.first.bytes;
      final fileName = result.files.first.name;
      final fileExt = p.extension(fileName);

      if (fileBytes == null || fileExt != '.pdf') {
        emit(DocumentError('Archivo inválido'));
        return;
      }

      final ref = storage.ref().child('documentos/\$fileName');
      final uploadTask = await ref.putData(fileBytes);
      final url = await uploadTask.ref.getDownloadURL();

      // Extraer texto del PDF
      final pdf = PdfDocument(inputBytes: fileBytes);
      final extractor = PdfTextExtractor(pdf);
      final texto = extractor.extractText();

      await firestore.collection('documentos').add({
        'titulo': fileName,
        'descripcion': 'Documento subido por el admin',
        'url': url,
        'contenido': texto,
        'timestamp': FieldValue.serverTimestamp(),
      });

      final docRef = await firestore.collection('documentos').add({
        'titulo': fileName,
        'descripcion': 'Documento subido por el admin',
        'url': url,
        'contenido': texto,
        'timestamp': FieldValue.serverTimestamp(),
      });

      // Esperamos que termine de generar y guardar los embeddings
      await procesarEmbeddings(docRef.id, texto);

      loadDocuments();
    } catch (e) {
      emit(DocumentError('Error al subir documento: \$e'));
    }
  }
}
