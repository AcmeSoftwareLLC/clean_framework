import 'package:clean_framework/clean_framework.dart';
import 'package:clean_framework_example/routes.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage() : super(key: const Key('HomePage'));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Example Features'),
      ),
      body: FeatureBuilder<String>(
        flagKey: 'exampleFeatures',
        valueType: FlagValueType.string,
        defaultValue: 'all',
        evaluationContext: EvaluationContext(
          {'platform': defaultTargetPlatform.name},
        ),
        builder: (context, value) {
          final enabledFeatures = value.split(',');

          return ListView(
            padding: EdgeInsets.symmetric(vertical: 16),
            children: [
              _List(
                enabled: enabledFeatures.contains('firebase'),
                title: 'Firebase',
                iconData: Icons.local_fire_department_sharp,
                route: Routes.lastLogin,
                showDivider: false,
              ),
              _List(
                enabled: enabledFeatures.contains('graphql'),
                title: 'GraphQL',
                iconData: Icons.graphic_eq,
                route: Routes.countries,
              ),
              _List(
                enabled: enabledFeatures.contains('rest'),
                title: 'Rest API',
                iconData: Icons.sync_alt,
                route: Routes.randomCat,
              ),
            ],
          );
        },
      ),
    );
  }
}

class _List extends StatelessWidget {
  const _List({
    required this.enabled,
    required this.title,
    required this.iconData,
    required this.route,
    this.showDivider = true,
  });

  final bool enabled;
  final String title;
  final IconData iconData;
  final Routes route;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    if (!enabled) return const SizedBox.shrink();

    return Column(
      children: [
        ListTile(
          title: Text(title),
          leading: Icon(iconData),
          onTap: () => router.to(route),
        ),
        if (showDivider) Divider(),
      ],
    );
  }
}
