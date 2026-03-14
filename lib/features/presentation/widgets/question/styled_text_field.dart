import 'package:dynamic_form_builder/core/color.dart';
import 'package:dynamic_form_builder/features/domain/entities/form_entity.dart';
import 'package:dynamic_form_builder/features/presentation/bloc/form_bloc.dart';
import 'package:dynamic_form_builder/features/presentation/bloc/form_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'input_decoration.dart';

class StyledTextField extends StatefulWidget {
  final QuestionEntity question;
  final OptionEntity option;
  final Map<String, dynamic> answers;
  final int maxLines;

  const StyledTextField({
    super.key,
    required this.question,
    required this.option,
    required this.answers,
    required this.maxLines,
  });

  @override
  State<StyledTextField> createState() => _StyledTextFieldState();
}

class _StyledTextFieldState extends State<StyledTextField> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    final existing = widget.answers[widget.question.uid];
    _controller = TextEditingController(text: existing?.toString() ?? '');
  }

  @override
  void didUpdateWidget(StyledTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    final incoming = widget.answers[widget.question.uid]?.toString() ?? '';
    if (incoming != _controller.text && !_controller.selection.isValid) {
      _controller.text = incoming;
      _controller.selection = TextSelection.collapsed(offset: incoming.length);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: TextField(
        controller: _controller,
        maxLines: widget.maxLines,
        maxLength: widget.option.maxLength,
        style: const TextStyle(fontSize: 14, color: kDark),
        onChanged: (v) => context.read<FormBloc>().add(
          UpdateAnswerEvent(widget.question.uid, v),
        ),
        decoration: inputDecoration(
          widget.option.hint,
        ).copyWith(hintText: widget.option.placeholder),
      ),
    );
  }
}
