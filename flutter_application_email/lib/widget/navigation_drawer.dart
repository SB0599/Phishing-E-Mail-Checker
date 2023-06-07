import 'package:flutter/material.dart';

import 'api_url_settings.dart';
import 'email_settings.dart';
import 'login.dart';
import 'fileInput.dart';
import 'filtermethode.dart';

class NavigationDrawerWidget extends StatelessWidget {
  final padding = EdgeInsets.symmetric(horizontal: 20);
  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: Material(
            color: Color.fromRGBO(20, 50, 80, 1),
            child: ListView(
              children: <Widget>[
                const SizedBox(
                  height: 48,
                ),
                buildMenuItem(
                  text: "Login",
                  icon: Icons.settings,
                  onClick: () => selectedItem(context, 2),
                ),
                buildMenuItem(
                  text: "API URL",
                  icon: Icons.settings,
                  onClick: () => selectedItem(context, 0),
                ),
                buildMenuItem(
                  text: "E-mail settings",
                  icon: Icons.settings,
                  onClick: () => selectedItem(context, 1),
                ),
                buildMenuItem(
                  text: "File input",
                  icon: Icons.settings,
                  onClick: () => selectedItem(context, 3),
                ),
                buildMenuItem(
                  text: "Filter methode",
                  icon: Icons.settings,
                  onClick: () => selectedItem(context, 4),
                ),
              ],
            )));
  }

  Widget buildMenuItem({
    required String text,
    required IconData icon,
    VoidCallback? onClick,
  }) {
    final color = Colors.white;
    final hoverColor = Colors.white70;
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(text, style: TextStyle(color: color)),
      hoverColor: hoverColor,
      onTap: onClick,
    );
  }

  void selectedItem(BuildContext context, int index) {
    switch (index) {
      case 0:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => APIURLSettings(),
        ));
        return;
      case 1:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => EmailSettings(),
        ));
        return;
      case 2:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => Login(),
        ));
        return;
      case 3:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => FileInput(),
        ));
        return;
      case 4:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => Filtermethode(),
        ));
        return;
    }
  }
}
