import '../grpc_service.dart';
import '../gen/app.pbgrpc.dart';

class OfferingDataService {
  final _grpc = GrpcService();

  Future<List<Offering>> fetchOfferings() async {
    try {
      final response = await _grpc.offeringClient.getOfferings(Empty());
      return response.offerings;
    } catch (e) {
      print('❌ Gagal ambil offerings: $e');
      rethrow;
    }
  }
}
