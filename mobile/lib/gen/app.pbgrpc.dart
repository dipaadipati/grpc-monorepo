// This is a generated file - do not edit.
//
// Generated from app.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:async' as $async;
import 'dart:core' as $core;

import 'package:grpc/service_api.dart' as $grpc;
import 'package:protobuf/protobuf.dart' as $pb;

import 'app.pb.dart' as $0;

export 'app.pb.dart';

@$pb.GrpcServiceName('app.AuthService')
class AuthServiceClient extends $grpc.Client {
  /// The hostname for this service.
  static const $core.String defaultHost = '';

  /// OAuth scopes needed for the client.
  static const $core.List<$core.String> oauthScopes = [
    '',
  ];

  AuthServiceClient(super.channel, {super.options, super.interceptors});

  $grpc.ResponseFuture<$0.AuthResponse> login(
    $0.LoginRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$login, request, options: options);
  }

  $grpc.ResponseFuture<$0.UserProfile> getProfile(
    $0.Empty request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getProfile, request, options: options);
  }

  $grpc.ResponseFuture<$0.LogoutResponse> logout(
    $0.Empty request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$logout, request, options: options);
  }

  // method descriptors

  static final _$login = $grpc.ClientMethod<$0.LoginRequest, $0.AuthResponse>(
      '/app.AuthService/Login',
      ($0.LoginRequest value) => value.writeToBuffer(),
      $0.AuthResponse.fromBuffer);
  static final _$getProfile = $grpc.ClientMethod<$0.Empty, $0.UserProfile>(
      '/app.AuthService/GetProfile',
      ($0.Empty value) => value.writeToBuffer(),
      $0.UserProfile.fromBuffer);
  static final _$logout = $grpc.ClientMethod<$0.Empty, $0.LogoutResponse>(
      '/app.AuthService/Logout',
      ($0.Empty value) => value.writeToBuffer(),
      $0.LogoutResponse.fromBuffer);
}

@$pb.GrpcServiceName('app.AuthService')
abstract class AuthServiceBase extends $grpc.Service {
  $core.String get $name => 'app.AuthService';

  AuthServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.LoginRequest, $0.AuthResponse>(
        'Login',
        login_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.LoginRequest.fromBuffer(value),
        ($0.AuthResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.Empty, $0.UserProfile>(
        'GetProfile',
        getProfile_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.Empty.fromBuffer(value),
        ($0.UserProfile value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.Empty, $0.LogoutResponse>(
        'Logout',
        logout_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.Empty.fromBuffer(value),
        ($0.LogoutResponse value) => value.writeToBuffer()));
  }

  $async.Future<$0.AuthResponse> login_Pre(
      $grpc.ServiceCall $call, $async.Future<$0.LoginRequest> $request) async {
    return login($call, await $request);
  }

  $async.Future<$0.AuthResponse> login(
      $grpc.ServiceCall call, $0.LoginRequest request);

  $async.Future<$0.UserProfile> getProfile_Pre(
      $grpc.ServiceCall $call, $async.Future<$0.Empty> $request) async {
    return getProfile($call, await $request);
  }

  $async.Future<$0.UserProfile> getProfile(
      $grpc.ServiceCall call, $0.Empty request);

  $async.Future<$0.LogoutResponse> logout_Pre(
      $grpc.ServiceCall $call, $async.Future<$0.Empty> $request) async {
    return logout($call, await $request);
  }

  $async.Future<$0.LogoutResponse> logout(
      $grpc.ServiceCall call, $0.Empty request);
}

@$pb.GrpcServiceName('app.MemberService')
class MemberServiceClient extends $grpc.Client {
  /// The hostname for this service.
  static const $core.String defaultHost = '';

  /// OAuth scopes needed for the client.
  static const $core.List<$core.String> oauthScopes = [
    '',
  ];

  MemberServiceClient(super.channel, {super.options, super.interceptors});

  $grpc.ResponseFuture<$0.MemberResponse> registerMember(
    $0.RegisterMemberRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$registerMember, request, options: options);
  }

  $grpc.ResponseFuture<$0.MemberResponse> updateMember(
    $0.UpdateMemberRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$updateMember, request, options: options);
  }

  $grpc.ResponseFuture<$0.Empty> deleteMember(
    $0.GetMemberProfileRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$deleteMember, request, options: options);
  }

  $grpc.ResponseStream<$0.UserProfile> getMembers(
    $0.Empty request, {
    $grpc.CallOptions? options,
  }) {
    return $createStreamingCall(
        _$getMembers, $async.Stream.fromIterable([request]),
        options: options);
  }

  $grpc.ResponseFuture<$0.UserProfile> getMemberProfile(
    $0.GetMemberProfileRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getMemberProfile, request, options: options);
  }

  // method descriptors

  static final _$registerMember =
      $grpc.ClientMethod<$0.RegisterMemberRequest, $0.MemberResponse>(
          '/app.MemberService/RegisterMember',
          ($0.RegisterMemberRequest value) => value.writeToBuffer(),
          $0.MemberResponse.fromBuffer);
  static final _$updateMember =
      $grpc.ClientMethod<$0.UpdateMemberRequest, $0.MemberResponse>(
          '/app.MemberService/UpdateMember',
          ($0.UpdateMemberRequest value) => value.writeToBuffer(),
          $0.MemberResponse.fromBuffer);
  static final _$deleteMember =
      $grpc.ClientMethod<$0.GetMemberProfileRequest, $0.Empty>(
          '/app.MemberService/DeleteMember',
          ($0.GetMemberProfileRequest value) => value.writeToBuffer(),
          $0.Empty.fromBuffer);
  static final _$getMembers = $grpc.ClientMethod<$0.Empty, $0.UserProfile>(
      '/app.MemberService/GetMembers',
      ($0.Empty value) => value.writeToBuffer(),
      $0.UserProfile.fromBuffer);
  static final _$getMemberProfile =
      $grpc.ClientMethod<$0.GetMemberProfileRequest, $0.UserProfile>(
          '/app.MemberService/GetMemberProfile',
          ($0.GetMemberProfileRequest value) => value.writeToBuffer(),
          $0.UserProfile.fromBuffer);
}

@$pb.GrpcServiceName('app.MemberService')
abstract class MemberServiceBase extends $grpc.Service {
  $core.String get $name => 'app.MemberService';

  MemberServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.RegisterMemberRequest, $0.MemberResponse>(
        'RegisterMember',
        registerMember_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.RegisterMemberRequest.fromBuffer(value),
        ($0.MemberResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.UpdateMemberRequest, $0.MemberResponse>(
        'UpdateMember',
        updateMember_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.UpdateMemberRequest.fromBuffer(value),
        ($0.MemberResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.GetMemberProfileRequest, $0.Empty>(
        'DeleteMember',
        deleteMember_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.GetMemberProfileRequest.fromBuffer(value),
        ($0.Empty value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.Empty, $0.UserProfile>(
        'GetMembers',
        getMembers_Pre,
        false,
        true,
        ($core.List<$core.int> value) => $0.Empty.fromBuffer(value),
        ($0.UserProfile value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.GetMemberProfileRequest, $0.UserProfile>(
        'GetMemberProfile',
        getMemberProfile_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.GetMemberProfileRequest.fromBuffer(value),
        ($0.UserProfile value) => value.writeToBuffer()));
  }

  $async.Future<$0.MemberResponse> registerMember_Pre($grpc.ServiceCall $call,
      $async.Future<$0.RegisterMemberRequest> $request) async {
    return registerMember($call, await $request);
  }

  $async.Future<$0.MemberResponse> registerMember(
      $grpc.ServiceCall call, $0.RegisterMemberRequest request);

  $async.Future<$0.MemberResponse> updateMember_Pre($grpc.ServiceCall $call,
      $async.Future<$0.UpdateMemberRequest> $request) async {
    return updateMember($call, await $request);
  }

  $async.Future<$0.MemberResponse> updateMember(
      $grpc.ServiceCall call, $0.UpdateMemberRequest request);

  $async.Future<$0.Empty> deleteMember_Pre($grpc.ServiceCall $call,
      $async.Future<$0.GetMemberProfileRequest> $request) async {
    return deleteMember($call, await $request);
  }

  $async.Future<$0.Empty> deleteMember(
      $grpc.ServiceCall call, $0.GetMemberProfileRequest request);

  $async.Stream<$0.UserProfile> getMembers_Pre(
      $grpc.ServiceCall $call, $async.Future<$0.Empty> $request) async* {
    yield* getMembers($call, await $request);
  }

  $async.Stream<$0.UserProfile> getMembers(
      $grpc.ServiceCall call, $0.Empty request);

  $async.Future<$0.UserProfile> getMemberProfile_Pre($grpc.ServiceCall $call,
      $async.Future<$0.GetMemberProfileRequest> $request) async {
    return getMemberProfile($call, await $request);
  }

  $async.Future<$0.UserProfile> getMemberProfile(
      $grpc.ServiceCall call, $0.GetMemberProfileRequest request);
}

@$pb.GrpcServiceName('app.TenantService')
class TenantServiceClient extends $grpc.Client {
  /// The hostname for this service.
  static const $core.String defaultHost = '';

  /// OAuth scopes needed for the client.
  static const $core.List<$core.String> oauthScopes = [
    '',
  ];

  TenantServiceClient(super.channel, {super.options, super.interceptors});

  $grpc.ResponseFuture<$0.TenantResponse> addTenant(
    $0.AddTenantRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$addTenant, request, options: options);
  }

  $grpc.ResponseFuture<$0.TenantResponse> updateTenant(
    $0.UpdateTenantRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$updateTenant, request, options: options);
  }

  $grpc.ResponseFuture<$0.Empty> deleteTenant(
    $0.GetTenantRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$deleteTenant, request, options: options);
  }

  $grpc.ResponseStream<$0.Tenant> getTenants(
    $0.Empty request, {
    $grpc.CallOptions? options,
  }) {
    return $createStreamingCall(
        _$getTenants, $async.Stream.fromIterable([request]),
        options: options);
  }

  $grpc.ResponseFuture<$0.Tenant> getTenant(
    $0.GetTenantRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getTenant, request, options: options);
  }

  // method descriptors

  static final _$addTenant =
      $grpc.ClientMethod<$0.AddTenantRequest, $0.TenantResponse>(
          '/app.TenantService/AddTenant',
          ($0.AddTenantRequest value) => value.writeToBuffer(),
          $0.TenantResponse.fromBuffer);
  static final _$updateTenant =
      $grpc.ClientMethod<$0.UpdateTenantRequest, $0.TenantResponse>(
          '/app.TenantService/UpdateTenant',
          ($0.UpdateTenantRequest value) => value.writeToBuffer(),
          $0.TenantResponse.fromBuffer);
  static final _$deleteTenant =
      $grpc.ClientMethod<$0.GetTenantRequest, $0.Empty>(
          '/app.TenantService/DeleteTenant',
          ($0.GetTenantRequest value) => value.writeToBuffer(),
          $0.Empty.fromBuffer);
  static final _$getTenants = $grpc.ClientMethod<$0.Empty, $0.Tenant>(
      '/app.TenantService/GetTenants',
      ($0.Empty value) => value.writeToBuffer(),
      $0.Tenant.fromBuffer);
  static final _$getTenant = $grpc.ClientMethod<$0.GetTenantRequest, $0.Tenant>(
      '/app.TenantService/GetTenant',
      ($0.GetTenantRequest value) => value.writeToBuffer(),
      $0.Tenant.fromBuffer);
}

@$pb.GrpcServiceName('app.TenantService')
abstract class TenantServiceBase extends $grpc.Service {
  $core.String get $name => 'app.TenantService';

  TenantServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.AddTenantRequest, $0.TenantResponse>(
        'AddTenant',
        addTenant_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.AddTenantRequest.fromBuffer(value),
        ($0.TenantResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.UpdateTenantRequest, $0.TenantResponse>(
        'UpdateTenant',
        updateTenant_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.UpdateTenantRequest.fromBuffer(value),
        ($0.TenantResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.GetTenantRequest, $0.Empty>(
        'DeleteTenant',
        deleteTenant_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.GetTenantRequest.fromBuffer(value),
        ($0.Empty value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.Empty, $0.Tenant>(
        'GetTenants',
        getTenants_Pre,
        false,
        true,
        ($core.List<$core.int> value) => $0.Empty.fromBuffer(value),
        ($0.Tenant value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.GetTenantRequest, $0.Tenant>(
        'GetTenant',
        getTenant_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.GetTenantRequest.fromBuffer(value),
        ($0.Tenant value) => value.writeToBuffer()));
  }

  $async.Future<$0.TenantResponse> addTenant_Pre($grpc.ServiceCall $call,
      $async.Future<$0.AddTenantRequest> $request) async {
    return addTenant($call, await $request);
  }

  $async.Future<$0.TenantResponse> addTenant(
      $grpc.ServiceCall call, $0.AddTenantRequest request);

  $async.Future<$0.TenantResponse> updateTenant_Pre($grpc.ServiceCall $call,
      $async.Future<$0.UpdateTenantRequest> $request) async {
    return updateTenant($call, await $request);
  }

  $async.Future<$0.TenantResponse> updateTenant(
      $grpc.ServiceCall call, $0.UpdateTenantRequest request);

  $async.Future<$0.Empty> deleteTenant_Pre($grpc.ServiceCall $call,
      $async.Future<$0.GetTenantRequest> $request) async {
    return deleteTenant($call, await $request);
  }

  $async.Future<$0.Empty> deleteTenant(
      $grpc.ServiceCall call, $0.GetTenantRequest request);

  $async.Stream<$0.Tenant> getTenants_Pre(
      $grpc.ServiceCall $call, $async.Future<$0.Empty> $request) async* {
    yield* getTenants($call, await $request);
  }

  $async.Stream<$0.Tenant> getTenants($grpc.ServiceCall call, $0.Empty request);

  $async.Future<$0.Tenant> getTenant_Pre($grpc.ServiceCall $call,
      $async.Future<$0.GetTenantRequest> $request) async {
    return getTenant($call, await $request);
  }

  $async.Future<$0.Tenant> getTenant(
      $grpc.ServiceCall call, $0.GetTenantRequest request);
}

@$pb.GrpcServiceName('app.PlanService')
class PlanServiceClient extends $grpc.Client {
  /// The hostname for this service.
  static const $core.String defaultHost = '';

  /// OAuth scopes needed for the client.
  static const $core.List<$core.String> oauthScopes = [
    '',
  ];

  PlanServiceClient(super.channel, {super.options, super.interceptors});

  $grpc.ResponseFuture<$0.PlanResponse> addPlan(
    $0.AddPlanRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$addPlan, request, options: options);
  }

  $grpc.ResponseFuture<$0.PlanResponse> updatePlan(
    $0.UpdatePlanRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$updatePlan, request, options: options);
  }

  $grpc.ResponseFuture<$0.Empty> deletePlan(
    $0.GetPlanRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$deletePlan, request, options: options);
  }

  $grpc.ResponseStream<$0.Plan> getPlans(
    $0.Empty request, {
    $grpc.CallOptions? options,
  }) {
    return $createStreamingCall(
        _$getPlans, $async.Stream.fromIterable([request]),
        options: options);
  }

  $grpc.ResponseFuture<$0.Plan> getPlan(
    $0.GetPlanRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getPlan, request, options: options);
  }

  // method descriptors

  static final _$addPlan =
      $grpc.ClientMethod<$0.AddPlanRequest, $0.PlanResponse>(
          '/app.PlanService/AddPlan',
          ($0.AddPlanRequest value) => value.writeToBuffer(),
          $0.PlanResponse.fromBuffer);
  static final _$updatePlan =
      $grpc.ClientMethod<$0.UpdatePlanRequest, $0.PlanResponse>(
          '/app.PlanService/UpdatePlan',
          ($0.UpdatePlanRequest value) => value.writeToBuffer(),
          $0.PlanResponse.fromBuffer);
  static final _$deletePlan = $grpc.ClientMethod<$0.GetPlanRequest, $0.Empty>(
      '/app.PlanService/DeletePlan',
      ($0.GetPlanRequest value) => value.writeToBuffer(),
      $0.Empty.fromBuffer);
  static final _$getPlans = $grpc.ClientMethod<$0.Empty, $0.Plan>(
      '/app.PlanService/GetPlans',
      ($0.Empty value) => value.writeToBuffer(),
      $0.Plan.fromBuffer);
  static final _$getPlan = $grpc.ClientMethod<$0.GetPlanRequest, $0.Plan>(
      '/app.PlanService/GetPlan',
      ($0.GetPlanRequest value) => value.writeToBuffer(),
      $0.Plan.fromBuffer);
}

@$pb.GrpcServiceName('app.PlanService')
abstract class PlanServiceBase extends $grpc.Service {
  $core.String get $name => 'app.PlanService';

  PlanServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.AddPlanRequest, $0.PlanResponse>(
        'AddPlan',
        addPlan_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.AddPlanRequest.fromBuffer(value),
        ($0.PlanResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.UpdatePlanRequest, $0.PlanResponse>(
        'UpdatePlan',
        updatePlan_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.UpdatePlanRequest.fromBuffer(value),
        ($0.PlanResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.GetPlanRequest, $0.Empty>(
        'DeletePlan',
        deletePlan_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.GetPlanRequest.fromBuffer(value),
        ($0.Empty value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.Empty, $0.Plan>(
        'GetPlans',
        getPlans_Pre,
        false,
        true,
        ($core.List<$core.int> value) => $0.Empty.fromBuffer(value),
        ($0.Plan value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.GetPlanRequest, $0.Plan>(
        'GetPlan',
        getPlan_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.GetPlanRequest.fromBuffer(value),
        ($0.Plan value) => value.writeToBuffer()));
  }

  $async.Future<$0.PlanResponse> addPlan_Pre($grpc.ServiceCall $call,
      $async.Future<$0.AddPlanRequest> $request) async {
    return addPlan($call, await $request);
  }

  $async.Future<$0.PlanResponse> addPlan(
      $grpc.ServiceCall call, $0.AddPlanRequest request);

  $async.Future<$0.PlanResponse> updatePlan_Pre($grpc.ServiceCall $call,
      $async.Future<$0.UpdatePlanRequest> $request) async {
    return updatePlan($call, await $request);
  }

  $async.Future<$0.PlanResponse> updatePlan(
      $grpc.ServiceCall call, $0.UpdatePlanRequest request);

  $async.Future<$0.Empty> deletePlan_Pre($grpc.ServiceCall $call,
      $async.Future<$0.GetPlanRequest> $request) async {
    return deletePlan($call, await $request);
  }

  $async.Future<$0.Empty> deletePlan(
      $grpc.ServiceCall call, $0.GetPlanRequest request);

  $async.Stream<$0.Plan> getPlans_Pre(
      $grpc.ServiceCall $call, $async.Future<$0.Empty> $request) async* {
    yield* getPlans($call, await $request);
  }

  $async.Stream<$0.Plan> getPlans($grpc.ServiceCall call, $0.Empty request);

  $async.Future<$0.Plan> getPlan_Pre($grpc.ServiceCall $call,
      $async.Future<$0.GetPlanRequest> $request) async {
    return getPlan($call, await $request);
  }

  $async.Future<$0.Plan> getPlan(
      $grpc.ServiceCall call, $0.GetPlanRequest request);
}

@$pb.GrpcServiceName('app.TransactionService')
class TransactionServiceClient extends $grpc.Client {
  /// The hostname for this service.
  static const $core.String defaultHost = '';

  /// OAuth scopes needed for the client.
  static const $core.List<$core.String> oauthScopes = [
    '',
  ];

  TransactionServiceClient(super.channel, {super.options, super.interceptors});

  $grpc.ResponseFuture<$0.Transaction> createTransaction(
    $0.CreateTransactionRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$createTransaction, request, options: options);
  }

  $grpc.ResponseStream<$0.Transaction> getTransactions(
    $0.GetTransactionsRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createStreamingCall(
        _$getTransactions, $async.Stream.fromIterable([request]),
        options: options);
  }

  $grpc.ResponseFuture<$0.Transaction> checkTransactionStatus(
    $0.GetTransactionRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$checkTransactionStatus, request,
        options: options);
  }

  $grpc.ResponseStream<$0.Transaction> getMemberTransactions(
    $0.GetMemberProfileRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createStreamingCall(
        _$getMemberTransactions, $async.Stream.fromIterable([request]),
        options: options);
  }

  $grpc.ResponseFuture<$0.FinanceSummary> getFinanceSummary(
    $0.GetTransactionsRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getFinanceSummary, request, options: options);
  }

  // method descriptors

  static final _$createTransaction =
      $grpc.ClientMethod<$0.CreateTransactionRequest, $0.Transaction>(
          '/app.TransactionService/CreateTransaction',
          ($0.CreateTransactionRequest value) => value.writeToBuffer(),
          $0.Transaction.fromBuffer);
  static final _$getTransactions =
      $grpc.ClientMethod<$0.GetTransactionsRequest, $0.Transaction>(
          '/app.TransactionService/GetTransactions',
          ($0.GetTransactionsRequest value) => value.writeToBuffer(),
          $0.Transaction.fromBuffer);
  static final _$checkTransactionStatus =
      $grpc.ClientMethod<$0.GetTransactionRequest, $0.Transaction>(
          '/app.TransactionService/CheckTransactionStatus',
          ($0.GetTransactionRequest value) => value.writeToBuffer(),
          $0.Transaction.fromBuffer);
  static final _$getMemberTransactions =
      $grpc.ClientMethod<$0.GetMemberProfileRequest, $0.Transaction>(
          '/app.TransactionService/GetMemberTransactions',
          ($0.GetMemberProfileRequest value) => value.writeToBuffer(),
          $0.Transaction.fromBuffer);
  static final _$getFinanceSummary =
      $grpc.ClientMethod<$0.GetTransactionsRequest, $0.FinanceSummary>(
          '/app.TransactionService/GetFinanceSummary',
          ($0.GetTransactionsRequest value) => value.writeToBuffer(),
          $0.FinanceSummary.fromBuffer);
}

@$pb.GrpcServiceName('app.TransactionService')
abstract class TransactionServiceBase extends $grpc.Service {
  $core.String get $name => 'app.TransactionService';

  TransactionServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.CreateTransactionRequest, $0.Transaction>(
        'CreateTransaction',
        createTransaction_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.CreateTransactionRequest.fromBuffer(value),
        ($0.Transaction value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.GetTransactionsRequest, $0.Transaction>(
        'GetTransactions',
        getTransactions_Pre,
        false,
        true,
        ($core.List<$core.int> value) =>
            $0.GetTransactionsRequest.fromBuffer(value),
        ($0.Transaction value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.GetTransactionRequest, $0.Transaction>(
        'CheckTransactionStatus',
        checkTransactionStatus_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.GetTransactionRequest.fromBuffer(value),
        ($0.Transaction value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.GetMemberProfileRequest, $0.Transaction>(
        'GetMemberTransactions',
        getMemberTransactions_Pre,
        false,
        true,
        ($core.List<$core.int> value) =>
            $0.GetMemberProfileRequest.fromBuffer(value),
        ($0.Transaction value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.GetTransactionsRequest, $0.FinanceSummary>(
            'GetFinanceSummary',
            getFinanceSummary_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.GetTransactionsRequest.fromBuffer(value),
            ($0.FinanceSummary value) => value.writeToBuffer()));
  }

  $async.Future<$0.Transaction> createTransaction_Pre($grpc.ServiceCall $call,
      $async.Future<$0.CreateTransactionRequest> $request) async {
    return createTransaction($call, await $request);
  }

  $async.Future<$0.Transaction> createTransaction(
      $grpc.ServiceCall call, $0.CreateTransactionRequest request);

  $async.Stream<$0.Transaction> getTransactions_Pre($grpc.ServiceCall $call,
      $async.Future<$0.GetTransactionsRequest> $request) async* {
    yield* getTransactions($call, await $request);
  }

  $async.Stream<$0.Transaction> getTransactions(
      $grpc.ServiceCall call, $0.GetTransactionsRequest request);

  $async.Future<$0.Transaction> checkTransactionStatus_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.GetTransactionRequest> $request) async {
    return checkTransactionStatus($call, await $request);
  }

  $async.Future<$0.Transaction> checkTransactionStatus(
      $grpc.ServiceCall call, $0.GetTransactionRequest request);

  $async.Stream<$0.Transaction> getMemberTransactions_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.GetMemberProfileRequest> $request) async* {
    yield* getMemberTransactions($call, await $request);
  }

  $async.Stream<$0.Transaction> getMemberTransactions(
      $grpc.ServiceCall call, $0.GetMemberProfileRequest request);

  $async.Future<$0.FinanceSummary> getFinanceSummary_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.GetTransactionsRequest> $request) async {
    return getFinanceSummary($call, await $request);
  }

  $async.Future<$0.FinanceSummary> getFinanceSummary(
      $grpc.ServiceCall call, $0.GetTransactionsRequest request);
}

@$pb.GrpcServiceName('app.OfferingService')
class OfferingServiceClient extends $grpc.Client {
  /// The hostname for this service.
  static const $core.String defaultHost = '';

  /// OAuth scopes needed for the client.
  static const $core.List<$core.String> oauthScopes = [
    '',
  ];

  OfferingServiceClient(super.channel, {super.options, super.interceptors});

  $grpc.ResponseFuture<$0.OfferingResponse> addOffering(
    $0.AddOfferingRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$addOffering, request, options: options);
  }

  $grpc.ResponseFuture<$0.OfferingResponse> updateOffering(
    $0.UpdateOfferingRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$updateOffering, request, options: options);
  }

  $grpc.ResponseFuture<$0.Empty> deleteOffering(
    $0.GetOfferingRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$deleteOffering, request, options: options);
  }

  $grpc.ResponseStream<$0.Offering> getOfferings(
    $0.Empty request, {
    $grpc.CallOptions? options,
  }) {
    return $createStreamingCall(
        _$getOfferings, $async.Stream.fromIterable([request]),
        options: options);
  }

  $grpc.ResponseFuture<$0.Offering> getOffering(
    $0.GetOfferingRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getOffering, request, options: options);
  }

  // method descriptors

  static final _$addOffering =
      $grpc.ClientMethod<$0.AddOfferingRequest, $0.OfferingResponse>(
          '/app.OfferingService/AddOffering',
          ($0.AddOfferingRequest value) => value.writeToBuffer(),
          $0.OfferingResponse.fromBuffer);
  static final _$updateOffering =
      $grpc.ClientMethod<$0.UpdateOfferingRequest, $0.OfferingResponse>(
          '/app.OfferingService/UpdateOffering',
          ($0.UpdateOfferingRequest value) => value.writeToBuffer(),
          $0.OfferingResponse.fromBuffer);
  static final _$deleteOffering =
      $grpc.ClientMethod<$0.GetOfferingRequest, $0.Empty>(
          '/app.OfferingService/DeleteOffering',
          ($0.GetOfferingRequest value) => value.writeToBuffer(),
          $0.Empty.fromBuffer);
  static final _$getOfferings = $grpc.ClientMethod<$0.Empty, $0.Offering>(
      '/app.OfferingService/GetOfferings',
      ($0.Empty value) => value.writeToBuffer(),
      $0.Offering.fromBuffer);
  static final _$getOffering =
      $grpc.ClientMethod<$0.GetOfferingRequest, $0.Offering>(
          '/app.OfferingService/GetOffering',
          ($0.GetOfferingRequest value) => value.writeToBuffer(),
          $0.Offering.fromBuffer);
}

@$pb.GrpcServiceName('app.OfferingService')
abstract class OfferingServiceBase extends $grpc.Service {
  $core.String get $name => 'app.OfferingService';

  OfferingServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.AddOfferingRequest, $0.OfferingResponse>(
        'AddOffering',
        addOffering_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.AddOfferingRequest.fromBuffer(value),
        ($0.OfferingResponse value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.UpdateOfferingRequest, $0.OfferingResponse>(
            'UpdateOffering',
            updateOffering_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.UpdateOfferingRequest.fromBuffer(value),
            ($0.OfferingResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.GetOfferingRequest, $0.Empty>(
        'DeleteOffering',
        deleteOffering_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.GetOfferingRequest.fromBuffer(value),
        ($0.Empty value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.Empty, $0.Offering>(
        'GetOfferings',
        getOfferings_Pre,
        false,
        true,
        ($core.List<$core.int> value) => $0.Empty.fromBuffer(value),
        ($0.Offering value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.GetOfferingRequest, $0.Offering>(
        'GetOffering',
        getOffering_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.GetOfferingRequest.fromBuffer(value),
        ($0.Offering value) => value.writeToBuffer()));
  }

  $async.Future<$0.OfferingResponse> addOffering_Pre($grpc.ServiceCall $call,
      $async.Future<$0.AddOfferingRequest> $request) async {
    return addOffering($call, await $request);
  }

  $async.Future<$0.OfferingResponse> addOffering(
      $grpc.ServiceCall call, $0.AddOfferingRequest request);

  $async.Future<$0.OfferingResponse> updateOffering_Pre($grpc.ServiceCall $call,
      $async.Future<$0.UpdateOfferingRequest> $request) async {
    return updateOffering($call, await $request);
  }

  $async.Future<$0.OfferingResponse> updateOffering(
      $grpc.ServiceCall call, $0.UpdateOfferingRequest request);

  $async.Future<$0.Empty> deleteOffering_Pre($grpc.ServiceCall $call,
      $async.Future<$0.GetOfferingRequest> $request) async {
    return deleteOffering($call, await $request);
  }

  $async.Future<$0.Empty> deleteOffering(
      $grpc.ServiceCall call, $0.GetOfferingRequest request);

  $async.Stream<$0.Offering> getOfferings_Pre(
      $grpc.ServiceCall $call, $async.Future<$0.Empty> $request) async* {
    yield* getOfferings($call, await $request);
  }

  $async.Stream<$0.Offering> getOfferings(
      $grpc.ServiceCall call, $0.Empty request);

  $async.Future<$0.Offering> getOffering_Pre($grpc.ServiceCall $call,
      $async.Future<$0.GetOfferingRequest> $request) async {
    return getOffering($call, await $request);
  }

  $async.Future<$0.Offering> getOffering(
      $grpc.ServiceCall call, $0.GetOfferingRequest request);
}

@$pb.GrpcServiceName('app.AttendanceService')
class AttendanceServiceClient extends $grpc.Client {
  /// The hostname for this service.
  static const $core.String defaultHost = '';

  /// OAuth scopes needed for the client.
  static const $core.List<$core.String> oauthScopes = [
    '',
  ];

  AttendanceServiceClient(super.channel, {super.options, super.interceptors});

  $grpc.ResponseFuture<$0.CheckInResponse> checkIn(
    $0.CheckInRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$checkIn, request, options: options);
  }

  $grpc.ResponseFuture<$0.AttendanceHistory> getAttendanceHistory(
    $0.GetAttendanceHistoryRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getAttendanceHistory, request, options: options);
  }

  // method descriptors

  static final _$checkIn =
      $grpc.ClientMethod<$0.CheckInRequest, $0.CheckInResponse>(
          '/app.AttendanceService/CheckIn',
          ($0.CheckInRequest value) => value.writeToBuffer(),
          $0.CheckInResponse.fromBuffer);
  static final _$getAttendanceHistory =
      $grpc.ClientMethod<$0.GetAttendanceHistoryRequest, $0.AttendanceHistory>(
          '/app.AttendanceService/GetAttendanceHistory',
          ($0.GetAttendanceHistoryRequest value) => value.writeToBuffer(),
          $0.AttendanceHistory.fromBuffer);
}

@$pb.GrpcServiceName('app.AttendanceService')
abstract class AttendanceServiceBase extends $grpc.Service {
  $core.String get $name => 'app.AttendanceService';

  AttendanceServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.CheckInRequest, $0.CheckInResponse>(
        'CheckIn',
        checkIn_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.CheckInRequest.fromBuffer(value),
        ($0.CheckInResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.GetAttendanceHistoryRequest,
            $0.AttendanceHistory>(
        'GetAttendanceHistory',
        getAttendanceHistory_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.GetAttendanceHistoryRequest.fromBuffer(value),
        ($0.AttendanceHistory value) => value.writeToBuffer()));
  }

  $async.Future<$0.CheckInResponse> checkIn_Pre($grpc.ServiceCall $call,
      $async.Future<$0.CheckInRequest> $request) async {
    return checkIn($call, await $request);
  }

  $async.Future<$0.CheckInResponse> checkIn(
      $grpc.ServiceCall call, $0.CheckInRequest request);

  $async.Future<$0.AttendanceHistory> getAttendanceHistory_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.GetAttendanceHistoryRequest> $request) async {
    return getAttendanceHistory($call, await $request);
  }

  $async.Future<$0.AttendanceHistory> getAttendanceHistory(
      $grpc.ServiceCall call, $0.GetAttendanceHistoryRequest request);
}
