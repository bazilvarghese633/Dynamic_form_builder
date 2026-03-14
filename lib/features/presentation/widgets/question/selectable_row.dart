import 'package:dynamic_form_builder/core/color.dart';
import 'package:flutter/material.dart';

class SelectableRow extends StatelessWidget {
  final String label;
  final bool selected;
  final bool isCheckbox;
  final bool small;

  const SelectableRow({
    super.key,
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
        color: selected ? kAccent.withOpacity(0.08) : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: selected ? kAccent : Colors.grey.shade200,
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
              color: selected ? kAccent : Colors.grey.shade400,
              size: small ? 18 : 20,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: small ? 13 : 14,
                color: selected ? kDark : Colors.black87,
                fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
