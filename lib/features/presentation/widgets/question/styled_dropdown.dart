import 'package:dynamic_form_builder/features/domain/entities/form_entity.dart';
import 'package:dynamic_form_builder/features/presentation/bloc/form_bloc.dart';
import 'package:dynamic_form_builder/features/presentation/bloc/form_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'input_decoration.dart';

class StyledDropdown extends StatelessWidget {
  final QuestionEntity question;
  final OptionEntity option;
  final Map<String, dynamic> answers;

  const StyledDropdown({
    super.key,
    required this.question,
    required this.option,
    required this.answers,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: DropdownButtonFormField<String>(
        value: answers[question.uid],
        hint: Text(
          option.hint ?? 'Select an option',
          style: TextStyle(color: Colors.grey.shade400, fontSize: 14),
        ),
        isExpanded: true,
        decoration: inputDecoration(option.hint),
        items: option.dropDownOptions!
            .map(
              (v) => DropdownMenuItem(
                value: v,
                child: Text(v, style: const TextStyle(fontSize: 14)),
              ),
            )
            .toList(),
        onChanged: (v) =>
            context.read<FormBloc>().add(UpdateAnswerEvent(question.uid, v)),
      ),
    );
  }
}
