import 'package:clean_framework_example/routes.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage() : super(key: const Key('HomePage'));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Example Features'),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(vertical: 16),
        children: [
          ListTile(
            title: Text('Firebase'),
            leading: Icon(Icons.local_fire_department_sharp),
            onTap: () => router.to(Routes.lastLogin),
          ),
          const Divider(),
          ListTile(
            title: Text('GraphQL'),
            leading: Icon(Icons.graphic_eq),
            onTap: () => router.to(Routes.countries),
          ),
          const Divider(),
          ListTile(
            title: Text('Rest API'),
            leading: Icon(Icons.sync_alt),
            onTap: () => router.to(Routes.randomCat),
          ),
        ],
      ),
    );
  }
}
