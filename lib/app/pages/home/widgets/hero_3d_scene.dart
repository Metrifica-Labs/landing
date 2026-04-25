// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
// ignore: avoid_web_libraries_in_flutter
import 'dart:js' as js;
import 'dart:ui_web' as ui_web;

import 'package:flutter/material.dart';

/// Embeds the Three.js crystal-cube 3D scene via an HtmlElementView.
/// Only works on Flutter Web.
class Hero3DScene extends StatefulWidget {
  const Hero3DScene({super.key, this.variant = 'hero'});

  final String variant;

  @override
  State<Hero3DScene> createState() => _Hero3DSceneState();
}

class _Hero3DSceneState extends State<Hero3DScene> {
  static int _counter = 0;
  late final String _viewType;

  void _initWhenJsReady(html.DivElement container, [int attempt = 0]) {
    if (js.context.hasProperty('initHero3D')) {
      js.context.callMethod('initHero3D', [container, _options]);
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

      // Give Flutter one frame to insert the element into the DOM,
      // then initialise Three.js. The JS function internally retries
      // via requestAnimationFrame until the element has real dimensions.
      html.window.requestAnimationFrame((_) {
        _initWhenJsReady(container);
      });

      return container;
    });
  }

  late final js.JsObject _options = js.JsObject.jsify({
    'variant': widget.variant,
  });

  @override
  Widget build(BuildContext context) {
    return HtmlElementView(viewType: _viewType);
  }
}
