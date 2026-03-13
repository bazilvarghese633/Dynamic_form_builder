abstract class FormEvent {}

class LoadFormEvent extends FormEvent {}

class UpdateAnswerEvent extends FormEvent {
  final String questionId;
  final dynamic value;

  UpdateAnswerEvent(this.questionId, this.value);
}
