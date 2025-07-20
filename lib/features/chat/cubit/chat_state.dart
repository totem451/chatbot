// lib/features/chat/cubit/chat_state.dart
part of 'chat_cubit.dart';

@immutable
abstract class ChatState {}

class ChatInitial extends ChatState {}

class ChatUpdated extends ChatState {
  final List<ChatMessage> messages;
  ChatUpdated(this.messages);
}

class ChatTyping extends ChatState {}

class ChatMessage {
  final String text;
  final bool isUser;
  ChatMessage(this.text, {this.isUser = false});
}
