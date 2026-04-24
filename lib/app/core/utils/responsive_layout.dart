import 'package:flutter/material.dart';
import 'package:metrifica_landing/app/core/theme/theme.dart';

bool isWide(BuildContext context) =>
    MediaQuery.sizeOf(context).width >= kBreakpointWide;

class ResponsiveLayout extends StatelessWidget {
  const ResponsiveLayout({
    super.key,
    required this.mobile,
    required this.web,
  });

  final Widget mobile;
  final Widget web;

  @override
  Widget build(BuildContext context) {
    return isWide(context) ? web : mobile;
  }
}
