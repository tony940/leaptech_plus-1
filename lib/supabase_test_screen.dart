import 'package:flutter/material.dart';
import 'package:leaptech_plus/core/services/supabase_service.dart';

class SupabaseTestScreen extends StatefulWidget {
  const SupabaseTestScreen({super.key});

  @override
  State<SupabaseTestScreen> createState() => _SupabaseTestScreenState();
}

class _SupabaseTestScreenState extends State<SupabaseTestScreen> {
  final SupabaseService supabaseService = SupabaseService();

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
            var res = await supabaseService.getAllMembers();
            print(res);
          },
          child: const Text('Run Supabase Method'),
        ),
      ),
    );
  }
}
