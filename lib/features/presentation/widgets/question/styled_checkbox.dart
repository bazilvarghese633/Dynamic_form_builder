import 'package:dynamic_form_builder/features/domain/entities/form_entity.dart';
import 'package:dynamic_form_builder/features/presentation/bloc/form_bloc.dart';
import 'package:dynamic_form_builder/features/presentation/bloc/form_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'selectable_row.dart';

class StyledCheckbox extends StatelessWidget {
  final QuestionEntity question;
  final OptionEntity option;
  final Map<String, dynamic> answers;

  const StyledCheckbox({
    super.key,
    required this.question,
    required this.option,
    required this.answers,
  });

  @override
  Widget build(BuildContext context) {
    final selected = (answers[question.uid] as List?) ?? [];
    final isOn = selected.contains(option.name);

    return GestureDetector(
      onTap: () {
        final updated = List.from(selected);
        isOn ? updated.remove(option.name) : updated.add(option.name);
        context.read<FormBloc>().add(UpdateAnswerEvent(question.uid, updated));
      },
      child: SelectableRow(
        label: option.name,
        selected: isOn,
        isCheckbox: true,
      ),
    );
  }
}
