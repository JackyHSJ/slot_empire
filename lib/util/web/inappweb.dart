// import 'dart:io';
// import 'package:example_slot_game/base_view_model.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_inappwebview/flutter_inappwebview.dart';
//
//
// class InAppWebViewBrowser extends StatefulWidget {
//   InAppWebViewBrowser({super.key, required this.url, this.urlHeaders});
//   String url;
//   Map<String, String>? urlHeaders;
//
//   @override
//   State<InAppWebViewBrowser> createState() => _InAppWebViewBrowserState();
// }
//
// class _InAppWebViewBrowserState extends State<InAppWebViewBrowser> {
//
//   final GlobalKey webViewKey = GlobalKey();
//
//   InAppWebViewController? webViewController;
//   InAppWebViewSettings settings = InAppWebViewSettings(
//       useShouldOverrideUrlLoading: true,
//       mediaPlaybackRequiresUserGesture: false,
//       useHybridComposition: true,
//       allowsInlineMediaPlayback: true,);
//
//   late PullToRefreshController pullToRefreshController;
//   Map<String, String>? get urlHeaders => widget.urlHeaders;
//   double progress = 0;
//   final urlController = TextEditingController();
//
//   @override
//   void initState() {
//     super.initState();
//
//     pullToRefreshController = PullToRefreshController(
//       options: PullToRefreshOptions(
//         color: Colors.blue,
//       ),
//       onRefresh: () async {
//         if (Platform.isAndroid) {
//           webViewController?.reload();
//         } else if (Platform.isIOS) {
//           webViewController?.loadUrl(
//               urlRequest: URLRequest(url: await webViewController?.getUrl()));
//         }
//       },
//     );
//   }
//
//   @override
//   void dispose() {
//     urlController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: [
//         InAppWebView(
//           onCloseWindow: (_) => BaseViewModel.popPage(context),
//           key: webViewKey,
//           initialUrlRequest: URLRequest(
//               url: WebUri(widget.url),
//               headers: urlHeaders
//           ),
//           initialSettings: settings,
//           pullToRefreshController: pullToRefreshController,
//           onWebViewCreated: (controller) {
//             webViewController = controller;
//             /// receive data :
//
//           },
//           onLoadStart: (controller, url) {
//             setState(() {
//               widget.url = url.toString();
//               urlController.text = widget.url;
//             });
//           },
//           androidOnPermissionRequest: (controller, origin,
//               resources) async {
//             return PermissionRequestResponse(
//                 resources: resources,
//                 action: PermissionRequestResponseAction.GRANT);
//           },
//           shouldOverrideUrlLoading: (controller,
//               navigationAction) async {
//             var uri = navigationAction.request.url!;
//
//             if (![ "http", "https", "file", "chrome",
//               "data", "javascript", "about"].contains(uri.scheme)) {
//             }
//
//             return NavigationActionPolicy.ALLOW;
//           },
//           onLoadStop: (controller, url) async {
//             pullToRefreshController.endRefreshing();
//             setState(() {
//               widget.url = url.toString();
//               urlController.text = widget.url;
//             });
//
//             /// send data
//
//           },
//           onLoadError: (controller, url, code, message) {
//             pullToRefreshController.endRefreshing();
//           },
//           onProgressChanged: (controller, progress) {
//             if (progress == 100) {
//               pullToRefreshController.endRefreshing();
//             }
//             setState(() {
//               this.progress = progress / 100;
//               urlController.text = widget.url;
//             });
//           },
//           onUpdateVisitedHistory: (controller, url,
//               androidIsReload) {
//             setState(() {
//               widget.url = url.toString();
//               urlController.text = widget.url;
//             });
//           },
//           onConsoleMessage: (controller, consoleMessage) {
//             print(consoleMessage);
//           },
//         ),
//         progress < 1.0
//             ? LinearProgressIndicator(value: progress)
//             : Container(),
//       ],
//     );
//   }
// }