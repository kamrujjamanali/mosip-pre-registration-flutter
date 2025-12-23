import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class CaptchaWidget extends StatefulWidget {
  final String siteKey;
  final bool resetCaptcha;
  final ValueChanged<String?> onCaptchaEvent;

  const CaptchaWidget({
    super.key,
    required this.siteKey,
    required this.resetCaptcha,
    required this.onCaptchaEvent,
  });

  @override
  State<CaptchaWidget> createState() => _CaptchaWidgetState();
}

class _CaptchaWidgetState extends State<CaptchaWidget> {
  // WebViewController? _controller;

  @override
  void didUpdateWidget(covariant CaptchaWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    // if (widget.resetCaptcha && _controller != null) {
    //   _controller!.runJavascript('resetCaptcha();');
    // }
  }

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 120,
      // child: WebView(
      //   javascriptMode: JavaScriptMode.unrestricted,
      //   initialUrl: 'about:blank',
      //   javascriptChannels: {
      //     JavaScriptChannel(
      //       name: 'CaptchaChannel',
      //       onMessageReceived: (JavaScriptMessage message) {
      //         widget.onCaptchaEvent(message.message);
      //       },
      //     ),
      //   },
      //   onWebViewCreated: (WebViewController controller) {
      //     _controller = controller;
      //     controller.loadFlutterAsset('assets/captcha.html');
      //   },
      // ),
    );
  }
}
