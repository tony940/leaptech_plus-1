import 'package:flutter/material.dart';
import 'package:leaptech_plus/core/themes/app_colors.dart';
import 'package:leaptech_plus/core/widgets/app_button.dart';

class DeleteConfirmationDialog extends StatelessWidget {
  final String employeeName;
  final VoidCallback onConfirm;

  const DeleteConfirmationDialog({
    super.key,
    required this.employeeName,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        'Delete Employee',
        style: TextStyle(color: Colors.black87),
      ),
      content: Text(
        'Are you sure you want to delete $employeeName?',
        style: const TextStyle(color: Colors.black54),
      ),
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text(
            'Cancel',
            style: TextStyle(color: Colors.black54),
          ),
        ),
        AppButton(
          buttonText: 'Delete',
          onPressed: () {
            onConfirm();
            Navigator.of(context).pop();
          },
          backgroundColor: Colors.red,
        ),
      ],
    );
  }
}
