import 'package:clean_framework/clean_framework.dart';
import 'package:clean_framework_example/routes.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage() : super(key: const Key('HomePage'));

  @override
  Widget build(BuildContext context) {
    return FeatureBuilder<int>(
      flagKey: 'color',
      defaultValue: 0xFF0000FF,
      builder: (context, colorValue) {
        return Scaffold(
          appBar: AppBar(
            title: FeatureBuilder<bool>(
              flagKey: 'newTitle',
              defaultValue: false,
              builder: (context, showNewTitle) {
                return Text(
                  showNewTitle ? 'Feature Flags Demo' : 'Example Features',
                );
              },
            ),
            backgroundColor: Color(colorValue),
          ),
          body: FeatureBuilder<String>(
            flagKey: 'exampleFeatures',
            defaultValue: 'rest,firebase,graphql',
            evaluationContext: EvaluationContext(
              {'platform': defaultTargetPlatform.name},
            ),
            builder: (context, value) {
              final enabledFeatures = value.split(',');

              return _ExampleFeature(enabledFeatures: enabledFeatures);
            },
          ),
        );
      },
    );
  }
}

class _ExampleFeature extends StatelessWidget {
  const _ExampleFeature({required this.enabledFeatures});

  final List<String> enabledFeatures;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.symmetric(vertical: 16),
      children: [
        _List(
          enabled: enabledFeatures.contains('firebase'),
          title: 'Firebase',
          iconData: Icons.local_fire_department_sharp,
          route: Routes.lastLogin,
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
  }
}

class _List extends StatelessWidget {
  const _List({
    required this.enabled,
    required this.title,
    required this.iconData,
    required this.route,
  });

  final bool enabled;
  final String title;
  final IconData iconData;
  final Routes route;

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      duration: const Duration(seconds: 2),
      child: enabled
          ? Column(
              children: [
                ListTile(
                  title: Text(title),
                  leading: Icon(iconData),
                  onTap: () => router.to(route),
                ),
                Divider(),
              ],
            )
          : const SizedBox.shrink(),
    );
  }
}
