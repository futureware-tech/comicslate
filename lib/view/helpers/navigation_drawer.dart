import 'package:comicslate/flutter/styles.dart' as app_styles;
import 'package:comicslate/remote/email_launcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:package_info/package_info.dart';

class NavigationDrawer extends StatelessWidget {
  Future<String> _getAppVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.version;
  }

  @override
  Widget build(BuildContext context) => Drawer(
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: const Text(
                'Comicslate',
                style: TextStyle(color: Colors.white, fontSize: 25),
              ),
              decoration: BoxDecoration(
                color: app_styles.kPrimaryColor,
              ),
            ),
            ListTile(
              leading: const Icon(Icons.live_help),
              title: const Text('Связаться с нами'),
              onTap: () async {
                Navigator.pop(context);
                await launchEmail(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.thumb_up),
              title: const Text('Голосовать за улучшениe приложения'),
              onTap: () async {
                Navigator.pop(context);
                await launchUrl(
                    context, 'https://comicslate.featureupvote.com/');
              },
            ),
            FutureBuilder<String>(
              future: _getAppVersion(),
              builder: (context, snapshot) => AboutListTile(
                    icon: const Icon(Icons.perm_device_information),
                    child: const Text('О приложении'),
                    applicationIcon: Image.asset('images/favicon.webp'),
                    applicationVersion: snapshot.hasData ? snapshot.data : null,
                    applicationLegalese: 'MIT License',
                  ),
            ),
          ],
        ),
      );
}
