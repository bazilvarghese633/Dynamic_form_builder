import 'package:dynamic_form_builder/core/color.dart';
import 'package:dynamic_form_builder/features/domain/entities/form_entity.dart';
import 'package:dynamic_form_builder/features/presentation/bloc/form_bloc.dart';
import 'package:dynamic_form_builder/features/presentation/bloc/form_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'input_decoration.dart';
import 'styled_checkbox.dart';
import 'styled_date_picker.dart';
import 'styled_dropdown.dart';
import 'styled_radio.dart';
import 'styled_text_field.dart';

Map<String, dynamic> _answersFrom(DynamicFormState state) {
  if (state is FormLoaded) return state.answers;
  if (state is SubmissionActionSuccess) return state.answers;
  return {};
}

class QuestionWidget extends StatelessWidget {
  final QuestionEntity question;

  const QuestionWidget(this.question, {super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FormBloc, DynamicFormState>(
      builder: (context, state) {
        final answers = _answersFrom(state);
        return Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 6),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _QuestionLabel(label: question.componentName),
              const SizedBox(height: 10),
              ...question.options.map((o) => _buildOption(context, o, answers)),
              const SizedBox(height: 4),
              const Divider(
                height: 1,
                thickness: 0.5,
                color: Color(0xFFEEEEF5),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildOption(
    BuildContext context,
    OptionEntity option,
    Map<String, dynamic> answers,
  ) {
    if (option.type == 'drop_down') {
      return StyledDropdown(
        question: question,
        option: option,
        answers: answers,
      );
    }
    if (option.type == 'input_single_line') {
      return StyledTextField(
        question: question,
        option: option,
        answers: answers,
        maxLines: 1,
      );
    }
    if (option.type == 'input_multiline') {
      return StyledTextField(
        question: question,
        option: option,
        answers: answers,
        maxLines: 4,
      );
    }
    if (option.type == 'date_picker') {
      return StyledDatePicker(
        question: question,
        option: option,
        answers: answers,
      );
    }
    if (question.multipleSelection) {
      return StyledCheckbox(
        question: question,
        option: option,
        answers: answers,
      );
    }
    return StyledRadio(question: question, option: option, answers: answers);
  }
}

class _QuestionLabel extends StatelessWidget {
  final String label;

  const _QuestionLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 4,
          height: 16,
          margin: const EdgeInsets.only(top: 1, right: 8),
          decoration: BoxDecoration(
            color: kAccent,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 14,
              color: kDark,
            ),
          ),
        ),
      ],
    );
  }
}
