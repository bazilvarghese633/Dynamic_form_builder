import 'package:dynamic_form_builder/features/domain/entities/form_entity.dart';

class FormValidator {
  /// Returns null if valid, or an error message string if invalid.
  static String? validate(
    List<QuestionEntity> questions,
    Map<String, dynamic> answers,
  ) {
    for (final question in questions) {
      final answer = answers[question.uid];
      final error = _validateQuestion(question, answer);
      if (error != null) return '${question.componentName}: $error';
    }
    return null;
  }

  static String? _validateQuestion(QuestionEntity question, dynamic answer) {
    // Determine the input type from the first option
    final type = question.options.isNotEmpty
        ? question.options.first.type
        : null;

    if (type == 'input_single_line' || type == 'input_multiline') {
      if (answer == null || answer.toString().trim().isEmpty) {
        return 'This field is required';
      }
      if (answer.toString().trim().length < 1) {
        return 'Please enter at least one character';
      }
      return null;
    }

    if (type == 'date_picker') {
      if (answer == null) return 'Please select a date';
      return null;
    }

    if (type == 'drop_down') {
      if (answer == null || answer.toString().isEmpty) {
        return 'Please select an option';
      }
      return null;
    }

    // Radio (single selection)
    if (!question.multipleSelection && type == null) {
      if (answer == null || answer.toString().isEmpty) {
        return 'Please select an option';
      }
      return null;
    }

    // Checkbox (multiple selection)
    if (question.multipleSelection) {
      if (answer == null || (answer is List && answer.isEmpty)) {
        return 'Please select at least one option';
      }
      return null;
    }

    return null;
  }
}
