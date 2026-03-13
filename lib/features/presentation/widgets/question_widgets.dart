import 'package:dynamic_form_builder/features/domain/entities/form_entity.dart';
import 'package:dynamic_form_builder/features/presentation/bloc/form_bloc.dart';
import 'package:dynamic_form_builder/features/presentation/bloc/form_event.dart';
import 'package:dynamic_form_builder/features/presentation/bloc/form_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

const _kAccent = Color(0xFF7C83FD);
const _kDark = Color(0xFF1A1A2E);

// get answer form any state

Map<String, dynamic> _answersFrom(DynamicFormState state) {
  if (state is FormLoaded) return state.answers;
  if (state is SubmissionActionSuccess) return state.answers;
  return {};
}

// QuestionWidget

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
              // Question label
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 4,
                    height: 16,
                    margin: const EdgeInsets.only(top: 1, right: 8),
                    decoration: BoxDecoration(
                      color: _kAccent,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      question.componentName,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                        color: _kDark,
                      ),
                    ),
                  ),
                ],
              ),
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
      return _StyledDropdown(
        question: question,
        option: option,
        answers: answers,
      );
    }
    if (option.type == 'input_single_line') {
      return _StyledTextField(
        question: question,
        option: option,
        answers: answers,
        maxLines: 1,
      );
    }
    if (option.type == 'input_multiline') {
      return _StyledTextField(
        question: question,
        option: option,
        answers: answers,
        maxLines: 4,
      );
    }
    if (option.type == 'date_picker') {
      return _StyledDatePicker(
        question: question,
        option: option,
        answers: answers,
      );
    }
    if (question.multipleSelection) {
      return _StyledCheckbox(
        question: question,
        option: option,
        answers: answers,
      );
    }
    return _StyledRadio(question: question, option: option, answers: answers);
  }
}

// Dropdown

class _StyledDropdown extends StatelessWidget {
  final QuestionEntity question;
  final OptionEntity option;
  final Map<String, dynamic> answers;

  const _StyledDropdown({
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
        decoration: _inputDecoration(option.hint),
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

// Text Field — StatefulWidget so controller stays in sync

class _StyledTextField extends StatefulWidget {
  final QuestionEntity question;
  final OptionEntity option;
  final Map<String, dynamic> answers;
  final int maxLines;

  const _StyledTextField({
    required this.question,
    required this.option,
    required this.answers,
    required this.maxLines,
  });

  @override
  State<_StyledTextField> createState() => _StyledTextFieldState();
}

class _StyledTextFieldState extends State<_StyledTextField> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    // Pre-fill with existing answer when editing
    final existing = widget.answers[widget.question.uid];
    _controller = TextEditingController(text: existing?.toString() ?? '');
  }

  @override
  void didUpdateWidget(_StyledTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    // If the answer was loaded from outside (e.g. LoadAnswersEvent) and
    // the controller text doesn't match, sync it — but only if the user
    // isn't currently focused (avoid cursor jumping mid-type)
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
        style: const TextStyle(fontSize: 14, color: _kDark),
        onChanged: (v) => context.read<FormBloc>().add(
          UpdateAnswerEvent(widget.question.uid, v),
        ),
        decoration: _inputDecoration(
          widget.option.hint,
        ).copyWith(hintText: widget.option.placeholder),
      ),
    );
  }
}

// ── Date helpers ──────────────────────────────────────────────────────────────

/// Converts whatever Firestore/bloc gives us into a nullable DateTime.
/// Handles: DateTime, Timestamp, and ISO/formatted strings.
DateTime? _toDateTime(dynamic raw) {
  if (raw == null) return null;
  if (raw is DateTime) return raw;
  // Firestore Timestamp — use duck-typing so we don't need a direct import
  if (raw.runtimeType.toString().contains('Timestamp')) {
    return (raw as dynamic).toDate() as DateTime;
  }
  if (raw is String && raw.isNotEmpty) {
    return DateTime.tryParse(raw);
  }
  return null;
}

/// Formats a DateTime as "15 March 2025" — clear and unambiguous.
String _formatDate(DateTime dt) {
  const months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];
  return '${dt.day} ${months[dt.month - 1]} ${dt.year}';
}

// Date Picker

class _StyledDatePicker extends StatelessWidget {
  final QuestionEntity question;
  final OptionEntity option;
  final Map<String, dynamic> answers;

  const _StyledDatePicker({
    required this.question,
    required this.option,
    required this.answers,
  });

  @override
  Widget build(BuildContext context) {
    final dt = _toDateTime(answers[question.uid]);
    final text = dt != null ? _formatDate(dt) : '';

    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: TextField(
        readOnly: true,
        controller: TextEditingController(text: text),
        style: const TextStyle(fontSize: 14, color: _kDark),
        decoration: _inputDecoration(option.hint ?? 'Select a date').copyWith(
          hintText: 'e.g. 15 March 2025',
          suffixIcon: const Icon(
            Icons.calendar_month_rounded,
            color: _kAccent,
            size: 20,
          ),
        ),
        onTap: () async {
          final picked = await showDatePicker(
            context: context,
            initialDate: dt ?? DateTime.now(),
            firstDate: DateTime(2000),
            lastDate: DateTime(2100),
            builder: (ctx, child) => Theme(
              data: Theme.of(ctx).copyWith(
                colorScheme: const ColorScheme.light(primary: _kAccent),
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

//  Checkbox

class _StyledCheckbox extends StatelessWidget {
  final QuestionEntity question;
  final OptionEntity option;
  final Map<String, dynamic> answers;

  const _StyledCheckbox({
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
      child: _SelectableRow(
        label: option.name,
        selected: isOn,
        isCheckbox: true,
      ),
    );
  }
}

// Radio + sub-options

class _StyledRadio extends StatelessWidget {
  final QuestionEntity question;
  final OptionEntity option;
  final Map<String, dynamic> answers;

  const _StyledRadio({
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
            context.read<FormBloc>().add(
              UpdateAnswerEvent(question.uid, option.name),
            );
            context.read<FormBloc>().add(
              UpdateAnswerEvent('${question.uid}_sub', []),
            );
          },
          child: _SelectableRow(
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
                  child: _SelectableRow(
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

// Selectable Row

class _SelectableRow extends StatelessWidget {
  final String label;
  final bool selected;
  final bool isCheckbox;
  final bool small;

  const _SelectableRow({
    required this.label,
    required this.selected,
    required this.isCheckbox,
    this.small = false,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 160),
      margin: const EdgeInsets.only(bottom: 7),
      padding: EdgeInsets.symmetric(
        horizontal: small ? 10 : 12,
        vertical: small ? 8 : 10,
      ),
      decoration: BoxDecoration(
        color: selected ? _kAccent.withOpacity(0.08) : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: selected ? _kAccent : Colors.grey.shade200,
          width: selected ? 1.5 : 1,
        ),
      ),
      child: Row(
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 160),
            child: Icon(
              isCheckbox
                  ? (selected
                        ? Icons.check_box_rounded
                        : Icons.check_box_outline_blank_rounded)
                  : (selected
                        ? Icons.radio_button_checked_rounded
                        : Icons.radio_button_unchecked_rounded),
              key: ValueKey(selected),
              color: selected ? _kAccent : Colors.grey.shade400,
              size: small ? 18 : 20,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: small ? 13 : 14,
                color: selected ? _kDark : Colors.black87,
                fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

//  Shared input decoration

InputDecoration _inputDecoration(String? label) => InputDecoration(
  labelText: label,
  labelStyle: const TextStyle(fontSize: 13, color: Colors.grey),
  filled: true,
  fillColor: Colors.grey.shade50,
  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: BorderSide(color: Colors.grey.shade200),
  ),
  enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: BorderSide(color: Colors.grey.shade200),
  ),
  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: const BorderSide(color: _kAccent, width: 2),
  ),
);
