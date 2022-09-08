import 'package:flutter/material.dart';
import 'package:gren_mart/view/utils/app_bars.dart';
import 'package:path/path.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewScreen extends StatelessWidget {
  static const String routeName = 'web view screen';
  WebViewScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final routeData = ModalRoute.of(context)!.settings.arguments as List;
    final url = routeData[0];
    return Scaffold(
      appBar: AppBars().appBarTitled('', () {
        Navigator.of(context).pop();
      }),
      body: WebView(
        initialUrl: url,
        javascriptMode: JavascriptMode.unrestricted,
        navigationDelegate: (_) {
          return NavigationDecision.prevent;
        },
      ),
    );
  }
}
