// lib/features/admin/cubit/document_cubit.dart
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

part 'document_state.dart';

class DocumentCubit extends Cubit<DocumentState> {
  final FirebaseFirestore firestore;

  DocumentCubit(this.firestore) : super(DocumentInitial());

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

  Future<void> addMockDocument() async {
    await firestore.collection('documentos').add({
      'titulo': 'Documento de prueba',
      'descripcion': 'Este es un documento mock',
      'url': 'https://example.com/mock.pdf',
    });
    loadDocuments();
  }
}
