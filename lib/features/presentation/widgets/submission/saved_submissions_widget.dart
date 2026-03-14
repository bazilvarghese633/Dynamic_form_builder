import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dynamic_form_builder/core/utils/answer_formatter.dart';
import 'package:dynamic_form_builder/features/domain/entities/form_entity.dart';
import 'package:dynamic_form_builder/features/presentation/bloc/form_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'empty_state.dart';
import 'submission_card.dart';

class SavedSubmissionsWidget extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('form_submissions')
          .orderBy('timestamp', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xFF7C83FD)),
          );
        }

        final docs = (snapshot.data?.docs ?? []).where((doc) {
          final d = doc.data() as Map<String, dynamic>;
          return d['formName'] == formName && d['sectionName'] == sectionName;
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
              formName: formName,
              answers: answers,
              formattedAnswers: AnswerFormatter.formatAnswers(
                answers,
                questions,
              ),
              timestamp: timestamp,
              bloc: context.read<FormBloc>(),
              section: GenericDataEntity(
                name: sectionName,
                questions: questions,
              ),
              index: index,
            );
          },
        );
      },
    );
  }
}
