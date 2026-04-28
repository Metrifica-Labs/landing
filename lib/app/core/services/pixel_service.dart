import 'dart:js_interop';

@JS('metrificaFormStart')
external void _jsFormStart();

@JS('metrificaFormSubmit')
external void _jsFormSubmit();

class PixelService {
  static void formStart() {
    try {
      _jsFormStart();
    } catch (_) {}
  }

  static void formSubmit() {
    try {
      _jsFormSubmit();
    } catch (_) {}
  }
}
