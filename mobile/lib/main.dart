import 'package:flutter/material.dart';
import 'grpc_service.dart';
import 'services/transaction_service.dart';
import 'gen/app.pbgrpc.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  GrpcService().init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.purple),
        useMaterial3: true,
      ),
      home: const GymLoginPage(),
    );
  }
}

class GymLoginPage extends StatefulWidget {
  const GymLoginPage({super.key});
  @override
  State<GymLoginPage> createState() => _GymLoginPageState();
}

class _GymLoginPageState extends State<GymLoginPage> {
  final _emailCtrl = TextEditingController(text: 'admin@gym.com');
  final _passwordCtrl = TextEditingController(text: 'admin123');
  bool _isProcessing = false;

  Future<void> _handleLogin() async {
    setState(() => _isProcessing = true);
    final grpc = GrpcService();

    try {
      final req = LoginRequest()
        ..email = _emailCtrl.text.trim()
        ..password = _passwordCtrl.text;

      final res = await grpc.authClient.login(req);

      grpc.setToken(res.token);

      final profile = await grpc.authClient.getProfile(Empty());

      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => AdminDashboardPage(profile: profile)),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Sesi Gagal: $e')));
    } finally {
      setState(() => _isProcessing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(Icons.fitness_center, size: 80, color: Colors.purple),
            const SizedBox(height: 16),
            const Text(
              'GYM PRO MOBILE',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 32),
            TextField(
              controller: _emailCtrl,
              decoration: const InputDecoration(
                labelText: 'Email Admin',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordCtrl,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _isProcessing ? null : _handleLogin,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(16),
                backgroundColor: Colors.purple,
              ),
              child: _isProcessing
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text(
                      'MASUK',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

// 👑 HALAMAN UTAMA DASHBOARD SETELAH AUTHENTICATED
class AdminDashboardPage extends StatelessWidget {
  final UserProfile profile;
  const AdminDashboardPage({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    final txService = TransactionDataService();

    return Scaffold(
      appBar: AppBar(
        title: Text(profile.tenantName),
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
              child: Text('Error data keuangan: ${snapshot.error}'),
            );
          }

          final summary = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Welcome, ${profile.name}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Card(
                  color: Color(0xFFECFDF5),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        const Text(
                          'TOTAL REVENUE CABANG',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFECFDF5),
                          ),
                        ),
                        Text(
                          'Rp ${summary.totalRevenue}',
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFFECFDF5),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            'Member Aktif\n${summary.totalMembers}',
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            'Transaksi\n${summary.totalTransactions}',
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
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
}
