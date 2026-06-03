import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:metrifica_landing/app/pages/contact/contact_page.dart';
import 'package:metrifica_landing/app/pages/home/home_page.dart';
import 'package:metrifica_landing/app/pages/lp1/lp1_page.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/lp-1',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: '/contato',
        builder: (context, state) => const ContactPage(),
      ),
      GoRoute(
        path: '/lp-1',
        builder: (context, state) => const Lp1Page(),
      ),
    ],
  );
});
