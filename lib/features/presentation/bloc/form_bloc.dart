import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_form_data.dart';
import 'form_event.dart';
import 'form_state.dart';

class FormBloc extends Bloc<FormEvent, DynamicFormState> {
  final GetFormData getFormData;

  FormBloc(this.getFormData) : super(FormLoading()) {
    on<LoadFormEvent>((event, emit) async {
      final forms = await getFormData();

      emit(FormLoaded(forms));
    });

    on<UpdateAnswerEvent>((event, emit) {
      if (state is FormLoaded) {
        final currentState = state as FormLoaded;

        final updatedAnswers = Map<String, dynamic>.from(currentState.answers);

        updatedAnswers[event.questionId] = event.value;

        emit(currentState.copyWith(answers: updatedAnswers));
      }
    });
  }
}
