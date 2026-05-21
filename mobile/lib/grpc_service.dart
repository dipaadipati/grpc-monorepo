import 'package:grpc/grpc.dart';
import 'gen/app.pbgrpc.dart';

class GrpcService {
  static final GrpcService _instance = GrpcService._internal();
  factory GrpcService() => _instance;
  GrpcService._internal();

  late ClientChannel _channel;
  String? _token;

  void init() {
    _channel = ClientChannel(
      'grpc-mobile.moora.web.id',
      port: 50051,
      options: const ChannelOptions(credentials: ChannelCredentials.insecure()),
    );
  }

  void setToken(String token) => _token = token;
  void clearToken() => _token = null;
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
