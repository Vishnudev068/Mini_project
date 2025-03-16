import 'package:flutter/material.dart';
import 'package:flutter_application_4/login.dart';
import 'package:flutter_application_4/main.dart';
import 'package:flutter_application_4/map.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_4/theme_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.dark_mode),
            title: const Text('Dark Mode'),
            trailing: Switch(
              value: Provider.of<ThemeProvider>(context).themeMode ==
                  ThemeMode.dark,
              onChanged: (value) {
                Provider.of<ThemeProvider>(context, listen: false)
                    .toggleTheme();
              },
            ),
          ),
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: const Text('Logout'),
            onTap: () {
              signout(context);
            },
          ),
          ListTile(
            leading: FaIcon(
              FontAwesomeIcons.locationCrosshairs,
              color: Colors.black,
              size: 24,
            ),
            title: const Text('Location'),
            // onTap: () {
            //   Navigator.of(context).push(
            //     MaterialPageRoute(
            //       builder: (BuildContext context) {
            //         return MapScreen();
            //       },
            //     ),
            //   );
            // },
          ),
        ],
      ),
    );
  }

  signout(BuildContext ctx) async {
    final _sharedPref = await SharedPreferences.getInstance();
    await _sharedPref.clear();

    Navigator.of(ctx).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => Loginpage(),
        ),
        (route) => false);
  }
}
