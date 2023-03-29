import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:http/http.dart' as http;

class WebViewPage extends StatefulWidget {
  const WebViewPage({super.key});

  @override
  State<WebViewPage> createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  var loadingPercentage = 0;
  late final WebViewController controller;

  static const String htmlFilePath = 'assets/file.html';

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setNavigationDelegate(NavigationDelegate(
        onPageStarted: (url) {
          setState(() {
            loadingPercentage = 0;
          });
        },
        onProgress: (progress) {
          setState(() {
            loadingPercentage = progress;
          });
        },
        onPageFinished: (url) {
          setState(() {
            loadingPercentage = 100;
          });
        },
      ));
    _loadHtml(controller, context);
    // _onLoadFlutterAssetExample(controller, context);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        WebViewWidget(
          controller: controller,
        ),
        if (loadingPercentage < 100)
          LinearProgressIndicator(
            value: loadingPercentage / 100.0,
          ),
      ],
    );
  }

  Future<void> _loadHtml(
      WebViewController controller, BuildContext context) async {
    String htmlPath = 'assets/charts/chart_view.html';
    String js1Path = 'assets/charts/jquery.js';
    String js2Path = 'assets/charts/d3.min.js';
    String js3Path = 'assets/charts/zc.min.js';
    String js4Path = 'assets/charts/pagechart.js';

    String htmlContent = await rootBundle.loadString(htmlPath);
    String js1Content = await rootBundle.loadString(js1Path);
    String js2Content = await rootBundle.loadString(js2Path);
    String js3Content = await rootBundle.loadString(js3Path);
    String js4Content = await rootBundle.loadString(js4Path);
    final jsonResponse = await http
        .get(Uri.parse('https://jsonplaceholder.typicode.com/albums/1'));
    final String jsonResponseBody =
        '{"yTitle":"Y Value","bgColor":"rgb(255, 255, 255)","seriesName":["Y Value"],"xTitle":"X Name","seriesType":[5],"themeColors":["#f04836","#efa21b","#48a3e8","#5de1b5","#bf2ae7","#ec3fa3","#FB7060","#FBBB4A","#7CC5FB","#8AFBD6","#DC6CFA","#FB72C2","#F43621","#ED9B0A","#3098E6","#47E6B1","#BC16E9","#EB2297"],"charttype":"Column","legendPos":"center.top","theme":"theme1","plotdata":[["Choice 1",10],["Choice 2",20],["Choice 3",30]],"hasCount":"false","dateTimeDetails":{"timeZone":"Asia/Kolkata","dateFormat":"dd-MMM-YYYY","is24HourFormat":true}}';

    // print(jsonResponseBody);
    htmlContent = htmlContent.replaceAll('\${ JSON }', jsonResponseBody);

    htmlContent = htmlContent.replaceAll('\${ jquery }', js1Content);
    htmlContent = htmlContent.replaceAll('\${ d3.min }', js2Content);
    htmlContent = htmlContent.replaceAll('\${ zc.min }', js3Content);
    htmlContent = htmlContent.replaceAll('\${ zcpageLiveChart }', js4Content);

    await controller.loadHtmlString(htmlContent);
    print(htmlContent);
  }
}
