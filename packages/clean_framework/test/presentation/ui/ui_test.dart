import 'package:clean_framework/clean_framework.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../presenter/presenter_test.dart';

void main() {
  group('UI tests |', () {
    testWidgets(
      'displays widget correctly',
      (tester) async {
        await tester.pumpWidget(
          AppProviderScope(
            child: MaterialApp(
              home: Scaffold(
                body: TestUI(),
              ),
            ),
          ),
        );

        final clickFinder = find.text('CLICK');
        await tester.tap(clickFinder);
        await tester.pump();

        final fooFinder = find.text('FOO');

        expect(
          find.descendant(of: find.byType(Column), matching: fooFinder),
          findsOneWidget,
        );

        expect(
          find.descendant(of: find.byType(SnackBar), matching: fooFinder),
          findsOneWidget,
        );
      },
    );
  });
}

class TestUI extends UI<TestViewModel> {
  TestUI({super.key});

  @override
  TestPresenter create(PresenterBuilder<TestViewModel> builder) {
    return TestPresenter(builder: builder);
  }

  @override
  Widget build(BuildContext context, TestViewModel viewModel) {
    return Column(
      children: [
        Text(viewModel.message),
        ElevatedButton(
          onPressed: () => viewModel.update('FOO'),
          child: const Text('CLICK'),
        ),
      ],
    );
  }
}
