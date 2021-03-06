import 'package:comicslate/remote/device_info.dart';
import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import 'package:url_launcher/url_launcher.dart';

const String _supportEmail = 'comicslate@futureware.dev';

//https://www.w3schools.com/tags/ref_urlencode.asp
String _queryEncodingToPercent(String text) => text.replaceAll('+', '%20');

Future<void> launchEmail(BuildContext context) async {
  final orientation = MediaQuery.of(context).orientation.toString();
  // Count physical pixels of device.
  final screenSize =
      MediaQuery.of(context).size * MediaQuery.of(context).devicePixelRatio;
  final platform = Theme.of(context).platform;
  final appInfo = await PackageInfo.fromPlatform();
  final appVersion = appInfo.version;
  final buildNumber = appInfo.buildNumber;
  final appName = appInfo.appName;

  // On iPhone Gmail app \n does not work.
  final deviceInfo = (await DeviceInfo.getDeviceInfo())
      .info
      .entries
      .map((entry) => '${entry.key}: ${entry.value}')
      .join('; \n');
  final appInfoOptions = {
    'subject': '$appName Feedback',
    'body': '\n\n\nApp Version: $appVersion; \n'
        'Build Number: $buildNumber; \n'
        'App Orientation: $orientation; \n'
        'Screensize: $screenSize; \n'
        '$deviceInfo \n'
  };

  final mailUrl = _queryEncodingToPercent(Uri(
          scheme: 'mailto',
          path: _supportEmail,
          queryParameters: appInfoOptions)
      .toString());

  final googleGmailUrl = _queryEncodingToPercent(Uri(
          scheme: 'googlegmail',
          path: '/co',
          queryParameters: <String, String>{'to': _supportEmail}
            ..addAll(appInfoOptions))
      .toString());

  try {
    if (platform == TargetPlatform.iOS && await canLaunch(googleGmailUrl)) {
      await launch(googleGmailUrl);
      return;
    }
    await launch(mailUrl, forceSafariVC: false);
  } catch (e) {
    // TODO(ksheremet): Show error to user that app is not installed
    debugPrint(e.toString());
  }
}

Future<void> launchUrl(BuildContext context, String url) async {
  try {
    await launch(url, forceSafariVC: false);
  } catch (e) {
    // TODO(ksheremet): Show error to user that app is not installed
    debugPrint(e.toString());
  }
}
