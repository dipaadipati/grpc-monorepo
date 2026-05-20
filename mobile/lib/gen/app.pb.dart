// This is a generated file - do not edit.
//
// Generated from app.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;
import 'package:protobuf/well_known_types/google/protobuf/timestamp.pb.dart'
    as $1;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

class Empty extends $pb.GeneratedMessage {
  factory Empty() => create();

  Empty._();

  factory Empty.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Empty.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Empty',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'app'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Empty clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Empty copyWith(void Function(Empty) updates) =>
      super.copyWith((message) => updates(message as Empty)) as Empty;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Empty create() => Empty._();
  @$core.override
  Empty createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Empty getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Empty>(create);
  static Empty? _defaultInstance;
}

class LoginRequest extends $pb.GeneratedMessage {
  factory LoginRequest({
    $core.String? email,
    $core.String? password,
  }) {
    final result = create();
    if (email != null) result.email = email;
    if (password != null) result.password = password;
    return result;
  }

  LoginRequest._();

  factory LoginRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory LoginRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'LoginRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'app'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'email')
    ..aOS(2, _omitFieldNames ? '' : 'password')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LoginRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LoginRequest copyWith(void Function(LoginRequest) updates) =>
      super.copyWith((message) => updates(message as LoginRequest))
          as LoginRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static LoginRequest create() => LoginRequest._();
  @$core.override
  LoginRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static LoginRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<LoginRequest>(create);
  static LoginRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get email => $_getSZ(0);
  @$pb.TagNumber(1)
  set email($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasEmail() => $_has(0);
  @$pb.TagNumber(1)
  void clearEmail() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get password => $_getSZ(1);
  @$pb.TagNumber(2)
  set password($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPassword() => $_has(1);
  @$pb.TagNumber(2)
  void clearPassword() => $_clearField(2);
}

class UserProfile extends $pb.GeneratedMessage {
  factory UserProfile({
    $core.int? id,
    $core.String? email,
    $core.String? name,
    $core.String? role,
    $core.int? tenantId,
    $core.String? tenantName,
    Membership? membership,
    $1.Timestamp? createdAt,
    $core.String? midtransClientKey,
    $core.bool? tenantIsActive,
  }) {
    final result = create();
    if (id != null) result.id = id;
    if (email != null) result.email = email;
    if (name != null) result.name = name;
    if (role != null) result.role = role;
    if (tenantId != null) result.tenantId = tenantId;
    if (tenantName != null) result.tenantName = tenantName;
    if (membership != null) result.membership = membership;
    if (createdAt != null) result.createdAt = createdAt;
    if (midtransClientKey != null) result.midtransClientKey = midtransClientKey;
    if (tenantIsActive != null) result.tenantIsActive = tenantIsActive;
    return result;
  }

  UserProfile._();

  factory UserProfile.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory UserProfile.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UserProfile',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'app'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'email')
    ..aOS(3, _omitFieldNames ? '' : 'name')
    ..aOS(4, _omitFieldNames ? '' : 'role')
    ..aI(5, _omitFieldNames ? '' : 'tenantId', protoName: 'tenantId')
    ..aOS(6, _omitFieldNames ? '' : 'tenantName', protoName: 'tenantName')
    ..aOM<Membership>(7, _omitFieldNames ? '' : 'membership',
        subBuilder: Membership.create)
    ..aOM<$1.Timestamp>(8, _omitFieldNames ? '' : 'createdAt',
        protoName: 'createdAt', subBuilder: $1.Timestamp.create)
    ..aOS(9, _omitFieldNames ? '' : 'midtransClientKey',
        protoName: 'midtransClientKey')
    ..aOB(10, _omitFieldNames ? '' : 'tenantIsActive',
        protoName: 'tenantIsActive')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UserProfile clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UserProfile copyWith(void Function(UserProfile) updates) =>
      super.copyWith((message) => updates(message as UserProfile))
          as UserProfile;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UserProfile create() => UserProfile._();
  @$core.override
  UserProfile createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static UserProfile getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UserProfile>(create);
  static UserProfile? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get id => $_getIZ(0);
  @$pb.TagNumber(1)
  set id($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get email => $_getSZ(1);
  @$pb.TagNumber(2)
  set email($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasEmail() => $_has(1);
  @$pb.TagNumber(2)
  void clearEmail() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get name => $_getSZ(2);
  @$pb.TagNumber(3)
  set name($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasName() => $_has(2);
  @$pb.TagNumber(3)
  void clearName() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get role => $_getSZ(3);
  @$pb.TagNumber(4)
  set role($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasRole() => $_has(3);
  @$pb.TagNumber(4)
  void clearRole() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.int get tenantId => $_getIZ(4);
  @$pb.TagNumber(5)
  set tenantId($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasTenantId() => $_has(4);
  @$pb.TagNumber(5)
  void clearTenantId() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get tenantName => $_getSZ(5);
  @$pb.TagNumber(6)
  set tenantName($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasTenantName() => $_has(5);
  @$pb.TagNumber(6)
  void clearTenantName() => $_clearField(6);

  @$pb.TagNumber(7)
  Membership get membership => $_getN(6);
  @$pb.TagNumber(7)
  set membership(Membership value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasMembership() => $_has(6);
  @$pb.TagNumber(7)
  void clearMembership() => $_clearField(7);
  @$pb.TagNumber(7)
  Membership ensureMembership() => $_ensure(6);

  @$pb.TagNumber(8)
  $1.Timestamp get createdAt => $_getN(7);
  @$pb.TagNumber(8)
  set createdAt($1.Timestamp value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasCreatedAt() => $_has(7);
  @$pb.TagNumber(8)
  void clearCreatedAt() => $_clearField(8);
  @$pb.TagNumber(8)
  $1.Timestamp ensureCreatedAt() => $_ensure(7);

  @$pb.TagNumber(9)
  $core.String get midtransClientKey => $_getSZ(8);
  @$pb.TagNumber(9)
  set midtransClientKey($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasMidtransClientKey() => $_has(8);
  @$pb.TagNumber(9)
  void clearMidtransClientKey() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.bool get tenantIsActive => $_getBF(9);
  @$pb.TagNumber(10)
  set tenantIsActive($core.bool value) => $_setBool(9, value);
  @$pb.TagNumber(10)
  $core.bool hasTenantIsActive() => $_has(9);
  @$pb.TagNumber(10)
  void clearTenantIsActive() => $_clearField(10);
}

class AuthResponse extends $pb.GeneratedMessage {
  factory AuthResponse({
    $core.String? token,
  }) {
    final result = create();
    if (token != null) result.token = token;
    return result;
  }

  AuthResponse._();

  factory AuthResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AuthResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AuthResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'app'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'token')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AuthResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AuthResponse copyWith(void Function(AuthResponse) updates) =>
      super.copyWith((message) => updates(message as AuthResponse))
          as AuthResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AuthResponse create() => AuthResponse._();
  @$core.override
  AuthResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AuthResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AuthResponse>(create);
  static AuthResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get token => $_getSZ(0);
  @$pb.TagNumber(1)
  set token($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasToken() => $_has(0);
  @$pb.TagNumber(1)
  void clearToken() => $_clearField(1);
}

class LogoutResponse extends $pb.GeneratedMessage {
  factory LogoutResponse({
    $core.bool? success,
  }) {
    final result = create();
    if (success != null) result.success = success;
    return result;
  }

  LogoutResponse._();

  factory LogoutResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory LogoutResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'LogoutResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'app'),
      createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'success')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LogoutResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LogoutResponse copyWith(void Function(LogoutResponse) updates) =>
      super.copyWith((message) => updates(message as LogoutResponse))
          as LogoutResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static LogoutResponse create() => LogoutResponse._();
  @$core.override
  LogoutResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static LogoutResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<LogoutResponse>(create);
  static LogoutResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get success => $_getBF(0);
  @$pb.TagNumber(1)
  set success($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSuccess() => $_has(0);
  @$pb.TagNumber(1)
  void clearSuccess() => $_clearField(1);
}

class RegisterMemberRequest extends $pb.GeneratedMessage {
  factory RegisterMemberRequest({
    $core.String? email,
    $core.String? name,
    $core.String? password,
  }) {
    final result = create();
    if (email != null) result.email = email;
    if (name != null) result.name = name;
    if (password != null) result.password = password;
    return result;
  }

  RegisterMemberRequest._();

  factory RegisterMemberRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RegisterMemberRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RegisterMemberRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'app'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'email')
    ..aOS(2, _omitFieldNames ? '' : 'name')
    ..aOS(3, _omitFieldNames ? '' : 'password')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RegisterMemberRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RegisterMemberRequest copyWith(
          void Function(RegisterMemberRequest) updates) =>
      super.copyWith((message) => updates(message as RegisterMemberRequest))
          as RegisterMemberRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RegisterMemberRequest create() => RegisterMemberRequest._();
  @$core.override
  RegisterMemberRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RegisterMemberRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RegisterMemberRequest>(create);
  static RegisterMemberRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get email => $_getSZ(0);
  @$pb.TagNumber(1)
  set email($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasEmail() => $_has(0);
  @$pb.TagNumber(1)
  void clearEmail() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get name => $_getSZ(1);
  @$pb.TagNumber(2)
  set name($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasName() => $_has(1);
  @$pb.TagNumber(2)
  void clearName() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get password => $_getSZ(2);
  @$pb.TagNumber(3)
  set password($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasPassword() => $_has(2);
  @$pb.TagNumber(3)
  void clearPassword() => $_clearField(3);
}

class UpdateMemberRequest extends $pb.GeneratedMessage {
  factory UpdateMemberRequest({
    $core.int? id,
    $core.String? email,
    $core.String? name,
    $core.String? password,
  }) {
    final result = create();
    if (id != null) result.id = id;
    if (email != null) result.email = email;
    if (name != null) result.name = name;
    if (password != null) result.password = password;
    return result;
  }

  UpdateMemberRequest._();

  factory UpdateMemberRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory UpdateMemberRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UpdateMemberRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'app'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'email')
    ..aOS(3, _omitFieldNames ? '' : 'name')
    ..aOS(4, _omitFieldNames ? '' : 'password')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateMemberRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateMemberRequest copyWith(void Function(UpdateMemberRequest) updates) =>
      super.copyWith((message) => updates(message as UpdateMemberRequest))
          as UpdateMemberRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UpdateMemberRequest create() => UpdateMemberRequest._();
  @$core.override
  UpdateMemberRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static UpdateMemberRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UpdateMemberRequest>(create);
  static UpdateMemberRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get id => $_getIZ(0);
  @$pb.TagNumber(1)
  set id($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get email => $_getSZ(1);
  @$pb.TagNumber(2)
  set email($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasEmail() => $_has(1);
  @$pb.TagNumber(2)
  void clearEmail() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get name => $_getSZ(2);
  @$pb.TagNumber(3)
  set name($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasName() => $_has(2);
  @$pb.TagNumber(3)
  void clearName() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get password => $_getSZ(3);
  @$pb.TagNumber(4)
  set password($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasPassword() => $_has(3);
  @$pb.TagNumber(4)
  void clearPassword() => $_clearField(4);
}

class MemberResponse extends $pb.GeneratedMessage {
  factory MemberResponse({
    $core.String? memberId,
  }) {
    final result = create();
    if (memberId != null) result.memberId = memberId;
    return result;
  }

  MemberResponse._();

  factory MemberResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory MemberResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'MemberResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'app'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'memberId', protoName: 'memberId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MemberResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MemberResponse copyWith(void Function(MemberResponse) updates) =>
      super.copyWith((message) => updates(message as MemberResponse))
          as MemberResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static MemberResponse create() => MemberResponse._();
  @$core.override
  MemberResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static MemberResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<MemberResponse>(create);
  static MemberResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get memberId => $_getSZ(0);
  @$pb.TagNumber(1)
  set memberId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasMemberId() => $_has(0);
  @$pb.TagNumber(1)
  void clearMemberId() => $_clearField(1);
}

class GetMemberProfileRequest extends $pb.GeneratedMessage {
  factory GetMemberProfileRequest({
    $core.int? memberId,
  }) {
    final result = create();
    if (memberId != null) result.memberId = memberId;
    return result;
  }

  GetMemberProfileRequest._();

  factory GetMemberProfileRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetMemberProfileRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetMemberProfileRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'app'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'memberId', protoName: 'memberId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetMemberProfileRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetMemberProfileRequest copyWith(
          void Function(GetMemberProfileRequest) updates) =>
      super.copyWith((message) => updates(message as GetMemberProfileRequest))
          as GetMemberProfileRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetMemberProfileRequest create() => GetMemberProfileRequest._();
  @$core.override
  GetMemberProfileRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetMemberProfileRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetMemberProfileRequest>(create);
  static GetMemberProfileRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get memberId => $_getIZ(0);
  @$pb.TagNumber(1)
  set memberId($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasMemberId() => $_has(0);
  @$pb.TagNumber(1)
  void clearMemberId() => $_clearField(1);
}

class MembershipStatus extends $pb.GeneratedMessage {
  factory MembershipStatus({
    $core.bool? isActive,
    $core.String? expiryDate,
  }) {
    final result = create();
    if (isActive != null) result.isActive = isActive;
    if (expiryDate != null) result.expiryDate = expiryDate;
    return result;
  }

  MembershipStatus._();

  factory MembershipStatus.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory MembershipStatus.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'MembershipStatus',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'app'),
      createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'isActive', protoName: 'isActive')
    ..aOS(2, _omitFieldNames ? '' : 'expiryDate', protoName: 'expiryDate')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MembershipStatus clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MembershipStatus copyWith(void Function(MembershipStatus) updates) =>
      super.copyWith((message) => updates(message as MembershipStatus))
          as MembershipStatus;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static MembershipStatus create() => MembershipStatus._();
  @$core.override
  MembershipStatus createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static MembershipStatus getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<MembershipStatus>(create);
  static MembershipStatus? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get isActive => $_getBF(0);
  @$pb.TagNumber(1)
  set isActive($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasIsActive() => $_has(0);
  @$pb.TagNumber(1)
  void clearIsActive() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get expiryDate => $_getSZ(1);
  @$pb.TagNumber(2)
  set expiryDate($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasExpiryDate() => $_has(1);
  @$pb.TagNumber(2)
  void clearExpiryDate() => $_clearField(2);
}

class AddTenantRequest extends $pb.GeneratedMessage {
  factory AddTenantRequest({
    $core.String? name,
    $core.String? slug,
    $core.String? address,
    $core.bool? isActive,
  }) {
    final result = create();
    if (name != null) result.name = name;
    if (slug != null) result.slug = slug;
    if (address != null) result.address = address;
    if (isActive != null) result.isActive = isActive;
    return result;
  }

  AddTenantRequest._();

  factory AddTenantRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AddTenantRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AddTenantRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'app'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'name')
    ..aOS(2, _omitFieldNames ? '' : 'slug')
    ..aOS(3, _omitFieldNames ? '' : 'address')
    ..aOB(4, _omitFieldNames ? '' : 'isActive', protoName: 'isActive')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AddTenantRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AddTenantRequest copyWith(void Function(AddTenantRequest) updates) =>
      super.copyWith((message) => updates(message as AddTenantRequest))
          as AddTenantRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AddTenantRequest create() => AddTenantRequest._();
  @$core.override
  AddTenantRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AddTenantRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AddTenantRequest>(create);
  static AddTenantRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get name => $_getSZ(0);
  @$pb.TagNumber(1)
  set name($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasName() => $_has(0);
  @$pb.TagNumber(1)
  void clearName() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get slug => $_getSZ(1);
  @$pb.TagNumber(2)
  set slug($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasSlug() => $_has(1);
  @$pb.TagNumber(2)
  void clearSlug() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get address => $_getSZ(2);
  @$pb.TagNumber(3)
  set address($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasAddress() => $_has(2);
  @$pb.TagNumber(3)
  void clearAddress() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.bool get isActive => $_getBF(3);
  @$pb.TagNumber(4)
  set isActive($core.bool value) => $_setBool(3, value);
  @$pb.TagNumber(4)
  $core.bool hasIsActive() => $_has(3);
  @$pb.TagNumber(4)
  void clearIsActive() => $_clearField(4);
}

class UpdateTenantRequest extends $pb.GeneratedMessage {
  factory UpdateTenantRequest({
    $core.int? id,
    $core.String? name,
    $core.String? slug,
    $core.String? address,
    $core.bool? isActive,
  }) {
    final result = create();
    if (id != null) result.id = id;
    if (name != null) result.name = name;
    if (slug != null) result.slug = slug;
    if (address != null) result.address = address;
    if (isActive != null) result.isActive = isActive;
    return result;
  }

  UpdateTenantRequest._();

  factory UpdateTenantRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory UpdateTenantRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UpdateTenantRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'app'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'name')
    ..aOS(3, _omitFieldNames ? '' : 'slug')
    ..aOS(4, _omitFieldNames ? '' : 'address')
    ..aOB(5, _omitFieldNames ? '' : 'isActive', protoName: 'isActive')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateTenantRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateTenantRequest copyWith(void Function(UpdateTenantRequest) updates) =>
      super.copyWith((message) => updates(message as UpdateTenantRequest))
          as UpdateTenantRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UpdateTenantRequest create() => UpdateTenantRequest._();
  @$core.override
  UpdateTenantRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static UpdateTenantRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UpdateTenantRequest>(create);
  static UpdateTenantRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get id => $_getIZ(0);
  @$pb.TagNumber(1)
  set id($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get name => $_getSZ(1);
  @$pb.TagNumber(2)
  set name($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasName() => $_has(1);
  @$pb.TagNumber(2)
  void clearName() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get slug => $_getSZ(2);
  @$pb.TagNumber(3)
  set slug($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasSlug() => $_has(2);
  @$pb.TagNumber(3)
  void clearSlug() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get address => $_getSZ(3);
  @$pb.TagNumber(4)
  set address($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasAddress() => $_has(3);
  @$pb.TagNumber(4)
  void clearAddress() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.bool get isActive => $_getBF(4);
  @$pb.TagNumber(5)
  set isActive($core.bool value) => $_setBool(4, value);
  @$pb.TagNumber(5)
  $core.bool hasIsActive() => $_has(4);
  @$pb.TagNumber(5)
  void clearIsActive() => $_clearField(5);
}

class TenantResponse extends $pb.GeneratedMessage {
  factory TenantResponse({
    $core.String? tenantId,
  }) {
    final result = create();
    if (tenantId != null) result.tenantId = tenantId;
    return result;
  }

  TenantResponse._();

  factory TenantResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory TenantResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'TenantResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'app'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'tenantId', protoName: 'tenantId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TenantResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TenantResponse copyWith(void Function(TenantResponse) updates) =>
      super.copyWith((message) => updates(message as TenantResponse))
          as TenantResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static TenantResponse create() => TenantResponse._();
  @$core.override
  TenantResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static TenantResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<TenantResponse>(create);
  static TenantResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get tenantId => $_getSZ(0);
  @$pb.TagNumber(1)
  set tenantId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTenantId() => $_has(0);
  @$pb.TagNumber(1)
  void clearTenantId() => $_clearField(1);
}

class GetTenantRequest extends $pb.GeneratedMessage {
  factory GetTenantRequest({
    $core.int? tenantId,
  }) {
    final result = create();
    if (tenantId != null) result.tenantId = tenantId;
    return result;
  }

  GetTenantRequest._();

  factory GetTenantRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetTenantRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetTenantRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'app'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'tenantId', protoName: 'tenantId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetTenantRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetTenantRequest copyWith(void Function(GetTenantRequest) updates) =>
      super.copyWith((message) => updates(message as GetTenantRequest))
          as GetTenantRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetTenantRequest create() => GetTenantRequest._();
  @$core.override
  GetTenantRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetTenantRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetTenantRequest>(create);
  static GetTenantRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get tenantId => $_getIZ(0);
  @$pb.TagNumber(1)
  set tenantId($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTenantId() => $_has(0);
  @$pb.TagNumber(1)
  void clearTenantId() => $_clearField(1);
}

class Tenant extends $pb.GeneratedMessage {
  factory Tenant({
    $core.int? id,
    $core.String? name,
    $core.String? slug,
    $core.String? address,
    $core.bool? isActive,
    $1.Timestamp? createdAt,
  }) {
    final result = create();
    if (id != null) result.id = id;
    if (name != null) result.name = name;
    if (slug != null) result.slug = slug;
    if (address != null) result.address = address;
    if (isActive != null) result.isActive = isActive;
    if (createdAt != null) result.createdAt = createdAt;
    return result;
  }

  Tenant._();

  factory Tenant.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Tenant.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Tenant',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'app'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'name')
    ..aOS(3, _omitFieldNames ? '' : 'slug')
    ..aOS(4, _omitFieldNames ? '' : 'address')
    ..aOB(5, _omitFieldNames ? '' : 'isActive', protoName: 'isActive')
    ..aOM<$1.Timestamp>(6, _omitFieldNames ? '' : 'createdAt',
        protoName: 'createdAt', subBuilder: $1.Timestamp.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Tenant clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Tenant copyWith(void Function(Tenant) updates) =>
      super.copyWith((message) => updates(message as Tenant)) as Tenant;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Tenant create() => Tenant._();
  @$core.override
  Tenant createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Tenant getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Tenant>(create);
  static Tenant? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get id => $_getIZ(0);
  @$pb.TagNumber(1)
  set id($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get name => $_getSZ(1);
  @$pb.TagNumber(2)
  set name($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasName() => $_has(1);
  @$pb.TagNumber(2)
  void clearName() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get slug => $_getSZ(2);
  @$pb.TagNumber(3)
  set slug($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasSlug() => $_has(2);
  @$pb.TagNumber(3)
  void clearSlug() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get address => $_getSZ(3);
  @$pb.TagNumber(4)
  set address($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasAddress() => $_has(3);
  @$pb.TagNumber(4)
  void clearAddress() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.bool get isActive => $_getBF(4);
  @$pb.TagNumber(5)
  set isActive($core.bool value) => $_setBool(4, value);
  @$pb.TagNumber(5)
  $core.bool hasIsActive() => $_has(4);
  @$pb.TagNumber(5)
  void clearIsActive() => $_clearField(5);

  @$pb.TagNumber(6)
  $1.Timestamp get createdAt => $_getN(5);
  @$pb.TagNumber(6)
  set createdAt($1.Timestamp value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasCreatedAt() => $_has(5);
  @$pb.TagNumber(6)
  void clearCreatedAt() => $_clearField(6);
  @$pb.TagNumber(6)
  $1.Timestamp ensureCreatedAt() => $_ensure(5);
}

class AddPlanRequest extends $pb.GeneratedMessage {
  factory AddPlanRequest({
    $core.String? name,
    $fixnum.Int64? price,
    $core.int? duration,
    $core.int? tenantId,
  }) {
    final result = create();
    if (name != null) result.name = name;
    if (price != null) result.price = price;
    if (duration != null) result.duration = duration;
    if (tenantId != null) result.tenantId = tenantId;
    return result;
  }

  AddPlanRequest._();

  factory AddPlanRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AddPlanRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AddPlanRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'app'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'name')
    ..aInt64(2, _omitFieldNames ? '' : 'price')
    ..aI(3, _omitFieldNames ? '' : 'duration')
    ..aI(4, _omitFieldNames ? '' : 'tenantId', protoName: 'tenantId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AddPlanRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AddPlanRequest copyWith(void Function(AddPlanRequest) updates) =>
      super.copyWith((message) => updates(message as AddPlanRequest))
          as AddPlanRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AddPlanRequest create() => AddPlanRequest._();
  @$core.override
  AddPlanRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AddPlanRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AddPlanRequest>(create);
  static AddPlanRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get name => $_getSZ(0);
  @$pb.TagNumber(1)
  set name($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasName() => $_has(0);
  @$pb.TagNumber(1)
  void clearName() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get price => $_getI64(1);
  @$pb.TagNumber(2)
  set price($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPrice() => $_has(1);
  @$pb.TagNumber(2)
  void clearPrice() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get duration => $_getIZ(2);
  @$pb.TagNumber(3)
  set duration($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasDuration() => $_has(2);
  @$pb.TagNumber(3)
  void clearDuration() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get tenantId => $_getIZ(3);
  @$pb.TagNumber(4)
  set tenantId($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasTenantId() => $_has(3);
  @$pb.TagNumber(4)
  void clearTenantId() => $_clearField(4);
}

class UpdatePlanRequest extends $pb.GeneratedMessage {
  factory UpdatePlanRequest({
    $core.int? id,
    $core.String? name,
    $fixnum.Int64? price,
    $core.int? duration,
  }) {
    final result = create();
    if (id != null) result.id = id;
    if (name != null) result.name = name;
    if (price != null) result.price = price;
    if (duration != null) result.duration = duration;
    return result;
  }

  UpdatePlanRequest._();

  factory UpdatePlanRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory UpdatePlanRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UpdatePlanRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'app'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'name')
    ..aInt64(3, _omitFieldNames ? '' : 'price')
    ..aI(4, _omitFieldNames ? '' : 'duration')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdatePlanRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdatePlanRequest copyWith(void Function(UpdatePlanRequest) updates) =>
      super.copyWith((message) => updates(message as UpdatePlanRequest))
          as UpdatePlanRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UpdatePlanRequest create() => UpdatePlanRequest._();
  @$core.override
  UpdatePlanRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static UpdatePlanRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UpdatePlanRequest>(create);
  static UpdatePlanRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get id => $_getIZ(0);
  @$pb.TagNumber(1)
  set id($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get name => $_getSZ(1);
  @$pb.TagNumber(2)
  set name($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasName() => $_has(1);
  @$pb.TagNumber(2)
  void clearName() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get price => $_getI64(2);
  @$pb.TagNumber(3)
  set price($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasPrice() => $_has(2);
  @$pb.TagNumber(3)
  void clearPrice() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get duration => $_getIZ(3);
  @$pb.TagNumber(4)
  set duration($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasDuration() => $_has(3);
  @$pb.TagNumber(4)
  void clearDuration() => $_clearField(4);
}

class PlanResponse extends $pb.GeneratedMessage {
  factory PlanResponse({
    $core.String? planId,
  }) {
    final result = create();
    if (planId != null) result.planId = planId;
    return result;
  }

  PlanResponse._();

  factory PlanResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PlanResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PlanResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'app'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'planId', protoName: 'planId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PlanResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PlanResponse copyWith(void Function(PlanResponse) updates) =>
      super.copyWith((message) => updates(message as PlanResponse))
          as PlanResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PlanResponse create() => PlanResponse._();
  @$core.override
  PlanResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PlanResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PlanResponse>(create);
  static PlanResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get planId => $_getSZ(0);
  @$pb.TagNumber(1)
  set planId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPlanId() => $_has(0);
  @$pb.TagNumber(1)
  void clearPlanId() => $_clearField(1);
}

class GetPlanRequest extends $pb.GeneratedMessage {
  factory GetPlanRequest({
    $core.int? planId,
  }) {
    final result = create();
    if (planId != null) result.planId = planId;
    return result;
  }

  GetPlanRequest._();

  factory GetPlanRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetPlanRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetPlanRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'app'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'planId', protoName: 'planId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetPlanRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetPlanRequest copyWith(void Function(GetPlanRequest) updates) =>
      super.copyWith((message) => updates(message as GetPlanRequest))
          as GetPlanRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetPlanRequest create() => GetPlanRequest._();
  @$core.override
  GetPlanRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetPlanRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetPlanRequest>(create);
  static GetPlanRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get planId => $_getIZ(0);
  @$pb.TagNumber(1)
  set planId($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPlanId() => $_has(0);
  @$pb.TagNumber(1)
  void clearPlanId() => $_clearField(1);
}

class Plan extends $pb.GeneratedMessage {
  factory Plan({
    $core.int? id,
    $core.String? name,
    $fixnum.Int64? price,
    $core.int? duration,
    $core.int? tenantId,
    Tenant? tenant,
  }) {
    final result = create();
    if (id != null) result.id = id;
    if (name != null) result.name = name;
    if (price != null) result.price = price;
    if (duration != null) result.duration = duration;
    if (tenantId != null) result.tenantId = tenantId;
    if (tenant != null) result.tenant = tenant;
    return result;
  }

  Plan._();

  factory Plan.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Plan.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Plan',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'app'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'name')
    ..aInt64(3, _omitFieldNames ? '' : 'price')
    ..aI(4, _omitFieldNames ? '' : 'duration')
    ..aI(5, _omitFieldNames ? '' : 'tenantId', protoName: 'tenantId')
    ..aOM<Tenant>(6, _omitFieldNames ? '' : 'tenant', subBuilder: Tenant.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Plan clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Plan copyWith(void Function(Plan) updates) =>
      super.copyWith((message) => updates(message as Plan)) as Plan;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Plan create() => Plan._();
  @$core.override
  Plan createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Plan getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Plan>(create);
  static Plan? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get id => $_getIZ(0);
  @$pb.TagNumber(1)
  set id($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get name => $_getSZ(1);
  @$pb.TagNumber(2)
  set name($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasName() => $_has(1);
  @$pb.TagNumber(2)
  void clearName() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get price => $_getI64(2);
  @$pb.TagNumber(3)
  set price($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasPrice() => $_has(2);
  @$pb.TagNumber(3)
  void clearPrice() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get duration => $_getIZ(3);
  @$pb.TagNumber(4)
  set duration($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasDuration() => $_has(3);
  @$pb.TagNumber(4)
  void clearDuration() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.int get tenantId => $_getIZ(4);
  @$pb.TagNumber(5)
  set tenantId($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasTenantId() => $_has(4);
  @$pb.TagNumber(5)
  void clearTenantId() => $_clearField(5);

  @$pb.TagNumber(6)
  Tenant get tenant => $_getN(5);
  @$pb.TagNumber(6)
  set tenant(Tenant value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasTenant() => $_has(5);
  @$pb.TagNumber(6)
  void clearTenant() => $_clearField(6);
  @$pb.TagNumber(6)
  Tenant ensureTenant() => $_ensure(5);
}

class Membership extends $pb.GeneratedMessage {
  factory Membership({
    $core.int? id,
    $core.int? userId,
    Plan? plan,
    $core.String? status,
    $1.Timestamp? startDate,
    $1.Timestamp? endDate,
    Offering? offering,
    $core.int? planId,
    $core.int? offeringId,
  }) {
    final result = create();
    if (id != null) result.id = id;
    if (userId != null) result.userId = userId;
    if (plan != null) result.plan = plan;
    if (status != null) result.status = status;
    if (startDate != null) result.startDate = startDate;
    if (endDate != null) result.endDate = endDate;
    if (offering != null) result.offering = offering;
    if (planId != null) result.planId = planId;
    if (offeringId != null) result.offeringId = offeringId;
    return result;
  }

  Membership._();

  factory Membership.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Membership.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Membership',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'app'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'id')
    ..aI(2, _omitFieldNames ? '' : 'userId', protoName: 'userId')
    ..aOM<Plan>(3, _omitFieldNames ? '' : 'plan', subBuilder: Plan.create)
    ..aOS(4, _omitFieldNames ? '' : 'status')
    ..aOM<$1.Timestamp>(5, _omitFieldNames ? '' : 'startDate',
        protoName: 'startDate', subBuilder: $1.Timestamp.create)
    ..aOM<$1.Timestamp>(6, _omitFieldNames ? '' : 'endDate',
        protoName: 'endDate', subBuilder: $1.Timestamp.create)
    ..aOM<Offering>(7, _omitFieldNames ? '' : 'offering',
        subBuilder: Offering.create)
    ..aI(8, _omitFieldNames ? '' : 'planId', protoName: 'planId')
    ..aI(9, _omitFieldNames ? '' : 'offeringId', protoName: 'offeringId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Membership clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Membership copyWith(void Function(Membership) updates) =>
      super.copyWith((message) => updates(message as Membership)) as Membership;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Membership create() => Membership._();
  @$core.override
  Membership createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Membership getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Membership>(create);
  static Membership? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get id => $_getIZ(0);
  @$pb.TagNumber(1)
  set id($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get userId => $_getIZ(1);
  @$pb.TagNumber(2)
  set userId($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasUserId() => $_has(1);
  @$pb.TagNumber(2)
  void clearUserId() => $_clearField(2);

  @$pb.TagNumber(3)
  Plan get plan => $_getN(2);
  @$pb.TagNumber(3)
  set plan(Plan value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasPlan() => $_has(2);
  @$pb.TagNumber(3)
  void clearPlan() => $_clearField(3);
  @$pb.TagNumber(3)
  Plan ensurePlan() => $_ensure(2);

  @$pb.TagNumber(4)
  $core.String get status => $_getSZ(3);
  @$pb.TagNumber(4)
  set status($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasStatus() => $_has(3);
  @$pb.TagNumber(4)
  void clearStatus() => $_clearField(4);

  @$pb.TagNumber(5)
  $1.Timestamp get startDate => $_getN(4);
  @$pb.TagNumber(5)
  set startDate($1.Timestamp value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasStartDate() => $_has(4);
  @$pb.TagNumber(5)
  void clearStartDate() => $_clearField(5);
  @$pb.TagNumber(5)
  $1.Timestamp ensureStartDate() => $_ensure(4);

  @$pb.TagNumber(6)
  $1.Timestamp get endDate => $_getN(5);
  @$pb.TagNumber(6)
  set endDate($1.Timestamp value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasEndDate() => $_has(5);
  @$pb.TagNumber(6)
  void clearEndDate() => $_clearField(6);
  @$pb.TagNumber(6)
  $1.Timestamp ensureEndDate() => $_ensure(5);

  @$pb.TagNumber(7)
  Offering get offering => $_getN(6);
  @$pb.TagNumber(7)
  set offering(Offering value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasOffering() => $_has(6);
  @$pb.TagNumber(7)
  void clearOffering() => $_clearField(7);
  @$pb.TagNumber(7)
  Offering ensureOffering() => $_ensure(6);

  @$pb.TagNumber(8)
  $core.int get planId => $_getIZ(7);
  @$pb.TagNumber(8)
  set planId($core.int value) => $_setSignedInt32(7, value);
  @$pb.TagNumber(8)
  $core.bool hasPlanId() => $_has(7);
  @$pb.TagNumber(8)
  void clearPlanId() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.int get offeringId => $_getIZ(8);
  @$pb.TagNumber(9)
  set offeringId($core.int value) => $_setSignedInt32(8, value);
  @$pb.TagNumber(9)
  $core.bool hasOfferingId() => $_has(8);
  @$pb.TagNumber(9)
  void clearOfferingId() => $_clearField(9);
}

class CreateTransactionRequest extends $pb.GeneratedMessage {
  factory CreateTransactionRequest({
    $core.int? memberId,
    $core.int? planId,
    $core.int? offeringId,
    $core.String? method,
  }) {
    final result = create();
    if (memberId != null) result.memberId = memberId;
    if (planId != null) result.planId = planId;
    if (offeringId != null) result.offeringId = offeringId;
    if (method != null) result.method = method;
    return result;
  }

  CreateTransactionRequest._();

  factory CreateTransactionRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CreateTransactionRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CreateTransactionRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'app'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'memberId', protoName: 'memberId')
    ..aI(2, _omitFieldNames ? '' : 'planId', protoName: 'planId')
    ..aI(3, _omitFieldNames ? '' : 'offeringId', protoName: 'offeringId')
    ..aOS(4, _omitFieldNames ? '' : 'method')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateTransactionRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateTransactionRequest copyWith(
          void Function(CreateTransactionRequest) updates) =>
      super.copyWith((message) => updates(message as CreateTransactionRequest))
          as CreateTransactionRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CreateTransactionRequest create() => CreateTransactionRequest._();
  @$core.override
  CreateTransactionRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CreateTransactionRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CreateTransactionRequest>(create);
  static CreateTransactionRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get memberId => $_getIZ(0);
  @$pb.TagNumber(1)
  set memberId($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasMemberId() => $_has(0);
  @$pb.TagNumber(1)
  void clearMemberId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get planId => $_getIZ(1);
  @$pb.TagNumber(2)
  set planId($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPlanId() => $_has(1);
  @$pb.TagNumber(2)
  void clearPlanId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get offeringId => $_getIZ(2);
  @$pb.TagNumber(3)
  set offeringId($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasOfferingId() => $_has(2);
  @$pb.TagNumber(3)
  void clearOfferingId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get method => $_getSZ(3);
  @$pb.TagNumber(4)
  set method($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasMethod() => $_has(3);
  @$pb.TagNumber(4)
  void clearMethod() => $_clearField(4);
}

class GetTransactionsRequest extends $pb.GeneratedMessage {
  factory GetTransactionsRequest({
    $core.int? tenantId,
    $core.String? startDate,
    $core.String? endDate,
  }) {
    final result = create();
    if (tenantId != null) result.tenantId = tenantId;
    if (startDate != null) result.startDate = startDate;
    if (endDate != null) result.endDate = endDate;
    return result;
  }

  GetTransactionsRequest._();

  factory GetTransactionsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetTransactionsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetTransactionsRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'app'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'tenantId', protoName: 'tenantId')
    ..aOS(2, _omitFieldNames ? '' : 'startDate', protoName: 'startDate')
    ..aOS(3, _omitFieldNames ? '' : 'endDate', protoName: 'endDate')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetTransactionsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetTransactionsRequest copyWith(
          void Function(GetTransactionsRequest) updates) =>
      super.copyWith((message) => updates(message as GetTransactionsRequest))
          as GetTransactionsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetTransactionsRequest create() => GetTransactionsRequest._();
  @$core.override
  GetTransactionsRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetTransactionsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetTransactionsRequest>(create);
  static GetTransactionsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get tenantId => $_getIZ(0);
  @$pb.TagNumber(1)
  set tenantId($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTenantId() => $_has(0);
  @$pb.TagNumber(1)
  void clearTenantId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get startDate => $_getSZ(1);
  @$pb.TagNumber(2)
  set startDate($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasStartDate() => $_has(1);
  @$pb.TagNumber(2)
  void clearStartDate() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get endDate => $_getSZ(2);
  @$pb.TagNumber(3)
  set endDate($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasEndDate() => $_has(2);
  @$pb.TagNumber(3)
  void clearEndDate() => $_clearField(3);
}

class GetTransactionRequest extends $pb.GeneratedMessage {
  factory GetTransactionRequest({
    $core.String? transactionId,
  }) {
    final result = create();
    if (transactionId != null) result.transactionId = transactionId;
    return result;
  }

  GetTransactionRequest._();

  factory GetTransactionRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetTransactionRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetTransactionRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'app'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'transactionId', protoName: 'transactionId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetTransactionRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetTransactionRequest copyWith(
          void Function(GetTransactionRequest) updates) =>
      super.copyWith((message) => updates(message as GetTransactionRequest))
          as GetTransactionRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetTransactionRequest create() => GetTransactionRequest._();
  @$core.override
  GetTransactionRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetTransactionRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetTransactionRequest>(create);
  static GetTransactionRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get transactionId => $_getSZ(0);
  @$pb.TagNumber(1)
  set transactionId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTransactionId() => $_has(0);
  @$pb.TagNumber(1)
  void clearTransactionId() => $_clearField(1);
}

class FinanceSummary extends $pb.GeneratedMessage {
  factory FinanceSummary({
    $fixnum.Int64? totalRevenue,
    $core.int? totalTransactions,
    $core.int? activeMemberships,
  }) {
    final result = create();
    if (totalRevenue != null) result.totalRevenue = totalRevenue;
    if (totalTransactions != null) result.totalTransactions = totalTransactions;
    if (activeMemberships != null) result.activeMemberships = activeMemberships;
    return result;
  }

  FinanceSummary._();

  factory FinanceSummary.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory FinanceSummary.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'FinanceSummary',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'app'),
      createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'totalRevenue',
        protoName: 'totalRevenue')
    ..aI(2, _omitFieldNames ? '' : 'totalTransactions',
        protoName: 'totalTransactions')
    ..aI(3, _omitFieldNames ? '' : 'activeMemberships',
        protoName: 'activeMemberships')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FinanceSummary clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FinanceSummary copyWith(void Function(FinanceSummary) updates) =>
      super.copyWith((message) => updates(message as FinanceSummary))
          as FinanceSummary;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static FinanceSummary create() => FinanceSummary._();
  @$core.override
  FinanceSummary createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static FinanceSummary getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<FinanceSummary>(create);
  static FinanceSummary? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get totalRevenue => $_getI64(0);
  @$pb.TagNumber(1)
  set totalRevenue($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTotalRevenue() => $_has(0);
  @$pb.TagNumber(1)
  void clearTotalRevenue() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get totalTransactions => $_getIZ(1);
  @$pb.TagNumber(2)
  set totalTransactions($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTotalTransactions() => $_has(1);
  @$pb.TagNumber(2)
  void clearTotalTransactions() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get activeMemberships => $_getIZ(2);
  @$pb.TagNumber(3)
  set activeMemberships($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasActiveMemberships() => $_has(2);
  @$pb.TagNumber(3)
  void clearActiveMemberships() => $_clearField(3);
}

class Transaction extends $pb.GeneratedMessage {
  factory Transaction({
    $core.String? id,
    $core.int? memberId,
    $core.int? planId,
    $fixnum.Int64? amount,
    $core.String? method,
    $core.String? status,
    $core.String? qrisUrl,
    $1.Timestamp? createdAt,
    $core.String? memberName,
    $core.String? planName,
    $core.int? offeringId,
    $core.String? offeringName,
  }) {
    final result = create();
    if (id != null) result.id = id;
    if (memberId != null) result.memberId = memberId;
    if (planId != null) result.planId = planId;
    if (amount != null) result.amount = amount;
    if (method != null) result.method = method;
    if (status != null) result.status = status;
    if (qrisUrl != null) result.qrisUrl = qrisUrl;
    if (createdAt != null) result.createdAt = createdAt;
    if (memberName != null) result.memberName = memberName;
    if (planName != null) result.planName = planName;
    if (offeringId != null) result.offeringId = offeringId;
    if (offeringName != null) result.offeringName = offeringName;
    return result;
  }

  Transaction._();

  factory Transaction.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Transaction.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Transaction',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'app'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aI(2, _omitFieldNames ? '' : 'memberId', protoName: 'memberId')
    ..aI(3, _omitFieldNames ? '' : 'planId', protoName: 'planId')
    ..aInt64(4, _omitFieldNames ? '' : 'amount')
    ..aOS(5, _omitFieldNames ? '' : 'method')
    ..aOS(6, _omitFieldNames ? '' : 'status')
    ..aOS(7, _omitFieldNames ? '' : 'qrisUrl', protoName: 'qrisUrl')
    ..aOM<$1.Timestamp>(8, _omitFieldNames ? '' : 'createdAt',
        protoName: 'createdAt', subBuilder: $1.Timestamp.create)
    ..aOS(9, _omitFieldNames ? '' : 'memberName', protoName: 'memberName')
    ..aOS(10, _omitFieldNames ? '' : 'planName', protoName: 'planName')
    ..aI(11, _omitFieldNames ? '' : 'offeringId', protoName: 'offeringId')
    ..aOS(12, _omitFieldNames ? '' : 'offeringName', protoName: 'offeringName')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Transaction clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Transaction copyWith(void Function(Transaction) updates) =>
      super.copyWith((message) => updates(message as Transaction))
          as Transaction;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Transaction create() => Transaction._();
  @$core.override
  Transaction createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Transaction getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Transaction>(create);
  static Transaction? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get memberId => $_getIZ(1);
  @$pb.TagNumber(2)
  set memberId($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasMemberId() => $_has(1);
  @$pb.TagNumber(2)
  void clearMemberId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get planId => $_getIZ(2);
  @$pb.TagNumber(3)
  set planId($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasPlanId() => $_has(2);
  @$pb.TagNumber(3)
  void clearPlanId() => $_clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get amount => $_getI64(3);
  @$pb.TagNumber(4)
  set amount($fixnum.Int64 value) => $_setInt64(3, value);
  @$pb.TagNumber(4)
  $core.bool hasAmount() => $_has(3);
  @$pb.TagNumber(4)
  void clearAmount() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get method => $_getSZ(4);
  @$pb.TagNumber(5)
  set method($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasMethod() => $_has(4);
  @$pb.TagNumber(5)
  void clearMethod() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get status => $_getSZ(5);
  @$pb.TagNumber(6)
  set status($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasStatus() => $_has(5);
  @$pb.TagNumber(6)
  void clearStatus() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get qrisUrl => $_getSZ(6);
  @$pb.TagNumber(7)
  set qrisUrl($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasQrisUrl() => $_has(6);
  @$pb.TagNumber(7)
  void clearQrisUrl() => $_clearField(7);

  @$pb.TagNumber(8)
  $1.Timestamp get createdAt => $_getN(7);
  @$pb.TagNumber(8)
  set createdAt($1.Timestamp value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasCreatedAt() => $_has(7);
  @$pb.TagNumber(8)
  void clearCreatedAt() => $_clearField(8);
  @$pb.TagNumber(8)
  $1.Timestamp ensureCreatedAt() => $_ensure(7);

  @$pb.TagNumber(9)
  $core.String get memberName => $_getSZ(8);
  @$pb.TagNumber(9)
  set memberName($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasMemberName() => $_has(8);
  @$pb.TagNumber(9)
  void clearMemberName() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.String get planName => $_getSZ(9);
  @$pb.TagNumber(10)
  set planName($core.String value) => $_setString(9, value);
  @$pb.TagNumber(10)
  $core.bool hasPlanName() => $_has(9);
  @$pb.TagNumber(10)
  void clearPlanName() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.int get offeringId => $_getIZ(10);
  @$pb.TagNumber(11)
  set offeringId($core.int value) => $_setSignedInt32(10, value);
  @$pb.TagNumber(11)
  $core.bool hasOfferingId() => $_has(10);
  @$pb.TagNumber(11)
  void clearOfferingId() => $_clearField(11);

  @$pb.TagNumber(12)
  $core.String get offeringName => $_getSZ(11);
  @$pb.TagNumber(12)
  set offeringName($core.String value) => $_setString(11, value);
  @$pb.TagNumber(12)
  $core.bool hasOfferingName() => $_has(11);
  @$pb.TagNumber(12)
  void clearOfferingName() => $_clearField(12);
}

class AddOfferingRequest extends $pb.GeneratedMessage {
  factory AddOfferingRequest({
    $core.String? name,
    $fixnum.Int64? price,
    $core.String? type,
    $core.int? duration,
    $core.int? stock,
    $core.int? quota,
    $core.int? tenantId,
  }) {
    final result = create();
    if (name != null) result.name = name;
    if (price != null) result.price = price;
    if (type != null) result.type = type;
    if (duration != null) result.duration = duration;
    if (stock != null) result.stock = stock;
    if (quota != null) result.quota = quota;
    if (tenantId != null) result.tenantId = tenantId;
    return result;
  }

  AddOfferingRequest._();

  factory AddOfferingRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AddOfferingRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AddOfferingRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'app'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'name')
    ..aInt64(2, _omitFieldNames ? '' : 'price')
    ..aOS(3, _omitFieldNames ? '' : 'type')
    ..aI(4, _omitFieldNames ? '' : 'duration')
    ..aI(5, _omitFieldNames ? '' : 'stock')
    ..aI(6, _omitFieldNames ? '' : 'quota')
    ..aI(7, _omitFieldNames ? '' : 'tenantId', protoName: 'tenantId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AddOfferingRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AddOfferingRequest copyWith(void Function(AddOfferingRequest) updates) =>
      super.copyWith((message) => updates(message as AddOfferingRequest))
          as AddOfferingRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AddOfferingRequest create() => AddOfferingRequest._();
  @$core.override
  AddOfferingRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AddOfferingRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AddOfferingRequest>(create);
  static AddOfferingRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get name => $_getSZ(0);
  @$pb.TagNumber(1)
  set name($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasName() => $_has(0);
  @$pb.TagNumber(1)
  void clearName() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get price => $_getI64(1);
  @$pb.TagNumber(2)
  set price($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPrice() => $_has(1);
  @$pb.TagNumber(2)
  void clearPrice() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get type => $_getSZ(2);
  @$pb.TagNumber(3)
  set type($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasType() => $_has(2);
  @$pb.TagNumber(3)
  void clearType() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get duration => $_getIZ(3);
  @$pb.TagNumber(4)
  set duration($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasDuration() => $_has(3);
  @$pb.TagNumber(4)
  void clearDuration() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.int get stock => $_getIZ(4);
  @$pb.TagNumber(5)
  set stock($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasStock() => $_has(4);
  @$pb.TagNumber(5)
  void clearStock() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.int get quota => $_getIZ(5);
  @$pb.TagNumber(6)
  set quota($core.int value) => $_setSignedInt32(5, value);
  @$pb.TagNumber(6)
  $core.bool hasQuota() => $_has(5);
  @$pb.TagNumber(6)
  void clearQuota() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.int get tenantId => $_getIZ(6);
  @$pb.TagNumber(7)
  set tenantId($core.int value) => $_setSignedInt32(6, value);
  @$pb.TagNumber(7)
  $core.bool hasTenantId() => $_has(6);
  @$pb.TagNumber(7)
  void clearTenantId() => $_clearField(7);
}

class UpdateOfferingRequest extends $pb.GeneratedMessage {
  factory UpdateOfferingRequest({
    $core.int? id,
    $core.String? name,
    $fixnum.Int64? price,
    $core.String? type,
    $core.int? duration,
    $core.int? stock,
    $core.int? quota,
  }) {
    final result = create();
    if (id != null) result.id = id;
    if (name != null) result.name = name;
    if (price != null) result.price = price;
    if (type != null) result.type = type;
    if (duration != null) result.duration = duration;
    if (stock != null) result.stock = stock;
    if (quota != null) result.quota = quota;
    return result;
  }

  UpdateOfferingRequest._();

  factory UpdateOfferingRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory UpdateOfferingRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UpdateOfferingRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'app'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'name')
    ..aInt64(3, _omitFieldNames ? '' : 'price')
    ..aOS(4, _omitFieldNames ? '' : 'type')
    ..aI(5, _omitFieldNames ? '' : 'duration')
    ..aI(6, _omitFieldNames ? '' : 'stock')
    ..aI(7, _omitFieldNames ? '' : 'quota')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateOfferingRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateOfferingRequest copyWith(
          void Function(UpdateOfferingRequest) updates) =>
      super.copyWith((message) => updates(message as UpdateOfferingRequest))
          as UpdateOfferingRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UpdateOfferingRequest create() => UpdateOfferingRequest._();
  @$core.override
  UpdateOfferingRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static UpdateOfferingRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UpdateOfferingRequest>(create);
  static UpdateOfferingRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get id => $_getIZ(0);
  @$pb.TagNumber(1)
  set id($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get name => $_getSZ(1);
  @$pb.TagNumber(2)
  set name($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasName() => $_has(1);
  @$pb.TagNumber(2)
  void clearName() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get price => $_getI64(2);
  @$pb.TagNumber(3)
  set price($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasPrice() => $_has(2);
  @$pb.TagNumber(3)
  void clearPrice() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get type => $_getSZ(3);
  @$pb.TagNumber(4)
  set type($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasType() => $_has(3);
  @$pb.TagNumber(4)
  void clearType() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.int get duration => $_getIZ(4);
  @$pb.TagNumber(5)
  set duration($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasDuration() => $_has(4);
  @$pb.TagNumber(5)
  void clearDuration() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.int get stock => $_getIZ(5);
  @$pb.TagNumber(6)
  set stock($core.int value) => $_setSignedInt32(5, value);
  @$pb.TagNumber(6)
  $core.bool hasStock() => $_has(5);
  @$pb.TagNumber(6)
  void clearStock() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.int get quota => $_getIZ(6);
  @$pb.TagNumber(7)
  set quota($core.int value) => $_setSignedInt32(6, value);
  @$pb.TagNumber(7)
  $core.bool hasQuota() => $_has(6);
  @$pb.TagNumber(7)
  void clearQuota() => $_clearField(7);
}

class OfferingResponse extends $pb.GeneratedMessage {
  factory OfferingResponse({
    $core.int? offeringId,
  }) {
    final result = create();
    if (offeringId != null) result.offeringId = offeringId;
    return result;
  }

  OfferingResponse._();

  factory OfferingResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory OfferingResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'OfferingResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'app'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'offeringId', protoName: 'offeringId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OfferingResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OfferingResponse copyWith(void Function(OfferingResponse) updates) =>
      super.copyWith((message) => updates(message as OfferingResponse))
          as OfferingResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static OfferingResponse create() => OfferingResponse._();
  @$core.override
  OfferingResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static OfferingResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<OfferingResponse>(create);
  static OfferingResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get offeringId => $_getIZ(0);
  @$pb.TagNumber(1)
  set offeringId($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasOfferingId() => $_has(0);
  @$pb.TagNumber(1)
  void clearOfferingId() => $_clearField(1);
}

class GetOfferingRequest extends $pb.GeneratedMessage {
  factory GetOfferingRequest({
    $core.int? offeringId,
  }) {
    final result = create();
    if (offeringId != null) result.offeringId = offeringId;
    return result;
  }

  GetOfferingRequest._();

  factory GetOfferingRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetOfferingRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetOfferingRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'app'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'offeringId', protoName: 'offeringId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetOfferingRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetOfferingRequest copyWith(void Function(GetOfferingRequest) updates) =>
      super.copyWith((message) => updates(message as GetOfferingRequest))
          as GetOfferingRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetOfferingRequest create() => GetOfferingRequest._();
  @$core.override
  GetOfferingRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetOfferingRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetOfferingRequest>(create);
  static GetOfferingRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get offeringId => $_getIZ(0);
  @$pb.TagNumber(1)
  set offeringId($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasOfferingId() => $_has(0);
  @$pb.TagNumber(1)
  void clearOfferingId() => $_clearField(1);
}

class Offering extends $pb.GeneratedMessage {
  factory Offering({
    $core.int? id,
    $core.String? name,
    $fixnum.Int64? price,
    $core.String? type,
    $core.int? duration,
    $core.int? stock,
    $core.int? quota,
    $core.int? tenantId,
  }) {
    final result = create();
    if (id != null) result.id = id;
    if (name != null) result.name = name;
    if (price != null) result.price = price;
    if (type != null) result.type = type;
    if (duration != null) result.duration = duration;
    if (stock != null) result.stock = stock;
    if (quota != null) result.quota = quota;
    if (tenantId != null) result.tenantId = tenantId;
    return result;
  }

  Offering._();

  factory Offering.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Offering.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Offering',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'app'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'name')
    ..aInt64(3, _omitFieldNames ? '' : 'price')
    ..aOS(4, _omitFieldNames ? '' : 'type')
    ..aI(5, _omitFieldNames ? '' : 'duration')
    ..aI(6, _omitFieldNames ? '' : 'stock')
    ..aI(7, _omitFieldNames ? '' : 'quota')
    ..aI(8, _omitFieldNames ? '' : 'tenantId', protoName: 'tenantId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Offering clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Offering copyWith(void Function(Offering) updates) =>
      super.copyWith((message) => updates(message as Offering)) as Offering;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Offering create() => Offering._();
  @$core.override
  Offering createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Offering getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Offering>(create);
  static Offering? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get id => $_getIZ(0);
  @$pb.TagNumber(1)
  set id($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get name => $_getSZ(1);
  @$pb.TagNumber(2)
  set name($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasName() => $_has(1);
  @$pb.TagNumber(2)
  void clearName() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get price => $_getI64(2);
  @$pb.TagNumber(3)
  set price($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasPrice() => $_has(2);
  @$pb.TagNumber(3)
  void clearPrice() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get type => $_getSZ(3);
  @$pb.TagNumber(4)
  set type($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasType() => $_has(3);
  @$pb.TagNumber(4)
  void clearType() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.int get duration => $_getIZ(4);
  @$pb.TagNumber(5)
  set duration($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasDuration() => $_has(4);
  @$pb.TagNumber(5)
  void clearDuration() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.int get stock => $_getIZ(5);
  @$pb.TagNumber(6)
  set stock($core.int value) => $_setSignedInt32(5, value);
  @$pb.TagNumber(6)
  $core.bool hasStock() => $_has(5);
  @$pb.TagNumber(6)
  void clearStock() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.int get quota => $_getIZ(6);
  @$pb.TagNumber(7)
  set quota($core.int value) => $_setSignedInt32(6, value);
  @$pb.TagNumber(7)
  $core.bool hasQuota() => $_has(6);
  @$pb.TagNumber(7)
  void clearQuota() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.int get tenantId => $_getIZ(7);
  @$pb.TagNumber(8)
  set tenantId($core.int value) => $_setSignedInt32(7, value);
  @$pb.TagNumber(8)
  $core.bool hasTenantId() => $_has(7);
  @$pb.TagNumber(8)
  void clearTenantId() => $_clearField(8);
}

class CheckInRequest extends $pb.GeneratedMessage {
  factory CheckInRequest({
    $core.String? memberId,
  }) {
    final result = create();
    if (memberId != null) result.memberId = memberId;
    return result;
  }

  CheckInRequest._();

  factory CheckInRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CheckInRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CheckInRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'app'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'memberId', protoName: 'memberId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CheckInRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CheckInRequest copyWith(void Function(CheckInRequest) updates) =>
      super.copyWith((message) => updates(message as CheckInRequest))
          as CheckInRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CheckInRequest create() => CheckInRequest._();
  @$core.override
  CheckInRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CheckInRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CheckInRequest>(create);
  static CheckInRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get memberId => $_getSZ(0);
  @$pb.TagNumber(1)
  set memberId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasMemberId() => $_has(0);
  @$pb.TagNumber(1)
  void clearMemberId() => $_clearField(1);
}

class CheckInResponse extends $pb.GeneratedMessage {
  factory CheckInResponse({
    $core.String? checkInId,
    $core.String? timestamp,
  }) {
    final result = create();
    if (checkInId != null) result.checkInId = checkInId;
    if (timestamp != null) result.timestamp = timestamp;
    return result;
  }

  CheckInResponse._();

  factory CheckInResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CheckInResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CheckInResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'app'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'checkInId', protoName: 'checkInId')
    ..aOS(2, _omitFieldNames ? '' : 'timestamp')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CheckInResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CheckInResponse copyWith(void Function(CheckInResponse) updates) =>
      super.copyWith((message) => updates(message as CheckInResponse))
          as CheckInResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CheckInResponse create() => CheckInResponse._();
  @$core.override
  CheckInResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CheckInResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CheckInResponse>(create);
  static CheckInResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get checkInId => $_getSZ(0);
  @$pb.TagNumber(1)
  set checkInId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCheckInId() => $_has(0);
  @$pb.TagNumber(1)
  void clearCheckInId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get timestamp => $_getSZ(1);
  @$pb.TagNumber(2)
  set timestamp($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTimestamp() => $_has(1);
  @$pb.TagNumber(2)
  void clearTimestamp() => $_clearField(2);
}

class GetAttendanceHistoryRequest extends $pb.GeneratedMessage {
  factory GetAttendanceHistoryRequest({
    $core.String? memberId,
  }) {
    final result = create();
    if (memberId != null) result.memberId = memberId;
    return result;
  }

  GetAttendanceHistoryRequest._();

  factory GetAttendanceHistoryRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetAttendanceHistoryRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetAttendanceHistoryRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'app'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'memberId', protoName: 'memberId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetAttendanceHistoryRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetAttendanceHistoryRequest copyWith(
          void Function(GetAttendanceHistoryRequest) updates) =>
      super.copyWith(
              (message) => updates(message as GetAttendanceHistoryRequest))
          as GetAttendanceHistoryRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetAttendanceHistoryRequest create() =>
      GetAttendanceHistoryRequest._();
  @$core.override
  GetAttendanceHistoryRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetAttendanceHistoryRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetAttendanceHistoryRequest>(create);
  static GetAttendanceHistoryRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get memberId => $_getSZ(0);
  @$pb.TagNumber(1)
  set memberId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasMemberId() => $_has(0);
  @$pb.TagNumber(1)
  void clearMemberId() => $_clearField(1);
}

class AttendanceRecord extends $pb.GeneratedMessage {
  factory AttendanceRecord({
    $core.String? checkInId,
    $core.String? timestamp,
  }) {
    final result = create();
    if (checkInId != null) result.checkInId = checkInId;
    if (timestamp != null) result.timestamp = timestamp;
    return result;
  }

  AttendanceRecord._();

  factory AttendanceRecord.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AttendanceRecord.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AttendanceRecord',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'app'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'checkInId', protoName: 'checkInId')
    ..aOS(2, _omitFieldNames ? '' : 'timestamp')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AttendanceRecord clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AttendanceRecord copyWith(void Function(AttendanceRecord) updates) =>
      super.copyWith((message) => updates(message as AttendanceRecord))
          as AttendanceRecord;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AttendanceRecord create() => AttendanceRecord._();
  @$core.override
  AttendanceRecord createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AttendanceRecord getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AttendanceRecord>(create);
  static AttendanceRecord? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get checkInId => $_getSZ(0);
  @$pb.TagNumber(1)
  set checkInId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCheckInId() => $_has(0);
  @$pb.TagNumber(1)
  void clearCheckInId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get timestamp => $_getSZ(1);
  @$pb.TagNumber(2)
  set timestamp($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTimestamp() => $_has(1);
  @$pb.TagNumber(2)
  void clearTimestamp() => $_clearField(2);
}

class AttendanceHistory extends $pb.GeneratedMessage {
  factory AttendanceHistory({
    $core.Iterable<AttendanceRecord>? records,
  }) {
    final result = create();
    if (records != null) result.records.addAll(records);
    return result;
  }

  AttendanceHistory._();

  factory AttendanceHistory.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AttendanceHistory.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AttendanceHistory',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'app'),
      createEmptyInstance: create)
    ..pPM<AttendanceRecord>(1, _omitFieldNames ? '' : 'records',
        subBuilder: AttendanceRecord.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AttendanceHistory clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AttendanceHistory copyWith(void Function(AttendanceHistory) updates) =>
      super.copyWith((message) => updates(message as AttendanceHistory))
          as AttendanceHistory;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AttendanceHistory create() => AttendanceHistory._();
  @$core.override
  AttendanceHistory createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AttendanceHistory getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AttendanceHistory>(create);
  static AttendanceHistory? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<AttendanceRecord> get records => $_getList(0);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
