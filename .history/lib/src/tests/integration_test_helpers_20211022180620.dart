import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

final _helperName = 'Integration tests helper';

late WidgetTester _tester;
late Function _log;

set testLog(Function logger) => _log = logger;

void enableLogsInConsole() => testLog = (msg) => print(msg);

Future<void> startTest(WidgetTester tester, Function main) async {
  _tester = tester;
  main();
  await tester.pumpAndSettle();
  _log('$_helperName: startTest!');
}

Future<bool> waitFor(Finder finder,
    [Duration timeout = const Duration(seconds: 30),
    Matcher matcher = findsWidgets]) async {
  final DateTime endTime = DateTime.now().add(timeout);
  do {
    if (DateTime.now().isAfter(endTime)) return false;
    await _tester.pumpAndSettle();
  } while (!await _expect(finder, matcher));
  return true;
}

Future<void> didWidgetAppear(String widgetKey) async {
  final Finder finder = find.byKey(Key(widgetKey));
  await waitFor(finder);
  expect(finder, findsWidgets);
  _log('$_helperName: didWidgetAppear: $widgetKey');
}

Future<void> didTextAppear(String text) async {
  final Finder finder = find.text(text);
  await waitFor(finder);
  expect(finder, findsWidgets);
  _log('$_helperName: didTextAppear: $text');
}

Future<void> tapWidget(String widgetKey) async {
  final Finder finder = find.byKey(Key(widgetKey));
  await _tap(finder);
  _log('$_helperName: tapWidget: $widgetKey');
}

Future<void> tapText(String text) async {
  final Finder finder = find.text(text);
  await _tap(finder);
  _log('$_helperName: tapText: $text');
}

Future<void> tapWithFinder(Finder finder) async {
  await _tap(finder);
  _log('$_helperName: tapWithFinder: $finder');
}

Future<void> _tap(Finder finder) async {
  await waitFor(finder);
  await _tester.tap(finder.first);
  await _tester.pumpAndSettle();
}

Future<void> didWidgetNeverAppear(String widgetKey) async {
  final Finder finder = find.byKey(Key(widgetKey));

  final DateTime endTime = DateTime.now().add(Duration(seconds: 5));
  do {
    await _tester.pumpAndSettle();
  } while (!DateTime.now().isAfter(endTime));

  expect(finder, findsNothing);
  _log('$_helperName: didWidgetNeverAppear: $widgetKey');
}

Future<void> enterText(String widgetKey, String text) async {
  final Finder finder = find.byKey(Key(widgetKey));
  await waitFor(finder);
  await _tester.enterText(finder.first, text);
  await _tester.pumpAndSettle();
  _log('$_helperName: enterText: $text widget: $widgetKey');
}

Future<void> scrollToWidget(String widgetKey,
    {double? deltaY, String? scrollableWidgetKey}) async {
  final Finder finder = find.byKey(Key(widgetKey));
  await _scrollTo(finder,
      deltaY: deltaY, scrollableWidgetKey: scrollableWidgetKey);
  _log('$_helperName: scrollToWidget: $widgetKey deltaY: $deltaY');
}

Future<void> scrollToText(String text,
    {double? deltaY, String? scrollableWidgetKey}) async {
  final Finder finder = find.text(text);
  await _scrollTo(finder,
      deltaY: deltaY, scrollableWidgetKey: scrollableWidgetKey);
  _log('$_helperName: scrollToText: $text deltaY: $deltaY');
}

Future<void> scrollTo(Finder finder,
    {double? deltaY, String? scrollableWidgetKey}) async {
  await _scrollTo(finder,
      deltaY: deltaY, scrollableWidgetKey: scrollableWidgetKey);
  _log('$_helperName: scrollTo: $finder deltaY: $deltaY');
}

Future<void> _scrollTo(Finder finder,
    {double? deltaY, String? scrollableWidgetKey}) async {
  var scrollFinder = scrollableWidgetKey != null
      ? find.byKey(Key(scrollableWidgetKey))
      : find.byWidgetPredicate((widget) =>
          (widget is SingleChildScrollView || widget is ScrollView));
  await _tester.scrollUntilVisible(finder.first, deltaY ?? 100,
      scrollable: find
          .descendant(of: scrollFinder, matching: find.byType(Scrollable))
          .first);
  await _tester.pumpAndSettle();
}

Future<void> selectDropDownList(
    String dropDownButtonKey, String optionText) async {
  await _tap(find.byKey(Key(dropDownButtonKey)));
  final finder = find.descendant(
      of: find.byType(Scrollable).last, matching: find.text(optionText));
  await _tester.scrollUntilVisible(finder, 100,
      scrollable: find.byType(Scrollable).last);
  await _tester.pumpAndSettle();
  await _tap(finder);
  _log('$_helperName: selectDropDownList: $optionText');
}

Future<bool> _expect(dynamic actual, dynamic matcher,
    {String? reason, dynamic skip}) async {
  try {
    expect(actual, matcher, reason: reason, skip: skip);
    return true;
  } catch (e) {
    return false;
  }
}
