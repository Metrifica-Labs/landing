import 'package:flutter/material.dart';
import 'package:metrifica_landing/app/core/utils/responsive_layout.dart';
import 'package:metrifica_landing/app/pages/home/layouts/mobile/home_mobile_layout.dart';
import 'package:metrifica_landing/app/pages/home/layouts/web/home_web_layout.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const ResponsiveLayout(
      mobile: HomeMobileLayout(),
      web: HomeWebLayout(),
    );
  }
}
