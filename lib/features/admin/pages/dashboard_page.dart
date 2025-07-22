// lib/features/admin/pages/dashboard_page.dart
import 'package:chatbot/features/admin/widgets/upload_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../cubit/document_cubit.dart';
import '../../../core/di/service_locator.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null || user.email != 'totem.ledesma@gmail.com') {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.go('/login');
      });
      return const SizedBox();
    }

    return BlocProvider(
      create: (_) => DocumentCubit(getIt(), getIt())..loadDocuments(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Panel de Administración'),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                if (context.mounted) context.go('/login');
              },
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              UploadWidget(),
              const SizedBox(height: 20),
              const Text(
                'Documentos cargados:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: BlocBuilder<DocumentCubit, DocumentState>(
                  builder: (context, state) {
                    if (state is DocumentLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is DocumentLoaded) {
                      final docs = state.docs;
                      if (docs.isEmpty) {
                        return const Text('No hay documentos cargados.');
                      }
                      return ListView.separated(
                        itemCount: docs.length,
                        separatorBuilder: (_, __) => const Divider(),
                        itemBuilder: (_, index) {
                          final doc = docs[index];
                          return ListTile(
                            title: Text(doc['titulo'] ?? 'Sin título'),
                            subtitle: Text(
                              doc['descripcion'] ?? '',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.open_in_new),
                              onPressed: () {
                                final url = doc['url'];
                                if (url != null) {
                                  launchUrl(Uri.parse(url));
                                }
                              },
                            ),
                          );
                        },
                      );
                    } else if (state is DocumentError) {
                      return Text(state.message);
                    }
                    return const SizedBox();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
