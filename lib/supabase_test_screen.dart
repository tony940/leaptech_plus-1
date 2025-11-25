import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:leaptech_plus/core/services/supabase_service.dart';

class SupabaseTestScreen extends StatelessWidget {
  final SupabaseService supabaseService = SupabaseService();

  SupabaseTestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Supabase Test'),
        centerTitle: true,
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            await supabaseService.getAllMembers();
          },
          child: const Text('Run Supabase Method'),
        ),
      ),
    );
  }
}
