import 'package:flutter/material.dart';
import 'package:grpc/grpc.dart';
import 'gen/app.pbgrpc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Gym Member App')),
        body: Center(
          child: ElevatedButton(
            onPressed: () async {
              final channel = ClientChannel(
                'grpc-api.moora.web.id',
                port: 50051,
                options: const ChannelOptions(
                  credentials: ChannelCredentials.secure(),
                ),
              );

              // 2. Buat Stub Client gRPC
              final client = MemberServiceClient(channel);

              try {
                // 3. Tembak fungsinya mirip seperti di SvelteKit kemarin!
                final responseStream = client.getMembers(Empty());
                final responses = await responseStream.toList();
                print(
                  '🚀 Berhasil mendapat data member dari gRPC Backend: ${responses.toString()}',
                );
              } catch (e) {
                print('❌ Gagal terkoneksi ke gRPC: $e');
              } finally {
                await channel.shutdown();
              }
            },
            child: const Text('Tarik Data Member via gRPC'),
          ),
        ),
      ),
    );
  }
}
