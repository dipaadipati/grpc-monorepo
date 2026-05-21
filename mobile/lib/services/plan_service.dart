import '../grpc_service.dart';
import '../gen/app.pbgrpc.dart';
import 'package:fixnum/fixnum.dart';

class PlanDataService {
  final _grpc = GrpcService();

  Future<List<Plan>> fetchPlans() async {
    try {
      final response = await _grpc.planClient.getPlans(Empty());
      return response.plans;
    } catch (e) {
      print('❌ Gagal ambil plans: $e');
      rethrow;
    }
  }

  Future<void> addNewPlan(
    String name,
    int price,
    int durationInDays,
    int tenantId,
  ) async {
    final request = AddPlanRequest()
      ..name = name
      ..price = Int64.parseInt(price.toString())
      ..duration = durationInDays
      ..tenantId = tenantId;

    await _grpc.planClient.addPlan(request);
  }
}
