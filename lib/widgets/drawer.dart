// Copyright (C) 2026 CodingDashUU
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program. If not, see <https://www.gnu.org/licenses/>.

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

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
