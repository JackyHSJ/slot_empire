import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:path/path.dart' as p;
import 'dart:io';
import 'dart:async';

class LauncherManager {
  static final Uri _url = Uri.parse('https://flutter.dev');
  // basic
  static Future<void> openWeb() async {
    if (!await launchUrl(_url)) {
      throw 'Could not launch $_url';
    }
  }

  // encoding
  static String? encodeQueryParameters(Map<String, String> params) {
    return params.entries
        .map((MapEntry<String, String> e) =>
    '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
        .join('&');
  }

  static void composeMail() {
// #docregion encode-query-parameters
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'smith@example.com',
      query: encodeQueryParameters(<String, String>{
        'subject': 'Example Subject & Symbols are allowed!',
      }),
    );
    launchUrl(emailLaunchUri);
// #enddocregion encode-query-parameters
  }

  static void composeSms() {
// #docregion sms
    final Uri smsLaunchUri = Uri(
      scheme: 'sms',
      path: '0118 999 881 999 119 7253',
      queryParameters: <String, String>{
        'body': Uri.encodeComponent('Example Subject & Symbols are allowed!'),
      },
    );
// #enddocregion sms
    launchUrl(smsLaunchUri);
  }

  // files
  static Future<void> openFile() async {
    // Prepare a file within tmp
    final String tempFilePath = p.joinAll(<String>[
      ...p.split(Directory.systemTemp.path),
      'flutter_url_launcher_example.txt'
    ]);
    final File testFile = File(tempFilePath);
    await testFile.writeAsString('Hello, world!');
// #docregion file
    final String filePath = testFile.absolute.path;
    final Uri uri = Uri.file(filePath);

    if (!File(uri.toFilePath()).existsSync()) {
      throw '$uri does not exist!';
    }
    if (!await launchUrl(uri)) {
      throw 'Could not launch $uri';
    }
// #enddocregion file
  }

  static Future<void> launchInBrowser(Uri url) async {
    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      throw 'Could not launch $url';
    }
  }

  static Future<void> launchInWebViewOrVC(Uri url) async {
    if (!await launchUrl(
      url,
      mode: LaunchMode.inAppWebView,
      webViewConfiguration: const WebViewConfiguration(
          headers: <String, String>{'my_header_key': 'my_header_value'}),
    )) {
      throw 'Could not launch $url';
    }
  }

  static Future<void> launchInWebViewWithoutJavaScript(Uri url) async {
    if (!await launchUrl(
      url,
      mode: LaunchMode.inAppWebView,
      webViewConfiguration: const WebViewConfiguration(enableJavaScript: false),
    )) {
      throw 'Could not launch $url';
    }
  }
  static Future<void> launchWeb3JavaScript(Uri url) async {
    if (!await launchUrl(
      url,
      mode: LaunchMode.inAppWebView,
      webViewConfiguration: const WebViewConfiguration(enableJavaScript: true, headers: {}),
    )) {
      throw 'Could not launch $url';
    }
  }


  static Future<void> launchInWebViewWithoutDomStorage(Uri url) async {
    if (!await launchUrl(
      url,
      mode: LaunchMode.inAppWebView,
      webViewConfiguration: const WebViewConfiguration(enableDomStorage: false),
    )) {
      throw 'Could not launch $url';
    }
  }

  static Future<void> launchUniversalLinkIos(Uri url) async {
    final bool nativeAppLaunchSucceeded = await launchUrl(
      url,
      mode: LaunchMode.externalNonBrowserApplication,
    );
    if (!nativeAppLaunchSucceeded) {
      await launchUrl(
        url,
        mode: LaunchMode.inAppWebView,
      );
    }
  }

  static Widget launchStatus(BuildContext context, AsyncSnapshot<void> snapshot) {
    if (snapshot.hasError) {
      return Text('Error: ${snapshot.error}');
    } else {
      return const Text('');
    }
  }

  static Future<void> makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(launchUri);
  }
}