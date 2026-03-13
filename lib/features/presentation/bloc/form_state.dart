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
