import 'package:flutter/material.dart';
import '../grpc_service.dart';
import '../services/transaction_service.dart';
import '../gen/app.pbgrpc.dart';
import '../main.dart';

class DashboardPage extends StatelessWidget {
  final UserProfile profile;
  const DashboardPage({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    final txService = TransactionDataService();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          profile.tenantName,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.purple[50],
        actions: [
          IconButton(
            icon: const Icon(Icons.power_settings_new, color: Colors.red),
            onPressed: () {
              GrpcService().clearToken();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const GymLoginPage()),
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<FinanceSummary>(
        future: txService.fetchFinanceSummary(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Text('Error data dashboard: ${snapshot.error}'),
            );
          }

          final summary = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Welcome back, ${profile.name}',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Card(
                  color: const Color(0xFFECFDF5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      children: [
                        const Text(
                          'TOTAL REVENUE CABANG',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF059669),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Rp ${summary.totalRevenue}',
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF059669),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    _buildStatCard(
                      'Total Member',
                      '${summary.totalMembers}',
                      Colors.blue,
                    ),
                    _buildStatCard(
                      'Aktif',
                      '${summary.activeMemberships}',
                      Colors.orange,
                    ),
                    _buildStatCard(
                      'Transaksi',
                      '${summary.totalTransactions}',
                      Colors.purple,
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatCard(String title, String value, Color color) {
    return Expanded(
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
          child: Column(
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
