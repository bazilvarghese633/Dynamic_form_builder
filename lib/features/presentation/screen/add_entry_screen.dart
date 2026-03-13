import 'package:dynamic_form_builder/core/color.dart';
import 'package:dynamic_form_builder/features/domain/entities/form_entity.dart';
import 'package:dynamic_form_builder/features/presentation/bloc/form_bloc.dart';
import 'package:dynamic_form_builder/features/presentation/bloc/form_event.dart';
import 'package:dynamic_form_builder/features/presentation/bloc/form_state.dart';
import 'package:dynamic_form_builder/features/presentation/widgets/question_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddEntryScreen extends StatefulWidget {
  final String formName;
  final GenericDataEntity section;

  /// if it is there the screen is in edit mode
  final String? editDocId;

  /// pre filled answers for editing
  final Map<String, dynamic>? existingAnswers;

  const AddEntryScreen({
    super.key,
    required this.formName,
    required this.section,
    this.editDocId,
    this.existingAnswers,
  });

  bool get isEditing => editDocId != null;

  @override
  State<AddEntryScreen> createState() => _AddEntryScreenState();
}

class _AddEntryScreenState extends State<AddEntryScreen> {
  @override
  void initState() {
    super.initState();
    if (widget.isEditing && widget.existingAnswers != null) {
      //loading existing answers to bloc

      context.read<FormBloc>().add(LoadAnswersEvent(widget.existingAnswers!));
    } else {
      context.read<FormBloc>().add(ClearAnswersEvent());
    }
  }

  void _onSave(BuildContext context) {
    final bloc = context.read<FormBloc>();
    if (widget.isEditing) {
      // Get current answers from state and fire edit event
      final state = bloc.state;
      Map<String, dynamic> answers = {};
      if (state is FormLoaded) answers = state.answers;
      bloc.add(EditSubmissionEvent(widget.editDocId!, answers));
    } else {
      bloc.add(SaveFormEvent(widget.formName, widget.section.name));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<FormBloc, DynamicFormState>(
      listener: (context, state) {
        // Both save (new) and edit success pop back
        if (state is FormSaved || state is SubmissionActionSuccess) {
          Navigator.of(context).pop();
          final msg = state is FormSaved
              ? 'Entry saved!'
              : (state as SubmissionActionSuccess).message;
          _showSnack(context, msg, green700, Icons.check_circle_rounded);
        }
        if (state is FormError) {
          _showSnack(context, state.message, red700, Icons.error_rounded);
        }
      },
      child: BlocBuilder<FormBloc, DynamicFormState>(
        builder: (context, state) {
          final isSaving = state is FormSaving;

          return Scaffold(
            backgroundColor: scaffbackgroundColor,
            appBar: AppBar(
              backgroundColor: appBarbackgroundColor,
              foregroundColor: whiteColor,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.keyboard_arrow_down_rounded, size: 28),
                onPressed: () => Navigator.of(context).pop(),
              ),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.formName,
                    style: const TextStyle(
                      fontSize: 11,
                      color: Color(0xFF7C83FD),
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.5,
                    ),
                  ),
                  Text(
                    widget.section.name,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              actions: [
                if (isSaving)
                  const Padding(
                    padding: EdgeInsets.only(right: 16),
                    child: Center(
                      child: SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: Color(0xFF7C83FD),
                          strokeWidth: 2.5,
                        ),
                      ),
                    ),
                  )
                else
                  Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: TextButton(
                      onPressed: () => _onSave(context),
                      style: TextButton.styleFrom(
                        backgroundColor: const Color(0xFF7C83FD),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 8,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        widget.isEditing ? 'Update' : 'Save',
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            body: ListView(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 120),
              children: [
                _SectionHeader(
                  section: widget.section,
                  isEditing: widget.isEditing,
                ),
                const SizedBox(height: 16),
                ...widget.section.questions.map(
                  (q) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _QuestionCard(question: q),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showSnack(
    BuildContext context,
    String msg,
    Color color,
    IconData icon,
  ) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: whiteColor, size: 18),
            const SizedBox(width: 10),
            Expanded(child: Text(msg)),
          ],
        ),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}

// header section

class _SectionHeader extends StatelessWidget {
  final GenericDataEntity section;
  final bool isEditing;

  const _SectionHeader({required this.section, required this.isEditing});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A2E),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF7C83FD).withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              isEditing ? Icons.edit_rounded : Icons.edit_note_rounded,
              color: const Color(0xFF7C83FD),
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isEditing ? 'EDITING ENTRY' : 'NEW ENTRY',
                  style: const TextStyle(
                    color: Color(0xFF7C83FD),
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.8,
                  ),
                ),
                Text(
                  '${section.questions.length} question${section.questions.length == 1 ? '' : 's'}',
                  style: const TextStyle(color: Colors.white70, fontSize: 13),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// question card

class _QuestionCard extends StatelessWidget {
  final QuestionEntity question;

  const _QuestionCard({required this.question});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: QuestionWidget(question),
    );
  }
}
