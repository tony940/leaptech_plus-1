import 'package:flutter/material.dart';
import 'package:leaptech_plus/features/login/data/models/user_model.dart';

class EmployeeListTile extends StatelessWidget {
  final UserModel employee;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const EmployeeListTile({
    super.key,
    required this.employee,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.grey[200],
          backgroundImage: employee.imageUrl != null
              ? NetworkImage(employee.imageUrl!) as ImageProvider<Object>?
              : null,
          child: employee.imageUrl == null
              ? Text(employee.fullName.substring(0, 1))
              : null,
        ),
        title: Text(
          employee.fullName,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        subtitle: Text(
          '${employee.title} - ${employee.type}',
          style: const TextStyle(color: Colors.grey),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.blue),
              onPressed: onEdit,
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}
