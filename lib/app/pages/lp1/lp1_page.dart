import 'package:flutter/material.dart';
import 'package:metrifica_landing/app/core/utils/responsive_layout.dart';
import 'package:metrifica_landing/app/pages/lp1/layouts/mobile/lp1_mobile_layout.dart';
import 'package:metrifica_landing/app/pages/lp1/layouts/web/lp1_web_layout.dart';

class Lp1Page extends StatelessWidget {
  const Lp1Page({super.key});

  @override
  Widget build(BuildContext context) {
    return const ResponsiveLayout(
      mobile: Lp1MobileLayout(),
      web: Lp1WebLayout(),
    );
  }
}
