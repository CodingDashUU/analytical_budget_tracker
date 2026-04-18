import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:go_router/go_router.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../state/budget_info.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(

            child: Row(
              verticalDirection: VerticalDirection.down,
              children: [
                Icon(Icons.person, size: 40),
                Flexible(
                  child:
                Text(
                  budgetInfo.name.value.isNotEmpty
                      ? budgetInfo.name.value
                      : 'You',
                  style: TextStyle(fontSize: 30),
                )),
              ],
            ),
          ),
          ListTile(
            leading: FaIcon(FontAwesomeIcons.pencil),
            title: Text('Budget Input'),
            onTap: () {
              context.go("/");
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.table_chart),
            title: Text('Budget Tables'),
            onTap: () {
              context.go("/tables");
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.pie_chart),
            title: Text('Analytics'),
            onTap: () {
              context.go("/analytics");
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
