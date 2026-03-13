import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dynamic_form_builder/core/color.dart';
import 'package:dynamic_form_builder/core/utils/answer_formatter.dart';
import 'package:dynamic_form_builder/features/presentation/bloc/form_bloc.dart';
import 'package:dynamic_form_builder/features/presentation/bloc/form_event.dart';
import 'package:dynamic_form_builder/features/presentation/screen/add_entry_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/form_entity.dart' hide AnswerFormatter;

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

        final allDocs = snapshot.data?.docs ?? [];
        final docs = allDocs.where((doc) {
          final d = doc.data() as Map<String, dynamic>;
          return d['formName'] == formName && d['sectionName'] == sectionName;
        }).toList();

        if (docs.isEmpty) {
          return _EmptyState(formName: formName, sectionName: sectionName);
        }

        return ListView.separated(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 100),
          itemCount: docs.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final doc = docs[index];
            final data = doc.data() as Map<String, dynamic>;
            final answers = (data['answers'] as Map<String, dynamic>?) ?? {};
            final timestamp = data['timestamp'] as Timestamp?;
            final formatted = AnswerFormatter.formatAnswers(answers, questions);
            final bloc = context.read<FormBloc>();

            return _SubmissionCard(
              docId: doc.id,
              answers: answers,
              formattedAnswers: formatted,
              timestamp: timestamp,
              bloc: bloc,
              questions: questions,
              section: GenericDataEntity(
                name: sectionName,
                questions: questions,
              ),
              formName: formName,
              index: index,
            );
          },
        );
      },
    );
  }
}

// Empty State

class _EmptyState extends StatelessWidget {
  final String formName;
  final String sectionName;

  const _EmptyState({required this.formName, required this.sectionName});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFF7C83FD).withOpacity(0.08),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.inbox_rounded,
                size: 48,
                color: Color(0xFF7C83FD),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'No entries yet',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1A1A2E),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Tap the + New Entry button\nto add your first entry.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade500,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Submission Card

class _SubmissionCard extends StatelessWidget {
  final String docId;
  final String formName;
  final Map<String, dynamic> answers;
  final Map<String, String> formattedAnswers;
  final Timestamp? timestamp;
  final FormBloc bloc;
  final List<QuestionEntity> questions;
  final GenericDataEntity section;
  final int index;

  const _SubmissionCard({
    required this.docId,
    required this.formName,
    required this.answers,
    required this.formattedAnswers,
    required this.timestamp,
    required this.bloc,
    required this.questions,
    required this.section,
    required this.index,
  });

  String get _date {
    if (timestamp == null) return 'No date';
    final dt = timestamp!.toDate();
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[dt.month - 1]} ${dt.day}, ${dt.year}';
  }

  String get _time {
    if (timestamp == null) return '';
    final dt = timestamp!.toDate();
    return '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }

  void _navigateToEdit(BuildContext context) {
    final formBloc = bloc;
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (_, animation, __) => BlocProvider.value(
          value: formBloc,
          child: AddEntryScreen(
            formName: formName,
            section: section,
            editDocId: docId,
            existingAnswers: answers,
          ),
        ),
        transitionsBuilder: (_, animation, __, child) {
          final slide =
              Tween<Offset>(
                begin: const Offset(0, 1),
                end: Offset.zero,
              ).animate(
                CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
              );
          return SlideTransition(position: slide, child: child);
        },
      ),
    );
  }

  void _showDeleteDialog(BuildContext context) {
    final formBloc = bloc;
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
        actionsPadding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        title: const Row(
          children: [
            Icon(
              Icons.delete_forever_rounded,
              color: Color(0xFFE84855),
              size: 22,
            ),
            SizedBox(width: 8),
            Text('Delete Entry', style: TextStyle(fontSize: 17)),
          ],
        ),
        content: const Text(
          'This entry will be permanently deleted. Are you sure?',
          style: TextStyle(fontSize: 14, color: Colors.black54),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              formBloc.add(DeleteSubmissionEvent(docId));
            },
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFFE84855),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    accents;
    final accent = accents[index % accents.length];
    final previewEntries = formattedAnswers.entries.take(2).toList();

    return Container(
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.fromLTRB(16, 14, 12, 14),
            decoration: BoxDecoration(
              color: accent.withOpacity(0.06),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                // Index badge
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: accent.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    '#${index + 1}',
                    style: TextStyle(
                      color: accent,
                      fontWeight: FontWeight.w800,
                      fontSize: 13,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _date,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                          color: Color(0xFF1A1A2E),
                        ),
                      ),
                      Text(
                        _time,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ),
                ),
                // Edit → navigates to AddEntryScreen in edit mode
                _IconBtn(
                  icon: Icons.edit_rounded,
                  color: const Color(0xFF4A90D9),
                  tooltip: 'Edit',
                  onTap: () => _navigateToEdit(context),
                ),
                const SizedBox(width: 6),
                // Delete → confirm dialog
                _IconBtn(
                  icon: Icons.delete_rounded,
                  color: const Color(0xFFE84855),
                  tooltip: 'Delete',
                  onTap: () => _showDeleteDialog(context),
                ),
              ],
            ),
          ),

          // Preview answers (first 2)
          if (previewEntries.isNotEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
              child: Column(
                children: previewEntries
                    .map(
                      (e) => _AnswerRow(
                        label: e.key,
                        value: e.value,
                        accent: accent,
                      ),
                    )
                    .toList(),
              ),
            ),

          // Expand for remaining answers
          if (formattedAnswers.length > 2)
            Theme(
              data: Theme.of(
                context,
              ).copyWith(dividerColor: Colors.transparent),
              child: ExpansionTile(
                tilePadding: const EdgeInsets.symmetric(horizontal: 16),
                childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                title: Text(
                  'Show all ${formattedAnswers.length} answers',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: accent,
                  ),
                ),
                trailing: Icon(Icons.expand_more_rounded, color: accent),
                children: formattedAnswers.entries
                    .skip(2)
                    .map(
                      (e) => _AnswerRow(
                        label: e.key,
                        value: e.value,
                        accent: accent,
                      ),
                    )
                    .toList(),
              ),
            )
          else
            const SizedBox(height: 12),
        ],
      ),
    );
  }
}

//  Answer Row
class _AnswerRow extends StatelessWidget {
  final String label;
  final String value;
  final Color accent;

  const _AnswerRow({
    required this.label,
    required this.value,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 3,
            height: 14,
            margin: const EdgeInsets.only(top: 2, right: 10),
            decoration: BoxDecoration(
              color: accent,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Color(0xFF444466),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: const TextStyle(fontSize: 13, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }
}

// Icon Button

class _IconBtn extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String tooltip;
  final VoidCallback onTap;

  const _IconBtn({
    required this.icon,
    required this.color,
    required this.tooltip,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.all(7),
            child: Icon(icon, color: color, size: 18),
          ),
        ),
      ),
    );
  }
}
