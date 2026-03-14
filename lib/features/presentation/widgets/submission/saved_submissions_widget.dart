import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dynamic_form_builder/core/utils/answer_formatter.dart';
import 'package:dynamic_form_builder/features/data/datasource/firestore_service.dart';
import 'package:dynamic_form_builder/features/domain/entities/form_entity.dart';
import 'package:dynamic_form_builder/features/presentation/bloc/form_bloc.dart';
import 'package:dynamic_form_builder/features/presentation/widgets/submission/empty_state.dart';
import 'package:dynamic_form_builder/features/presentation/widgets/submission/submission_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SavedSubmissionsWidget extends StatefulWidget {
  final String formName;
  final String sectionName;
  final List<QuestionEntity> questions;

  const SavedSubmissionsWidget({
    super.key,
    required this.formName,
    required this.sectionName,
    required this.questions,
  });

  @override
  State<SavedSubmissionsWidget> createState() => _SavedSubmissionsWidgetState();
}

class _SavedSubmissionsWidgetState extends State<SavedSubmissionsWidget> {
  Stream<QuerySnapshot>? _stream;

  @override
  void initState() {
    super.initState();
    _loadStream();
  }

  Future<void> _loadStream() async {
    final stream = await FirestoreService().getSubmissionsStream();
    if (mounted) setState(() => _stream = stream);
  }

  @override
  Widget build(BuildContext context) {
    if (_stream == null) {
      return const Center(
        child: CircularProgressIndicator(color: Color(0xFF7C83FD)),
      );
    }

    return StreamBuilder<QuerySnapshot>(
      stream: _stream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xFF7C83FD)),
          );
        }

        final docs = (snapshot.data?.docs ?? []).where((doc) {
          final d = doc.data() as Map<String, dynamic>;
          return d['formName'] == widget.formName &&
              d['sectionName'] == widget.sectionName;
        }).toList();

        if (docs.isEmpty) return const EmptyState();

        return ListView.separated(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 100),
          itemCount: docs.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final doc = docs[index];
            final data = doc.data() as Map<String, dynamic>;
            final answers = (data['answers'] as Map<String, dynamic>?) ?? {};
            final timestamp = data['timestamp'] as Timestamp?;

            return SubmissionCard(
              docId: doc.id,
              formName: widget.formName,
              answers: answers,
              formattedAnswers: AnswerFormatter.formatAnswers(
                answers,
                widget.questions,
              ),
              timestamp: timestamp,
              bloc: context.read<FormBloc>(),
              section: GenericDataEntity(
                name: widget.sectionName,
                questions: widget.questions,
              ),
              index: index,
            );
          },
        );
      },
    );
  }
}
