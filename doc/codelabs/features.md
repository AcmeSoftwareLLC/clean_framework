author: ACME Software
summary: Clean Framework Features
id: clean-framework-features
tags: features clean framework
categories: ACME Softare Codelabs
environments: Web
status: Active
feedback link: https://github.com/MattHamburger/clean_framework/issues

# Clean Framework Features

## Overview

Duration: 0:02:00

Features provides a  way to dynamically show or hide entire UI components. The main advantage of doing this is to have a reliable mechanism to control segments on an app that has been already published via services. That way, if a new component has a major bug, any new screens using that component can be disabled remotely.

This system also allows the developers to have multiple versions of the same component live in the app. This allows QA engineers to compare the behavoir of the two components without having to compare two different builds.

Since the architecture of the Clean Framework, we have always called these
components "Features". A feature for us is a set of UI components and usecases that encapsulates a specific user function. For example, a Login Feature might have multiple screens where the user enter credentials, tries to recover a forgotten password or tries to login using Biometrics. All the pieces of UI that show these screens, the usecases that control the data flows, and the services attached to them, are considered one single Feature.

The way the app knows how to control the features is by stablishing a relationship between the features and a set of States. These states dictate if the feature is shown or is hidden, for example.

To stablish this relationship, we can use a specific REST service that returns a JSON where a state is assigned to each feature. This can be also a FireBase node update, or even we can save that JSON on the build config files to not require an external connection.

On this Codelab we will review how you can create a Feature and how it interacts with the other framework components.

### Requirements

- A Flutter project that includes a version of the clean framework library superior to 1.0.0 (https://pub.dev/packages/clean_framework/install).
- Undestanding of the basic architecture structure used for Clean Framework Components (as reviewed on the Introduction to Clean Framework codelab).

## Project Setup

Duration: 0:15:00

The first step to start adding features is to define precisely how many features you will have and choosing their names. Features tend to have a name that helps anyone easily detect what's the purpose of the feature. Good names are Login, Deposits, History, Balance, etc.

Create a file inside your root folder and create a global instance of the Feature class for each feature, like this:

### features.dart
```dart
import 'package:clean_framework/clean_framework.dart';

const loginFeature = Feature(name: 'login');
```

Positive
: Note that the name attribute will be referenced later when using a service to determine the behavior of the feature. This name will be used inside the JSON of that service

The Feature class supports adding version numbers to Feature instances, in case you decide they are useful for your project, for example you could have a Login v1.0 and 2.0 alive at the same time in the build, and showing one in production while the other is only visible on a debug build. For this codelab we don't need it so that parameter is not specified.

Once we have a couple of features defined in this way, we can decide how many states we will use for each feature on this project. Clean Framework provides a default Feature States enum:

### clean_framework/defaults/feature_states.dart
```dart
enum FeatureState { hidden, visible }
```

The minimal use case for any feature would be to be able to hide and show them. But you can define your own enum to add additional intermediate or even special states.

The framework allows you to specify anything as a state. Instead of enums, you could be using a hierarchy of classes, use Freezed, or only use Strings to keep things simple. We prefer the use of enums since its not easy to provide a wrong value, but if you are familiar with the Freezed library, that's an excellent way to manage a set of possible states, with the added benefit of having a superior implementation to state selection.

For the purpose of this codelab, lets add a new enum to our previous file like this:

### features.dart
```dart
import 'package:clean_framework/clean_framework.dart';

final loginFeature = Feature(name: 'login');

enum FeatureState { hidden, enabled, maintenance }
```

Here we decided to change the name of one of the states, and add another one that we will use to make a feature be shown in gray and have a "On maintenance" message. Not very practical but useful for the purpose of learning.

Positive
: The features file will contain all overrides to the feature base classes, but if you want to create separate files, feel free to do so

Finally, we need to create a class that defines how this new FeatureState enum is used when parsing the JSON used to retrieve the states for our features. We will add it on the same file:

### features.dart
```dart
import 'package:clean_framework/clean_framework.dart';

final loginFeature = Feature(name: 'login');

enum FeatureState { hidden, enabled, maintenance }

class MyFeatureMapper extends FeatureMapper<FeatureState> {
  static const Map<String, FeatureState> _jsonStateToFeatureStateMap = {
    'HIDDEN': FeatureState.hidden,
    'ENABLED': FeatureState.enabled,
    'MAINTENANCE': FeatureState.maintenance,
  };

  @override
  FeatureState parseState(String state) {
    return _jsonStateToFeatureStateMap[state] ?? defaultState;
  }

  @override
  get defaultState => FeatureState.hidden;
}
```

Lets review the key points about this class:

1. It extends from the abstract class FeatureMapper. On the Generics tag, we specify our own enum name.

1. It overrides parseState. This method is invoked everytime the JSON is parsing an entry where a feature name and a state exist. The purpose of the method is to be able to "convert" the strig representation of the state into a single value of our enum.

1. It overrides default state, where we also define which value of our enum is the default one. Default values are used when the parser is unable to map correctly the string representation of states, when a feature name doesn't exist or when trying to retrieve states for a feature that is not defined.

## Feature Provider

Duration: 0:05:00

In order for us to have access to the state of the features in any part of our code, we will use a special provider class. The instance of this provider will have global access but will be managed by a container, so don't be worried about memory misusage.

Lets create another file in the root folder, called providers:

### providers.dart
```dart
import 'package:clean_framework/clean_framework.dart';
import 'package:clean_framework_example/features.dart';
import 'features.dart';

final featureStatesProvider =
    FeatureStateProvider<FeatureState, MyFeatureMapper>(
        (_) => MyFeatureMapper());
```

This instance creates a FeatureStateProvider that uses our recently created class and enum, MyFeatureMapper and FeatureState. The only parameter to the constructor is a callback that creates an instance of the mapper as well.

When you run the app, this provider will be created and you will be able to check the state of any feature defined in your code. The initial states for all the features will be the default one, since we have not loaded any values yet.

You will have to decide when is a good moment to do this, and how you will achieve this. Clean Framework provides some default classes that simplify this process, but you have the freedom to create your own custom made process.

The scope for this codelab is to only explain how to create and use Features, so a custom loader won't be explained here. Please check the catalog of codelabs to see if one that explains this in detail is added in the future.

## AppContainersProvider

Duration: 0:05:00

The following step to complete our Feature implementation is to create a global container that will manage the feature provider, letting us retrieve our feature map anywhere in the code.

We will have to make the following changes on our main app file:

### main.dart
```dart
...

final providersContext = ProvidersContext();

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AppProvidersContainer(
      providersContext: providersContext,
      onBuild: (context, _) {
        providersContext().read(featureStatesProvider.featuresMap).load({
          'features': [
            {'name': 'login', 'state': 'ENABLED'},
          ]
        });
      },
      child: MaterialApp(
        // Material App implementation  
      );
    );
  }
}
```

The key points about these changes are:
1. We create a global ProvidersContext instance. This will allow the retrieval of the provider from code outside the UI context. If your app is simple and doesn't need this, you can skip this line and let the AppProvidersContainer create its own reference.

1. Wrap the MaterialApp with an AppProvidersContainer parent, which has an optional field for an external context. Also as an optional field you can define an onBuild callback to execute code whenever the widget is getting built. This is useful in this example since we want to load our JSON when the app starts.

1. Note how we use the providersContext callable reference to read the provider and obtain the mapper, which in turn is used to load the JSON. This is only one way we can use the provider to achieve the same result, your implementation could be more complicated (REST, Firebase, file system, etc.).

1. Understand the structure of the JSON to load the states. The names and states of each feature must match the ones we created previously, or that entry is ignored.

## FeatureWidget

Duration: 0:05:00

And finally, the last step is to wrap our feature code into a special widget, as follows:

### lib/features/login_feature_widget.dart
```dart
class LoginFeatureWidget extends FeatureWidget<FeatureState> {
  LoginFeatureWidget()
      : super(
          feature: loginFeature,
          provider: featureStatesProvider(),
        );
  @override
  Widget builder(BuildContext context, FeatureState currentState) {
    switch (currentState) {
      case FeatureState.enabled:
        return LoginWidget();
      default:
        return HiddenFeature();
    }
  }
}
```

1. The new widget extends from FeatureWidget, which is a descendant of StatelessWidget, where we won't override the build method, as we normally do, but we use the "builder" method. The difference is that here we have available another parameter, which is the current state the feature I am referencing in the constructor.

1. The constructor also provides a reference to the instance of the feature states provider we created at the beginning.

1. Once the widget gets built, it will internally use the provider to extract the current state for the feature, in this case, the login feature.

1. The builder is used to choose what UI code will be returned depending on the current state.

1. When the feature state is "enabled" then a normal bloc provider with the presenter is created. If this lines of code are unfamiliar please refer to the basic clean framework documentation or codelabs.

1. HiddenFeature is a simple stateless widget with an empty container. It is part of the default classes of the clean framework for optional use.

## Running the App

Duration: 0:02:00

Now that we have all the needed pieces together we can confirm that everything is in order if we execute the app in our emulator. Of course, the expected result is to have our feature shown as always, so basically nothing changed. But if we change the JSON value state for HIDDEN on the login feature, then the UI should show nothing.

If you want to experiment further, create a UI compoment (button, menu item, etc) that invokes the feature provider to load the JSON again with different values, so you can confirm that everytime that is done, the UI reloads to reflect the latest state.

On a production app, it would be a nice idea to have a way to retrieve the JSON from an external source, that way, we can control the visibility of the widgets on all apps with a single change on a centralized service.


## Tests for Features

Duration: 0:10:00

Given that the Clean Framework relies heavily on unit tests as part of a critical guideline for any project, we cannot end the codelab without explaining how to test these new components.

We have included a couple of helper classes and methods to simplify the code when writing unit tests or widget tests.

Let's review an example unit test:


### test/integration/features/login_feature_widget_test.dart
```dart

void main() {
  testWidgets(
      'LoginFeatureWidget hidden, then visible with load, then hide again',
      (tester) async {
    final featureTester = FeatureTester<FeatureState>(featureStatesProvider);

    final testWidget = MaterialApp(
        home: Column(
      children: [
        LoginFeatureWidget(),
        ElevatedButton(
          key: Key('loadButton'),
          child: Text('load'),
          onPressed: () {
            featureTester.featuresMap.load({
              'features': [
                {'name': 'example', 'version': '1.0', 'state': 'ACTIVE'},
              ]
            });
          },
        ),
        ElevatedButton(
          key: Key('hideButton'),
          child: Text('hide'),
          onPressed: () {
            featureTester.featuresMap.append({
              'features': [
                {'name': 'example', 'version': '1.0', 'state': 'HIDDEN'},
              ]
            });
          },
        )
      ],
    ));

    await featureTester.pumpWidget(tester, testWidget);

    expect(find.byType(LoginFeatureWidget), findsOneWidget);
    expect(find.byType(LoginWidget), findsNothing);
    expect(find.byKey(Key('hidden')), findsOneWidget);

    await tester.tap(find.byKey(Key('loadButton')));
    await tester.pump();

    expect(find.byType(LoginWidget), findsOneWidget);
    expect(find.byKey(Key('hidden')), findsNothing);

    await tester.tap(find.byKey(Key('hideButton')));
    await tester.pump();

    expect(find.byType(LoginWidget), findsNothing);
    expect(find.byKey(Key('hidden')), findsOneWidget);

    featureTester.dispose();
  });
}
```

There is a lot of code here, lets see the key parts:

1. FeatureTester is created at the beginning of the test. It will reference the existing provider. This allows the creation of a custom providers context that only works for this test. Please remember to dispose of this instance at the end of every test. This will allow having multiple tests with separate contexts and running them in any order.

1. The feature tester reference then is used to pump the widget in the test. It receives the reference to the base tester variable and the widget to pump.

1. Notice how the test widget includes two buttons that load the JSON again, letting us test the widget visibility. We do that by confirming the LoginWidget was rendered instead of the empty container, and viceversa.

Positive
: The feature tester can be used on unit tests where no UI needs to be tested. You can use it to create a providers context and then manipulate the existing providers.

When coding more complex integration tests, the provider context should be the same one that is used when the app is executed, naturally. It's up to the developer to determine how the JSON is injected in the test. For example, if a REST mock server is used, then the JSON needs to exist there.
