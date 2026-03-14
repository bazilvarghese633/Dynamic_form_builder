import 'package:dynamic_form_builder/core/color.dart';
import 'package:flutter/material.dart';

InputDecoration inputDecoration(String? label) => InputDecoration(
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
    borderSide: const BorderSide(color: kAccent, width: 2),
  ),
);

DateTime? toDateTime(dynamic raw) {
  if (raw == null) return null;
  if (raw is DateTime) return raw;
  if (raw.runtimeType.toString().contains('Timestamp')) {
    return (raw as dynamic).toDate() as DateTime;
  }
  if (raw is String && raw.isNotEmpty) {
    final direct = DateTime.tryParse(raw);
    if (direct != null) return direct;
    final match = RegExp(r'(\d{4})-(\d{2})-(\d{2})').firstMatch(raw);
    if (match != null) {
      final y = int.tryParse(match.group(1)!);
      final m = int.tryParse(match.group(2)!);
      final d = int.tryParse(match.group(3)!);
      if (y != null && m != null && d != null) return DateTime(y, m, d);
    }
  }
  return null;
}

String formatDate(DateTime dt) {
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
