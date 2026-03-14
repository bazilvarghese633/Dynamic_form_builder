import 'package:dynamic_form_builder/core/utils/form_validator.dart';
import 'package:dynamic_form_builder/features/domain/entities/form_entity.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_form_data.dart';
import '../../domain/usecases/save_form_data.dart';
import '../../domain/usecases/delete_submission.dart';
import '../../domain/usecases/update_submission.dart';
import 'form_event.dart';
import 'form_state.dart';

class FormBloc extends Bloc<FormEvent, DynamicFormState> {
  final GetFormData getFormData;
  final SaveFormData saveFormData;
  final DeleteSubmission deleteSubmission;
  final UpdateSubmission updateSubmission;

  FormBloc(
    this.getFormData,
    this.saveFormData,
    this.deleteSubmission,
    this.updateSubmission,
  ) : super(FormLoading()) {
    on<LoadFormEvent>((event, emit) async {
      emit(FormLoading());
      final forms = await getFormData();
      emit(FormLoaded(forms));
    });

    on<ClearAnswersEvent>((event, emit) {
      final forms = _currentForms;
      if (forms != null) emit(FormLoaded(forms, answers: {}));
    });

    on<LoadAnswersEvent>((event, emit) {
      final forms = _currentForms;
      if (forms != null) {
        emit(FormLoaded(forms, answers: Map.from(event.answers)));
      }
    });

    on<UpdateAnswerEvent>((event, emit) {
      final forms = _currentForms;
      final answers = Map<String, dynamic>.from(_currentAnswers);
      if (forms == null) return;
      answers[event.questionId] = event.value;
      emit(FormLoaded(forms, answers: answers));
    });

    on<SaveFormEvent>((event, emit) async {
      final forms = _currentForms;
      final answers = _currentAnswers;
      if (forms == null) return;

      // Find the section being saved to validate its questions
      final section = _findSection(forms, event.formName, event.sectionName);
      if (section != null) {
        final error = FormValidator.validate(section.questions, answers);
        if (error != null) {
          emit(FormError(error, forms: forms, answers: answers));
          emit(FormLoaded(forms, answers: answers));
          return;
        }
      }

      emit(FormSaving(forms, answers));
      try {
        await saveFormData(
          formName: event.formName,
          sectionName: event.sectionName,
          answers: answers,
        );
        emit(FormSaved(forms));
      } catch (e) {
        emit(FormError('Failed to save: $e', forms: forms, answers: answers));
        emit(FormLoaded(forms, answers: answers));
      }
    });

    on<EditSubmissionEvent>((event, emit) async {
      final forms = _currentForms;
      final answers = _currentAnswers;
      if (forms == null) return;

      // Validate answers before updating
      if (event.questions != null) {
        final error = FormValidator.validate(event.questions!, event.answers);
        if (error != null) {
          emit(FormError(error, forms: forms, answers: answers));
          emit(FormLoaded(forms, answers: answers));
          return;
        }
      }

      try {
        await updateSubmission(
          documentId: event.documentId,
          answers: event.answers,
        );
        emit(SubmissionActionSuccess('Submission updated!', forms, answers));
      } catch (e) {
        emit(FormError('Failed to update: $e', forms: forms, answers: answers));
        emit(FormLoaded(forms, answers: answers));
      }
    });

    on<DeleteSubmissionEvent>((event, emit) async {
      final forms = _currentForms;
      final answers = _currentAnswers;
      if (forms == null) return;
      try {
        await deleteSubmission(event.documentId);
        emit(SubmissionActionSuccess('Submission deleted!', forms, answers));
      } catch (e) {
        emit(FormError('Failed to delete: $e', forms: forms, answers: answers));
        emit(FormLoaded(forms, answers: answers));
      }
    });
  }

  GenericDataEntity? _findSection(
    List<FormEntity> forms,
    String formName,
    String sectionName,
  ) {
    try {
      final form = forms.firstWhere((f) => f.name == formName);
      return form.genericData.firstWhere((s) => s.name == sectionName);
    } catch (_) {
      return null;
    }
  }

  List<FormEntity>? get _currentForms {
    final s = state;
    if (s is FormLoaded) return s.forms;
    if (s is FormSaving) return s.forms;
    if (s is FormSaved) return s.forms;
    if (s is SubmissionActionSuccess) return s.forms;
    if (s is FormError) return s.forms;
    return null;
  }

  Map<String, dynamic> get _currentAnswers {
    final s = state;
    if (s is FormLoaded) return s.answers;
    if (s is FormSaving) return s.answers;
    if (s is SubmissionActionSuccess) return s.answers;
    if (s is FormError) return s.answers ?? {};
    return {};
  }
}
