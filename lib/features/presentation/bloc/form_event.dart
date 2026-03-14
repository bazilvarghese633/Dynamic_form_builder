import 'package:dynamic_form_builder/features/domain/entities/form_entity.dart';

abstract class FormEvent {}

class LoadFormEvent extends FormEvent {}

class LoadAnswersEvent extends FormEvent {
  final Map<String, dynamic> answers;
  LoadAnswersEvent(this.answers);
}

class UpdateAnswerEvent extends FormEvent {
  final String questionId;
  final dynamic value;
  UpdateAnswerEvent(this.questionId, this.value);
}

class SaveFormEvent extends FormEvent {
  final String formName;
  final String sectionName;
  SaveFormEvent(this.formName, this.sectionName);
}

class ClearAnswersEvent extends FormEvent {}

class EditSubmissionEvent extends FormEvent {
  final String documentId;
  final Map<String, dynamic> answers;
  final List<QuestionEntity>? questions; // for validation
  EditSubmissionEvent(this.documentId, this.answers, {this.questions});
}

class DeleteSubmissionEvent extends FormEvent {
  final String documentId;
  DeleteSubmissionEvent(this.documentId);
}
