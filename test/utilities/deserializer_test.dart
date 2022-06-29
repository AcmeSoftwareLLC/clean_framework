import 'package:clean_framework/clean_framework.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Deserializer Tests |', () {
    test('should return a string', () {
      final data = Deserializer({'key': 'value'});
      expect(data.getString('key'), 'value');
    });

    test('should return a int', () {
      final data = Deserializer({'key': 1});
      expect(data.getInt('key'), 1);
    });

    test('should return a double for int value', () {
      final data = Deserializer({'key': 1});
      expect(data.getDouble('key'), 1.0);
    });

    test('should return a double', () {
      final data = Deserializer({'key': 1.0});
      expect(data.getDouble('key'), 1.0);
    });

    test('should return a bool', () {
      final data = Deserializer({'key': true});
      expect(data.getBool('key'), true);
    });

    test('should return a map', () {
      final data = Deserializer(
        {
          'key': {'key': 'value'}
        },
      );
      expect(data.getMap('key'), {'key': 'value'});
    });

    test('should return a list of strings', () {
      final data = Deserializer(
        {
          'key': ['value']
        },
      );
      expect(data.getSimpleList('key'), ['value']);
    });

    test('should return a list of ints', () {
      final data = Deserializer(
        {
          'key': [1]
        },
      );
      expect(data.getSimpleList('key'), [1]);
    });

    test('should return a list of doubles', () {
      final data = Deserializer(
        {
          'key': [1.0]
        },
      );
      expect(data.getSimpleList('key'), [1.0]);
    });

    test('should return a list of bools', () {
      final data = Deserializer(
        {
          'key': [true]
        },
      );
      expect(data.getSimpleList('key'), [true]);
    });

    test('should return a list of maps', () {
      final data = Deserializer(
        {
          'key': [
            {'key': 'value'}
          ]
        },
      );
      expect(
        data.getSimpleList('key'),
        [
          {'key': 'value'}
        ],
      );
    });

    test('should return a list of lists', () {
      final data = Deserializer(
        {
          'key': [
            [
              {'key': 'value'}
            ]
          ]
        },
      );
      expect(
        data.getSimpleList('key'),
        [
          [
            {'key': 'value'}
          ]
        ],
      );
    });

    test('should return a list of complex object', () {
      final data = Deserializer(
        {
          'key': [
            {'key': 'value'}
          ]
        },
      );
      expect(
        data.getList('key', converter: TestModel.fromJson),
        const [
          TestModel(key: 'value'),
        ],
      );
    });
  });
}

@immutable
class TestModel {
  const TestModel({required this.key});

  factory TestModel.fromJson(Map<String, dynamic> json) {
    final data = Deserializer(json);

    return TestModel(
      key: data.getString('key'),
    );
  }

  final String key;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is TestModel &&
            runtimeType == other.runtimeType &&
            key == other.key;
  }

  @override
  int get hashCode => key.hashCode;
}
