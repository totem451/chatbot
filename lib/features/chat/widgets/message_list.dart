// lib/features/chat/widgets/message_list.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/chat_cubit.dart';

class MessageList extends StatelessWidget {
  const MessageList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatCubit, ChatState>(
      builder: (context, state) {
        final messages = state is ChatUpdated ? state.messages : [];
        final typing = state is ChatTyping;

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: messages.length + (typing ? 1 : 0),
          itemBuilder: (context, index) {
            if (index == messages.length && typing) {
              return const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Escribiendo...',
                  style: TextStyle(color: Colors.grey),
                ),
              );
            }
            final msg = messages[index];
            return Align(
              alignment: msg.isUser
                  ? Alignment.centerRight
                  : Alignment.centerLeft,
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 4),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: msg.isUser ? Colors.cyan : Colors.grey[800],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  msg.text,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
