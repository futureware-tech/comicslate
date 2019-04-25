import 'package:comicslate/remote/email_launcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class NavigationDrawer extends StatelessWidget {
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
                color: Colors.teal,
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
            AboutListTile(
              icon: const Icon(Icons.perm_device_information),
              child: const Text('О приложении'),
              applicationIcon: Image.asset('images/favicon.webp'),
              applicationLegalese: 'MIT License',
            ),
          ],
        ),
      );
}
