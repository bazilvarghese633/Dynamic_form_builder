import 'package:dynamic_form_builder/features/domain/entities/form_entity.dart';

class AnswerFormatter {
  static Map<String, String> formatAnswers(
    Map<String, dynamic> answers,
    List<QuestionEntity> questions,
  ) {
    final formatted = <String, String>{};

    for (final question in questions) {
      final answer = answers[question.uid];
      if (answer == null) continue;

      String display;

      if (answer is List) {
        display = answer.isEmpty ? '—' : answer.join(', ');
      } else if (answer is DateTime) {
        display = _formatDate(answer);
      } else if (answer.runtimeType.toString().contains('Timestamp')) {
        // Firestore Timestamp inside answers map
        display = _formatDate((answer as dynamic).toDate() as DateTime);
      } else if (answer is String) {
        final dt = _parseAnyDateString(answer);
        if (dt != null) {
          display = _formatDate(dt);
        } else {
          display = _findOptionDisplayName(answer, question) ?? answer;
        }
      } else {
        display = _findOptionDisplayName(answer, question) ?? answer.toString();
      }

      formatted[question.componentName] = display;
    }

    return formatted;
  }

  //parsing of the date to the correct format which is readable
  static DateTime? _parseAnyDateString(String s) {
    //parse to iso
    final direct = DateTime.tryParse(s);
    if (direct != null) return direct;

    // puting  yyyy-MM-dd from anywhere in the string
    final match = RegExp(r'(\d{4})-(\d{2})-(\d{2})').firstMatch(s);
    if (match != null) {
      final year = int.tryParse(match.group(1)!);
      final month = int.tryParse(match.group(2)!);
      final day = int.tryParse(match.group(3)!);
      if (year != null &&
          month != null &&
          day != null &&
          month >= 1 &&
          month <= 12 &&
          day >= 1 &&
          day <= 31) {
        return DateTime(year, month, day);
      }
    }
    return null;
  }

  static String _formatDate(DateTime dt) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];

    return '${months[dt.month - 1]} ${dt.day}, ${dt.year}';
  }

  static String? _findOptionDisplayName(
    dynamic answer,
    QuestionEntity question,
  ) {
    for (final option in question.options) {
      if (option.name == answer) return option.name;
    }
    return null;
  }
}
