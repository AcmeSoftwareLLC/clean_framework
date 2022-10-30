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

    test('should return a int for string value', () {
      final data = Deserializer({'key': '1'});
      expect(data.getInt('key'), 1);
    });

    test('should return a double', () {
      final data = Deserializer({'key': 1.0});
      expect(data.getDouble('key'), 1.0);
    });

    test('should return a double for int value', () {
      final data = Deserializer({'key': 1});
      expect(data.getDouble('key'), 1.0);
    });

    test('should return a double for string value', () {
      final data = Deserializer({'key': '1'});
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

    test('should return an enum', () {
      final data = Deserializer(
        {'key': 'foo'},
      );

      expect(
        data.getEnum<TestEnum>(
          'key',
          values: TestEnum.values,
          defaultValue: TestEnum.baz,
          matcher: (e) => e.name,
        ),
        TestEnum.foo,
      );
    });

    test(
        'should return an default enum if matcher could not match with the value',
        () {
      final data = Deserializer(
        {'key': 'value'},
      );

      expect(
        data.getEnum<TestEnum>(
          'key',
          values: TestEnum.values,
          defaultValue: TestEnum.baz,
          matcher: (e) => e.name,
        ),
        TestEnum.baz,
      );
    });

    test('should return DateTime', () {
      final data = Deserializer(
        {'key': '2020-01-01'},
      );

      expect(
        data.getDateTime('key'),
        DateTime(2020),
      );
    });

    test('should return default value for DateTime if parsing failed', () {
      final data = Deserializer(
        {'key': '2020-01.01'},
      );

      expect(
        data.getDateTime('key', defaultValue: DateTime(2020, 2)),
        DateTime(2020, 2),
      );
    });

    test('nested deserializer', () {
      final data = Deserializer(
        {
          'key': {'inner_key': 'Hello world!'}
        },
      );

      final nestedData = data('key');

      expect(
        nestedData.getString('inner_key'),
        'Hello world!',
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

enum TestEnum { foo, bar, baz }
