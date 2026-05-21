import 'package:grpc/grpc.dart';
import 'gen/app.pbgrpc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GrpcService {
  static final GrpcService _instance = GrpcService._internal();
  factory GrpcService() => _instance;
  GrpcService._internal();

  late ClientChannel _channel;
  String? _token;

  void init() {
    _channel = ClientChannel(
      'grpc-mobile.moora.web.id',
      // '192.168.1.10',
      port: 50051,
      options: const ChannelOptions(credentials: ChannelCredentials.insecure()),
    );
  }

  void setSessionIdToMetadata(String token) {
    _token = token;
  }

  Future<void> setToken(String token) async {
    _token = token;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('session_id', token);
  }

  Future<void> clearToken() async {
    _token = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('session_id');
  }

  String? get token => _token;

  List<ClientInterceptor> get _interceptors =>
      _token != null ? [GrpcAuthInterceptor(_token!)] : [];

  AuthServiceClient get authClient =>
      AuthServiceClient(_channel, interceptors: _interceptors);
  MemberServiceClient get memberClient =>
      MemberServiceClient(_channel, interceptors: _interceptors);
  TenantServiceClient get tenantClient =>
      TenantServiceClient(_channel, interceptors: _interceptors);
  PlanServiceClient get planClient =>
      PlanServiceClient(_channel, interceptors: _interceptors);
  TransactionServiceClient get transactionClient =>
      TransactionServiceClient(_channel, interceptors: _interceptors);
  OfferingServiceClient get offeringClient =>
      OfferingServiceClient(_channel, interceptors: _interceptors);

  Future<UserProfile> fetchProfileWithToken(String sessionId) async {
    // Buat client sementara khusus yang ditempeli token pengecekan ini
    final temporaryClient = AuthServiceClient(
      _channel,
      interceptors: [GrpcAuthInterceptor(sessionId)],
    );

    // Tembak RPC GetProfile untuk memastikan sesi Redis di backend masih hidup/berlaku
    return await temporaryClient.getProfile(Empty());
  }

  void close() => _channel.shutdown();
}

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
    final newOptions = options.mergedWith(
      CallOptions(metadata: {'authorization': 'Bearer $token'}),
    );
    return invoker(method, requests, newOptions);
  }
}
