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

  Future<void> deleteOffering(int offeringId) async {
    final request = GetOfferingRequest()..offeringId = offeringId;

    await _grpc.offeringClient.deleteOffering(request);
  }
}
