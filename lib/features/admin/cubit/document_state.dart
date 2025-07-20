// lib/features/admin/cubit/document_state.dart
part of 'document_cubit.dart';

@immutable
abstract class DocumentState {}

class DocumentInitial extends DocumentState {}

class DocumentLoading extends DocumentState {}

class DocumentLoaded extends DocumentState {
  final List<Map<String, dynamic>> documents;
  DocumentLoaded(this.documents);
}

class DocumentError extends DocumentState {
  final String message;
  DocumentError(this.message);
}
