import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';

import '../../features/admin/pages/dashboard_page.dart';
import '../../features/chat/pages/chat_page.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: '/chat',
    routes: [
      GoRoute(
        path: '/chat',
        name: 'chat',
        builder: (context, state) => const ChatPage(),
      ),
      GoRoute(
        path: '/admin',
        name: 'admin',
        builder: (context, state) => const DashboardPage(),
      ),
    ],
  );
}
