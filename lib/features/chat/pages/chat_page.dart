// lib/features/chat/pages/chat_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/chat_cubit.dart';
import '../widgets/message_input.dart';
import '../widgets/message_list.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ChatCubit(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Asistente Virtual IA')),
        body: const Column(
          children: [
            Expanded(child: MessageList()),
            MessageInput(),
          ],
        ),
      ),
    );
  }
}
