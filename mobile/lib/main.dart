import 'package:flutter/material.dart';
import 'package:grpc/grpc.dart';
import 'gen/app.pbgrpc.dart'; // File proto kamu

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.blue),
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
  // Controller untuk menangkap input teks di LDPlayer
  final _emailController = TextEditingController(text: 'admin@gym.com');
  final _passwordController = TextEditingController(text: 'admin123');

  String? _savedToken; // Tempat menyimpan token dari Redis VPS
  late ClientChannel _channel;

  @override
  void initState() {
    super.initState();
    // Inisialisasi Jalur Pipa gRPC murni ke Subdomain Mobile
    _channel = ClientChannel(
      '127.0.0.1',
      port: 50051,
      options: const ChannelOptions(
        credentials:
            ChannelCredentials.insecure(), // Jalur lancar reverse proxy
      ),
    );
  }

  @override
  void dispose() {
    _channel.shutdown();
    super.dispose();
  }

  // 🔑 FUNGSI 1: Eksekusi Login gRPC Murni
  Future<void> _executeLogin() async {
    final authClient = AuthServiceClient(_channel);

    try {
      final request = LoginRequest()
        ..email = _emailController.text.trim()
        ..password = _passwordController.text;

      print('🔑 Mencoba Login ke gRPC Backend...');
      final response = await authClient.login(request);

      setState(() {
        _savedToken = response.token; // Ambil token string dari AuthResponse
      });

      print(
        '✅ Login Sukses! Token Redis disimpan: ${_savedToken!.substring(0, 8)}...',
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Login Berhasil! Token disimpan.')),
      );
    } catch (e) {
      print('❌ Gagal Login: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Login Gagal: $e')));
    }
  }

  // 🔑 FUNGSI 2: Ambil Profil Menggunakan Kelas Interceptor Kustom (Anti-Gagal)
  Future<void> _fetchProfileWithToken() async {
    if (_savedToken == null) {
      print('⚠️ Kamu belum login! Token tidak ditemukan.');
      return;
    }

    // ✅ Panggil kelas interceptor kustom kita dan masukkan token hasil login
    final authInterceptor = GrpcAuthInterceptor(_savedToken!);

    // Pasang ke dalam client gRPC
    final protectedAuthClient = AuthServiceClient(
      _channel,
      interceptors: [
        authInterceptor,
      ], // Kompiler sekarang tersenyum bahagia karena tipenya cocok!
    );

    try {
      print('🔍 Menembak rpc GetProfile dengan Token Autentikasi...');
      final profile = await protectedAuthClient.getProfile(Empty());

      print('🚀 [SUCCESS] Profil Berhasil Ditarik dari VPS!');
      print('Nama User : ${profile.name}');
      print('Email     : ${profile.email}');

      if (!mounted) return;
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('Welcome back, ${profile.name}!'),
          content: Text('Gym: ${profile.tenantName}\nRole: ${profile.role}'),
        ),
      );
    } catch (e) {
      print('❌ Gagal mengambil profile: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Gym Mobile - gRPC Client')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email Admin'),
            ),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Password'),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _executeLogin,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              child: const Text(
                '1. Jalankan Login (Dapatkan Token)',
                style: TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _savedToken != null ? _fetchProfileWithToken : null,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
              child: const Text(
                '2. Tarik Profil (Pakai Interceptor Token)',
                style: TextStyle(color: Colors.white),
              ),
            ),
            if (_savedToken != null) ...[
              const SizedBox(height: 16),
              Text(
                'Status: Terautentikasi (Token Aktif)',
                style: TextStyle(
                  color: Colors.green[700],
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// 🔑 KELAS PENYELAMAT: Mengikuti struktur kontrak abstract class ClientInterceptor murni
class GrpcAuthInterceptor extends ClientInterceptor {
  final String token;

  GrpcAuthInterceptor(this.token);

  @override
  ResponseFuture<R> interceptUnary<Q, R>(
    ClientMethod<Q, R> method,
    Q request,
    CallOptions options,
    ClientUnaryInvoker<Q, R> invoker,
  ) {
    // Suntikkan token ke metadata sebelum request dilempar ke VPS
    final newOptions = options.mergedWith(
      CallOptions(metadata: {'authorization': 'Bearer $token'}),
    );
    return invoker(method, request, newOptions);
  }

  @override
  ResponseStream<R> interceptStreaming<Q, R>(
    ClientMethod<Q, R> method,
    Stream<Q> requests,
    CallOptions options,
    ClientStreamingInvoker<Q, R> invoker,
  ) {
    // Suntikkan juga untuk rpc tipe Stream (seperti GetMembers kamu!)
    final newOptions = options.mergedWith(
      CallOptions(metadata: {'authorization': 'Bearer $token'}),
    );
    return invoker(method, requests, newOptions);
  }
}
