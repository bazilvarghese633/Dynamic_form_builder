import 'package:dynamic_form_builder/features/domain/entities/form_entity.dart';
import 'package:dynamic_form_builder/features/presentation/bloc/form_bloc.dart';
import 'package:dynamic_form_builder/features/presentation/bloc/form_event.dart';
import 'package:dynamic_form_builder/features/presentation/bloc/form_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class QuestionWidget extends StatelessWidget {
  final QuestionEntity question;

  const QuestionWidget(this.question, {super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FormBloc, DynamicFormState>(
      builder: (context, state) {
        if (state is! FormLoaded) {
          return const SizedBox();
        }

        final answers = state.answers;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8),
              child: Text(
                question.componentName,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),

            ...question.options.map((option) {
              // DROPDOWN

              if (option.type == "drop_down") {
                return Padding(
                  padding: const EdgeInsets.all(8),
                  child: DropdownButtonFormField<String>(
                    value: answers[question.uid],
                    hint: Text(option.hint ?? "Select"),
                    items: option.dropDownOptions!
                        .map(
                          (value) => DropdownMenuItem(
                            value: value,
                            child: Text(value),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      context.read<FormBloc>().add(
                        UpdateAnswerEvent(question.uid, value),
                      );
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                  ),
                );
              }

              // TEXT INPUT

              if (option.type == "input_single_line") {
                return Padding(
                  padding: const EdgeInsets.all(8),
                  child: TextField(
                    maxLength: option.maxLength,
                    onChanged: (value) {
                      context.read<FormBloc>().add(
                        UpdateAnswerEvent(question.uid, value),
                      );
                    },
                    decoration: InputDecoration(
                      hintText: option.placeholder,
                      labelText: option.hint,
                      border: const OutlineInputBorder(),
                    ),
                  ),
                );
              }

              // MULTI LINE INPUT

              if (option.type == "input_multiline") {
                return Padding(
                  padding: const EdgeInsets.all(8),
                  child: TextField(
                    maxLines: 4,
                    maxLength: option.maxLength,
                    onChanged: (value) {
                      context.read<FormBloc>().add(
                        UpdateAnswerEvent(question.uid, value),
                      );
                    },
                    decoration: InputDecoration(
                      hintText: option.placeholder,
                      labelText: option.hint,
                      border: const OutlineInputBorder(),
                    ),
                  ),
                );
              }

              // DATE PICKER

              if (option.type == "date_picker") {
                final selectedDate = answers[question.uid];

                return Padding(
                  padding: const EdgeInsets.all(8),
                  child: TextField(
                    readOnly: true,
                    controller: TextEditingController(
                      text: selectedDate == null
                          ? ""
                          : "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}",
                    ),
                    decoration: InputDecoration(
                      hintText: option.hint ?? "Select date",
                      border: const OutlineInputBorder(),
                      suffixIcon: const Icon(Icons.calendar_today),
                    ),
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );

                      if (pickedDate != null) {
                        context.read<FormBloc>().add(
                          UpdateAnswerEvent(question.uid, pickedDate),
                        );
                      }
                    },
                  ),
                );
              }

              // MULTIPLE SELECTION

              if (question.multipleSelection) {
                final selected = answers[question.uid] ?? [];

                return CheckboxListTile(
                  title: Text(option.name),
                  value: selected.contains(option.name),
                  onChanged: (value) {
                    List updated = List.from(selected);

                    if (value!) {
                      updated.add(option.name);
                    } else {
                      updated.remove(option.name);
                    }

                    context.read<FormBloc>().add(
                      UpdateAnswerEvent(question.uid, updated),
                    );
                  },
                );
              }

              // RADIO

              final selectedOption = answers[question.uid];

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RadioListTile(
                    title: Text(option.name),
                    value: option.name,
                    groupValue: selectedOption,
                    onChanged: (value) {
                      final bloc = context.read<FormBloc>();

                      bloc.add(UpdateAnswerEvent(question.uid, value));

                      bloc.add(UpdateAnswerEvent("${question.uid}_sub", []));
                    },
                  ),

                  // SUB OPTIONS
                  if (selectedOption == option.name && option.subData != null)
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Column(
                        children: option.subData!.map((subOption) {
                          final subSelected =
                              answers["${question.uid}_sub"] ?? [];

                          return CheckboxListTile(
                            title: Text(subOption.name),
                            value: subSelected.contains(subOption.name),
                            onChanged: (value) {
                              List updated = List.from(subSelected);

                              if (value!) {
                                updated.add(subOption.name);
                              } else {
                                updated.remove(subOption.name);
                              }

                              context.read<FormBloc>().add(
                                UpdateAnswerEvent(
                                  "${question.uid}_sub",
                                  updated,
                                ),
                              );
                            },
                          );
                        }).toList(),
                      ),
                    ),
                ],
              );
            }),
          ],
        );
      },
    );
  }
}
