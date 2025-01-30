import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';


Future<void> showWebScreen({
  required BuildContext context,
  required url,
  bool fullScreen = false,
}) async {
  // final navigator = fullScreen

  await Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => WebScreen(url: url),
    ),
  );
}

class WebScreen extends StatelessWidget {
  final String url;

  const WebScreen({
    super.key,
    required this.url,
  });

  @override
  Widget build(BuildContext context) {

// Register a view factory with a unique identifier

    return Scaffold(
      appBar: AppBar(
        title: const Text('Оплата'),
      ),


      // body: const WebView(
      //   initialUrl: 'https://flutter.io',
      //   javascriptMode: JavascriptMode.unrestricted,
      // ),

      // body: Center(
      //   child: Text(url),
      // ),
    );
  }
}
