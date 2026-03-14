import 'package:dynamic_form_builder/features/domain/entities/form_entity.dart';

abstract class DynamicFormState {}

class FormLoading extends DynamicFormState {}

class FormLoaded extends DynamicFormState {
  final List<FormEntity> forms;
  final Map<String, dynamic> answers;

  FormLoaded(this.forms, {this.answers = const {}});

  FormLoaded copyWith({
    List<FormEntity>? forms,
    Map<String, dynamic>? answers,
  }) {
    return FormLoaded(forms ?? this.forms, answers: answers ?? this.answers);
  }
}

class FormSaving extends DynamicFormState {
  final List<FormEntity> forms;
  final Map<String, dynamic> answers;
  FormSaving(this.forms, this.answers);
}

// Form  saved  go back to submissions list
class FormSaved extends DynamicFormState {
  final List<FormEntity> forms;
  FormSaved(this.forms);
}

// In-place success for edit / delete snackbar only, no navigation
class SubmissionActionSuccess extends DynamicFormState {
  final String message;
  final List<FormEntity> forms;
  final Map<String, dynamic> answers;
  SubmissionActionSuccess(this.message, this.forms, this.answers);
}

class FormError extends DynamicFormState {
  final String message;
  final List<FormEntity>? forms;
  final Map<String, dynamic>? answers;
  FormError(this.message, {this.forms, this.answers});
}
