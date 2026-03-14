import 'package:dynamic_form_builder/features/presentation/bloc/form_bloc.dart';
import 'package:dynamic_form_builder/features/presentation/bloc/form_event.dart';
import 'package:flutter/material.dart';

void showDeleteDialog(BuildContext context, FormBloc bloc, String docId) {
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
            bloc.add(DeleteSubmissionEvent(docId));
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
