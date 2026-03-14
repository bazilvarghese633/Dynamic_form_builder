import 'package:dynamic_form_builder/core/color.dart';
import 'package:dynamic_form_builder/features/domain/entities/form_entity.dart';
import 'package:dynamic_form_builder/features/presentation/bloc/form_bloc.dart';
import 'package:dynamic_form_builder/features/presentation/bloc/form_event.dart';
import 'package:dynamic_form_builder/features/presentation/widgets/question/input_decoration.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StyledDatePicker extends StatelessWidget {
  final QuestionEntity question;
  final OptionEntity option;
  final Map<String, dynamic> answers;

  const StyledDatePicker({
    super.key,
    required this.question,
    required this.option,
    required this.answers,
  });

  @override
  Widget build(BuildContext context) {
    final dt = toDateTime(answers[question.uid]);
    final text = dt != null ? formatDate(dt) : '';
    final today = DateTime.now();
    final todayOnly = DateTime(today.year, today.month, today.day);

    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: TextField(
        readOnly: true,
        controller: TextEditingController(text: text),
        style: const TextStyle(fontSize: 14, color: kDark),
        decoration: inputDecoration(option.hint ?? 'Select a date').copyWith(
          hintText: 'e.g. 15 March 2025',
          suffixIcon: const Icon(
            Icons.calendar_month_rounded,
            color: kAccent,
            size: 20,
          ),
        ),
        onTap: () async {
          final picked = await showDatePicker(
            context: context,
            initialDate: dt != null && dt.isAfter(todayOnly) ? dt : todayOnly,
            firstDate: todayOnly, // no past dates
            lastDate: DateTime(2100),
            builder: (ctx, child) => Theme(
              data: Theme.of(ctx).copyWith(
                colorScheme: const ColorScheme.light(primary: kAccent),
              ),
              child: child!,
            ),
          );
          if (picked != null && context.mounted) {
            context.read<FormBloc>().add(
              UpdateAnswerEvent(question.uid, picked),
            );
          }
        },
      ),
    );
  }
}
