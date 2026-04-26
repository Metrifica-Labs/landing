// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
// ignore: avoid_web_libraries_in_flutter
import 'dart:js' as js;
import 'dart:ui_web' as ui_web;

import 'package:flutter/material.dart';

class Hero3DScene extends StatefulWidget {
  const Hero3DScene({super.key});

  @override
  State<Hero3DScene> createState() => _Hero3DSceneState();
}

class _Hero3DSceneState extends State<Hero3DScene> {
  static int _counter = 0;
  late final String _viewType;

  void _initWhenJsReady(html.DivElement container, [int attempt = 0]) {
    if (js.context.hasProperty('initHero3D')) {
      js.context.callMethod('initHero3D', [container]);
      return;
    }
    if (attempt > 240) {
      debugPrint('[hero3d] initHero3D not available after waiting.');
      return;
    }
    html.window.requestAnimationFrame((_) {
      _initWhenJsReady(container, attempt + 1);
    });
  }

  @override
  void initState() {
    super.initState();
    _viewType = 'hero3d-view-${_counter++}';

    ui_web.platformViewRegistry.registerViewFactory(_viewType, (int viewId) {
      final container = html.DivElement()
        ..style.width = '100%'
        ..style.height = '100%'
        ..style.overflow = 'hidden';

      html.window.requestAnimationFrame((_) {
        _initWhenJsReady(container);
      });

      return container;
    });
  }

  @override
  Widget build(BuildContext context) {
    return HtmlElementView(viewType: _viewType);
  }
}
