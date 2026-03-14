import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dynamic_form_builder/core/color.dart';
import 'package:dynamic_form_builder/features/domain/entities/form_entity.dart';
import 'package:dynamic_form_builder/features/presentation/bloc/form_bloc.dart';
import 'package:dynamic_form_builder/features/presentation/screen/add_screen/add_entry_screen.dart';
import 'package:dynamic_form_builder/features/presentation/widgets/submission/delete_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dynamic_form_builder/features/presentation/widgets/submission/answer_row.dart';
import 'package:dynamic_form_builder/features/presentation/widgets/submission/icon_btn.dart';

class SubmissionCard extends StatelessWidget {
  final String docId;
  final String formName;
  final Map<String, dynamic> answers;
  final Map<String, String> formattedAnswers;
  final Timestamp? timestamp;
  final FormBloc bloc;
  final GenericDataEntity section;
  final int index;

  const SubmissionCard({
    super.key,
    required this.docId,
    required this.formName,
    required this.answers,
    required this.formattedAnswers,
    required this.timestamp,
    required this.bloc,
    required this.section,
    required this.index,
  });

  String get _date {
    if (timestamp == null) return 'No date';
    final dt = timestamp!.toDate();
    const m = [
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
    return '${m[dt.month - 1]} ${dt.day}, ${dt.year}';
  }

  String get _time {
    if (timestamp == null) return '';
    final dt = timestamp!.toDate();
    return '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }

  void _navigateToEdit(BuildContext context) {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (_, animation, __) => BlocProvider.value(
          value: bloc,
          child: AddEntryScreen(
            formName: formName,
            section: section,
            editDocId: docId,
            existingAnswers: answers,
          ),
        ),
        transitionsBuilder: (_, animation, __, child) => SlideTransition(
          position: Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero)
              .animate(
                CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
              ),
          child: child,
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context) =>
      showDeleteDialog(context, bloc, docId);

  @override
  Widget build(BuildContext context) {
    final accent = accents[index % accents.length];
    final preview = formattedAnswers.entries.take(2).toList();

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
          _CardHeader(
            accent: accent,
            date: _date,
            time: _time,
            index: index,
            onEdit: () => _navigateToEdit(context),
            onDelete: () => _showDeleteDialog(context),
          ),
          if (preview.isNotEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
              child: Column(
                children: preview
                    .map(
                      (e) => AnswerRow(
                        label: e.key,
                        value: e.value,
                        accent: accent,
                      ),
                    )
                    .toList(),
              ),
            ),
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
                      (e) => AnswerRow(
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

class _CardHeader extends StatelessWidget {
  final Color accent;
  final String date;
  final String time;
  final int index;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _CardHeader({
    required this.accent,
    required this.date,
    required this.time,
    required this.index,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 12, 14),
      decoration: BoxDecoration(
        color: accent.withOpacity(0.06),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Row(
        children: [
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
                  date,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                    color: Color(0xFF1A1A2E),
                  ),
                ),
                Text(
                  time,
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                ),
              ],
            ),
          ),
          IconBtn(
            icon: Icons.edit_rounded,
            color: const Color(0xFF4A90D9),
            tooltip: 'Edit',
            onTap: onEdit,
          ),
          const SizedBox(width: 6),
          IconBtn(
            icon: Icons.delete_rounded,
            color: const Color(0xFFE84855),
            tooltip: 'Delete',
            onTap: onDelete,
          ),
        ],
      ),
    );
  }
}
