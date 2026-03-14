import 'package:dynamic_form_builder/core/color.dart';
import 'package:dynamic_form_builder/features/domain/entities/form_entity.dart';
import 'package:dynamic_form_builder/features/presentation/bloc/form_bloc.dart';
import 'package:dynamic_form_builder/features/presentation/bloc/form_event.dart';
import 'package:dynamic_form_builder/features/presentation/bloc/form_state.dart';
import 'package:dynamic_form_builder/features/presentation/screen/add_screen/widget/question_card.dart';
import 'package:dynamic_form_builder/features/presentation/screen/add_screen/widget/section_header.dart';
import 'package:dynamic_form_builder/features/presentation/utils/app_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddEntryScreen extends StatefulWidget {
  final String formName;
  final GenericDataEntity section;
  final String? editDocId;
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
    final bloc = context.read<FormBloc>();
    if (widget.isEditing && widget.existingAnswers != null) {
      bloc.add(LoadAnswersEvent(widget.existingAnswers!));
    } else {
      bloc.add(ClearAnswersEvent());
    }
  }

  void _onSave() {
    final bloc = context.read<FormBloc>();
    if (widget.isEditing) {
      final answers = bloc.state is FormLoaded
          ? (bloc.state as FormLoaded).answers
          : {};
      bloc.add(
        EditSubmissionEvent(widget.editDocId!, answers as Map<String, dynamic>),
      );
    } else {
      bloc.add(SaveFormEvent(widget.formName, widget.section.name));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<FormBloc, DynamicFormState>(
      listener: _handleState,
      child: BlocBuilder<FormBloc, DynamicFormState>(
        builder: (context, state) => Scaffold(
          backgroundColor: scaffbackgroundColor,
          appBar: _buildAppBar(state is FormSaving),
          body: _buildBody(),
        ),
      ),
    );
  }

  void _handleState(BuildContext context, DynamicFormState state) {
    if (state is FormSaved || state is SubmissionActionSuccess) {
      Navigator.of(context).pop();
      final msg = state is FormSaved
          ? 'Entry saved!'
          : (state as SubmissionActionSuccess).message;
      showSnack(context, msg, green700, Icons.check_circle_rounded);
    }
    if (state is FormError) {
      showSnack(context, state.message, red700, Icons.error_rounded);
    }
  }

  AppBar _buildAppBar(bool isSaving) {
    return AppBar(
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
      actions: [_buildSaveAction(isSaving)],
    );
  }

  Widget _buildSaveAction(bool isSaving) {
    if (isSaving) {
      return const Padding(
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
      );
    }
    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: TextButton(
        onPressed: _onSave,
        style: TextButton.styleFrom(
          backgroundColor: const Color(0xFF7C83FD),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Text(
          widget.isEditing ? 'Update' : 'Save',
          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
        ),
      ),
    );
  }

  Widget _buildBody() {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 120),
      children: [
        SectionHeader(section: widget.section, isEditing: widget.isEditing),
        const SizedBox(height: 16),
        ...widget.section.questions.map(
          (q) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: QuestionCard(question: q),
          ),
        ),
      ],
    );
  }
}
