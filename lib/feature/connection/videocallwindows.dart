import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class VideoCallWindows extends StatefulWidget {
  @override
  _VideoCallWindowsState createState() => _VideoCallWindowsState();
}

class _VideoCallWindowsState extends State<VideoCallWindows> {
  late InAppWebViewController webViewController;

  final String _url = "https://meet.jit.si/seezmeTestRoom_";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Seezme")),
      body: InAppWebView(
        initialUrlRequest: URLRequest(
          url: WebUri(_url),
        ),
        onWebViewCreated: (controller) {
          webViewController = controller;
        },
        initialSettings: InAppWebViewSettings(
          userAgent:
              "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36",
        ),
        onPermissionRequest: (controller, request) async {
          return PermissionResponse(
            resources: request.resources,
            action: PermissionResponseAction.GRANT,
          );
        },
      ),
    );
  }
}
