// lib/features/admin/widgets/upload_widget.dart
import 'package:chatbot/features/admin/cubit/document_cubit.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UploadWidget extends StatelessWidget {
  const UploadWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () => context.read<DocumentCubit>().uploadDocument(),
      icon: const Icon(Icons.upload_file),
      label: const Text('Subir documento PDF'),
    );
  }
}
