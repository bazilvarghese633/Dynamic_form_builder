import 'package:dynamic_form_builder/features/domain/entities/form_entity.dart';
import 'package:dynamic_form_builder/features/presentation/bloc/form_bloc.dart';
import 'package:dynamic_form_builder/features/presentation/bloc/form_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'selectable_row.dart';

class StyledRadio extends StatelessWidget {
  final QuestionEntity question;
  final OptionEntity option;
  final Map<String, dynamic> answers;

  const StyledRadio({
    super.key,
    required this.question,
    required this.option,
    required this.answers,
  });

  @override
  Widget build(BuildContext context) {
    final selected = answers[question.uid];
    final isOn = selected == option.name;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () {
            context.read<FormBloc>()
              ..add(UpdateAnswerEvent(question.uid, option.name))
              ..add(UpdateAnswerEvent('${question.uid}_sub', []));
          },
          child: SelectableRow(
            label: option.name,
            selected: isOn,
            isCheckbox: false,
          ),
        ),
        if (isOn && option.subData != null)
          Padding(
            padding: const EdgeInsets.only(left: 28, bottom: 4),
            child: Column(
              children: option.subData!.map((sub) {
                final subSelected =
                    (answers['${question.uid}_sub'] as List?) ?? [];
                final subOn = subSelected.contains(sub.name);
                return GestureDetector(
                  onTap: () {
                    final updated = List.from(subSelected);
                    subOn ? updated.remove(sub.name) : updated.add(sub.name);
                    context.read<FormBloc>().add(
                      UpdateAnswerEvent('${question.uid}_sub', updated),
                    );
                  },
                  child: SelectableRow(
                    label: sub.name,
                    selected: subOn,
                    isCheckbox: true,
                    small: true,
                  ),
                );
              }).toList(),
            ),
          ),
      ],
    );
  }
}
