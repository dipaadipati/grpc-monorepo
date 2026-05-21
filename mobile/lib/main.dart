import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'grpc_service.dart';
import 'pages/main_navigation_holder.dart';
import 'gen/app.pbgrpc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 🚀 1. Inisialisasi awal channel gRPC global WAJIB di paling atas!
  // Ini akan membuat variabel '_channel' aman terinisialisasi di memori.
  GrpcService().init();

  // 🚀 2. Inisialisasi Storage Hive
  await Hive.initFlutter();
  final authBox = await Hive.openBox('authBox');

  final String? savedSessionId = authBox.get('session_id');

  bool isSessionValid = false;
  UserProfile? userProfile;

  if (savedSessionId != null && savedSessionId.isNotEmpty) {
    try {
      // Sekarang ini dipanggil tanpa takut memicu LateInitializationError lagi!
      userProfile = await GrpcService().fetchProfileWithToken(savedSessionId);
      isSessionValid = true;

      GrpcService().setSessionIdToMetadata(savedSessionId);
    } catch (e) {
      debugPrint('Sesi expired atau Redis telah dihapus: $e');
      await authBox.delete('session_id');
    }
  }

  runApp(
    MyApp(
      initialScreen: isSessionValid && userProfile != null
          ? MainNavigationHolder(profile: userProfile)
          : const GymLoginPage(),
    ),
  );
}

class MyApp extends StatelessWidget {
  final Widget initialScreen;
  const MyApp({super.key, required this.initialScreen});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.purple),
        useMaterial3: true,
      ),
      home: initialScreen,
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

      await grpc.setToken(res.token);

      final profile = await grpc.authClient.getProfile(Empty());

      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => MainNavigationHolder(profile: profile),
        ),
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
