import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';

import '../../features/admin/pages/dashboard_page.dart';
import '../../features/chat/pages/chat_page.dart';
import '../../features/auth/pages/login_page.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: '/', // ahora usamos la raíz
    redirect: (context, state) {
      final user = FirebaseAuth.instance.currentUser;
      final isLoggedIn = user != null;
      final isAdmin = user?.email == 'totem.ledesma@gmail.com';
      final isAdminRoute = state.fullPath == '/admin';

      // Si va a /admin sin loguearse → login
      if (isAdminRoute && !isLoggedIn) return '/login';

      // Si va a /admin logueado pero no es admin → redirige a /chat
      if (isAdminRoute && isLoggedIn && !isAdmin) return '/chat';

      // Si está logueado y va a /login → lo lleva al lugar correspondiente
      if (state.fullPath == '/login' && isLoggedIn) {
        return isAdmin ? '/admin' : '/chat';
      }

      return null;
    },
    routes: [
      GoRoute(path: '/', redirect: (_, __) => '/chat'),
      GoRoute(path: '/chat', builder: (_, __) => const ChatPage()),
      GoRoute(path: '/admin', builder: (_, __) => const DashboardPage()),
      GoRoute(path: '/login', builder: (_, __) => const LoginPage()),
    ],
  );
}
