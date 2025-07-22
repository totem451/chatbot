// lib/core/di/service_locator.dart
import 'package:chatbot/core/services/chat_service.dart';
import 'package:chatbot/core/services/embedding_service.dart';
import 'package:chatbot/core/services/openai_service.dart';
import 'package:chatbot/core/services/search_service.dart';
import 'package:get_it/get_it.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

final getIt = GetIt.instance;

void setupLocator() {
  getIt.registerLazySingleton(() => FirebaseAuth.instance);
  getIt.registerLazySingleton(() => FirebaseFirestore.instance);
  getIt.registerLazySingleton(() => FirebaseStorage.instance);

  // Luego: cubits, servicios propios, IA, etc.
  // getIt.registerFactory(() => DocumentCubit(getIt()));

  getIt.registerLazySingleton(() => OpenAIService("TU_API_KEY_ACÁ"));
  getIt.registerLazySingleton(() => EmbeddingService("TU_API_KEY_DE_OPENAI"));
  getIt.registerLazySingleton(() => SearchService());
  getIt.registerLazySingleton(() => ChatService());
}
