import '../grpc_service.dart';
import '../gen/app.pbgrpc.dart';

class TransactionDataService {
  final _grpc = GrpcService();

  Future<FinanceSummary> fetchFinanceSummary() async {
    return await _grpc.transactionClient.getFinanceSummary(
      GetTransactionsRequest(),
    );
  }

  Future<List<Transaction>> fetchTransactions({
    String? start,
    String? end,
  }) async {
    final request = GetTransactionsRequest();
    if (start != null) request.startDate = start;
    if (end != null) request.endDate = end;

    final response = await _grpc.transactionClient.getTransactions(request);
    return response.transactions;
  }

  Future<Transaction> createInvoice({
    required int memberId,
    int? planId,
    int? offeringId,
    required String paymentMethod,
  }) async {
    final request = CreateTransactionRequest()
      ..memberId = memberId
      ..method = paymentMethod; // "CASH" or "QRIS"

    if (planId != null) request.planId = planId;
    if (offeringId != null) request.offeringId = offeringId;

    return await _grpc.transactionClient.createTransaction(request);
  }
}
