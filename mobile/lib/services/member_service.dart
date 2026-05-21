import '../grpc_service.dart';
import '../gen/app.pbgrpc.dart';

class MemberDataService {
  final _grpc = GrpcService();

  Future<List<UserProfile>> fetchAllMembers() async {
    try {
      final response = await _grpc.memberClient.getMembers(Empty());
      return response.members;
    } catch (e) {
      print('❌ Gagal ambil members: $e');
      rethrow;
    }
  }

  Future<String> registerNewMember(
    String name,
    String email,
    String password,
  ) async {
    final request = RegisterMemberRequest()
      ..name = name
      ..email = email
      ..password = password;

    final res = await _grpc.memberClient.registerMember(request);
    return res.memberId;
  }

  Future<void> removeMember(int id) async {
    final request = GetMemberProfileRequest()..memberId = id;
    await _grpc.memberClient.deleteMember(request);
  }
}
