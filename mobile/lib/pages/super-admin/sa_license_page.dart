import 'package:flutter/material.dart';
import '../../gen/app.pbgrpc.dart';

class SALicensePage extends StatelessWidget {
  final UserProfile profile;
  const SALicensePage({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Global Billing & License',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.gavel_rounded, size: 64, color: Colors.amber),
            SizedBox(height: 16),
            Text(
              'Pengaturan Masa Aktif SaaS',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
