// lib/features/chat/cubit/chat_cubit.dart
import 'package:bloc/bloc.dart';
import 'package:chatbot/core/services/openai_service.dart';
import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';

part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  ChatCubit() : super(ChatInitial());

  final List<ChatMessage> messages = [];
  final OpenAIService openAI = GetIt.I<OpenAIService>();

  void sendMessage(String text) async {
    messages.add(ChatMessage(text, isUser: true));
    emit(ChatUpdated(List.from(messages)));
    emit(ChatTyping());

    try {
      final reply = await openAI.getChatResponse(text);
      messages.add(ChatMessage(reply, isUser: false));
    } catch (e) {
      messages.add(
        ChatMessage("⚠️ Error al consultar la IA: $e", isUser: false),
      );
    }

    emit(ChatUpdated(List.from(messages)));
  }
}
