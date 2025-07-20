// lib/features/admin/pages/dashboard_page.dart
import 'package:chatbot/features/admin/cubit/document_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import '../widgets/upload_widget.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DocumentCubit(GetIt.I())..loadDocuments(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Panel de Administración')),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(padding: EdgeInsets.all(16.0), child: UploadWidget()),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Documentos subidos:',
                style: TextStyle(fontSize: 18),
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: BlocBuilder<DocumentCubit, DocumentState>(
                builder: (context, state) {
                  if (state is DocumentLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is DocumentLoaded) {
                    if (state.documents.isEmpty) {
                      return const Center(child: Text('No hay documentos.'));
                    }
                    return ListView.builder(
                      itemCount: state.documents.length,
                      itemBuilder: (context, index) {
                        final doc = state.documents[index];
                        return ListTile(
                          title: Text(doc['titulo'] ?? 'Sin título'),
                          subtitle: Text(
                            doc['descripcion'] ?? 'Sin descripción',
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.link),
                            onPressed: () {
                              // Abrir URL
                            },
                          ),
                        );
                      },
                    );
                  } else if (state is DocumentError) {
                    return Center(child: Text(state.message));
                  } else {
                    return const SizedBox.shrink();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
