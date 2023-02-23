import 'package:diff_match_patch/diff_match_patch.dart' as d;

String diff({required Object expected, required Object actual}) {
  final differences = d.diff(expected.toString(), actual.toString());
  final buffer = StringBuffer()
    ..writeln(_lineCaption('DIFF'))
    ..writeln(differences.toPrettyString())
    ..writeln(_lineCaption('END DIFF'));

  return buffer.toString();
}

String _lineCaption(String caption) {
  const totalWidth = 80;
  final asteriskWidth = (totalWidth - caption.length - 2) ~/ 2;

  return '${'*' * asteriskWidth} $caption ${'*' * asteriskWidth}';
}

extension on List<d.Diff> {
  String toPrettyString() {
    String identical(String str) => '\u001b[90m$str\u001B[0m';
    String deletion(String str) => '\u001b[31m[-$str-]\u001B[0m';
    String insertion(String str) => '\u001b[32m{+$str+}\u001B[0m';

    final buffer = StringBuffer();
    for (final difference in this) {
      switch (difference.operation) {
        case d.DIFF_EQUAL:
          buffer.write(identical(difference.text));
          break;
        case d.DIFF_DELETE:
          buffer.write(deletion(difference.text));
          break;
        case d.DIFF_INSERT:
          buffer.write(insertion(difference.text));
          break;
      }
    }
    return buffer.toString();
  }
}
