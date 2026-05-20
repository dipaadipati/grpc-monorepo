// This is a generated file - do not edit.
//
// Generated from app.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports
// ignore_for_file: unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use emptyDescriptor instead')
const Empty$json = {
  '1': 'Empty',
};

/// Descriptor for `Empty`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List emptyDescriptor =
    $convert.base64Decode('CgVFbXB0eQ==');

@$core.Deprecated('Use loginRequestDescriptor instead')
const LoginRequest$json = {
  '1': 'LoginRequest',
  '2': [
    {'1': 'email', '3': 1, '4': 1, '5': 9, '10': 'email'},
    {'1': 'password', '3': 2, '4': 1, '5': 9, '10': 'password'},
  ],
};

/// Descriptor for `LoginRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List loginRequestDescriptor = $convert.base64Decode(
    'CgxMb2dpblJlcXVlc3QSFAoFZW1haWwYASABKAlSBWVtYWlsEhoKCHBhc3N3b3JkGAIgASgJUg'
    'hwYXNzd29yZA==');

@$core.Deprecated('Use userProfileDescriptor instead')
const UserProfile$json = {
  '1': 'UserProfile',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 5, '10': 'id'},
    {'1': 'email', '3': 2, '4': 1, '5': 9, '10': 'email'},
    {'1': 'name', '3': 3, '4': 1, '5': 9, '10': 'name'},
    {'1': 'role', '3': 4, '4': 1, '5': 9, '10': 'role'},
    {'1': 'tenantId', '3': 5, '4': 1, '5': 5, '10': 'tenantId'},
    {'1': 'tenantName', '3': 6, '4': 1, '5': 9, '10': 'tenantName'},
    {
      '1': 'membership',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.app.Membership',
      '10': 'membership'
    },
    {
      '1': 'createdAt',
      '3': 8,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'createdAt'
    },
    {
      '1': 'midtransClientKey',
      '3': 9,
      '4': 1,
      '5': 9,
      '10': 'midtransClientKey'
    },
    {'1': 'tenantIsActive', '3': 10, '4': 1, '5': 8, '10': 'tenantIsActive'},
  ],
};

/// Descriptor for `UserProfile`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List userProfileDescriptor = $convert.base64Decode(
    'CgtVc2VyUHJvZmlsZRIOCgJpZBgBIAEoBVICaWQSFAoFZW1haWwYAiABKAlSBWVtYWlsEhIKBG'
    '5hbWUYAyABKAlSBG5hbWUSEgoEcm9sZRgEIAEoCVIEcm9sZRIaCgh0ZW5hbnRJZBgFIAEoBVII'
    'dGVuYW50SWQSHgoKdGVuYW50TmFtZRgGIAEoCVIKdGVuYW50TmFtZRIvCgptZW1iZXJzaGlwGA'
    'cgASgLMg8uYXBwLk1lbWJlcnNoaXBSCm1lbWJlcnNoaXASOAoJY3JlYXRlZEF0GAggASgLMhou'
    'Z29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIJY3JlYXRlZEF0EiwKEW1pZHRyYW5zQ2xpZW50S2'
    'V5GAkgASgJUhFtaWR0cmFuc0NsaWVudEtleRImCg50ZW5hbnRJc0FjdGl2ZRgKIAEoCFIOdGVu'
    'YW50SXNBY3RpdmU=');

@$core.Deprecated('Use authResponseDescriptor instead')
const AuthResponse$json = {
  '1': 'AuthResponse',
  '2': [
    {'1': 'token', '3': 1, '4': 1, '5': 9, '10': 'token'},
  ],
};

/// Descriptor for `AuthResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List authResponseDescriptor =
    $convert.base64Decode('CgxBdXRoUmVzcG9uc2USFAoFdG9rZW4YASABKAlSBXRva2Vu');

@$core.Deprecated('Use logoutResponseDescriptor instead')
const LogoutResponse$json = {
  '1': 'LogoutResponse',
  '2': [
    {'1': 'success', '3': 1, '4': 1, '5': 8, '10': 'success'},
  ],
};

/// Descriptor for `LogoutResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List logoutResponseDescriptor = $convert
    .base64Decode('Cg5Mb2dvdXRSZXNwb25zZRIYCgdzdWNjZXNzGAEgASgIUgdzdWNjZXNz');

@$core.Deprecated('Use registerMemberRequestDescriptor instead')
const RegisterMemberRequest$json = {
  '1': 'RegisterMemberRequest',
  '2': [
    {'1': 'email', '3': 1, '4': 1, '5': 9, '10': 'email'},
    {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
    {'1': 'password', '3': 3, '4': 1, '5': 9, '10': 'password'},
  ],
};

/// Descriptor for `RegisterMemberRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List registerMemberRequestDescriptor = $convert.base64Decode(
    'ChVSZWdpc3Rlck1lbWJlclJlcXVlc3QSFAoFZW1haWwYASABKAlSBWVtYWlsEhIKBG5hbWUYAi'
    'ABKAlSBG5hbWUSGgoIcGFzc3dvcmQYAyABKAlSCHBhc3N3b3Jk');

@$core.Deprecated('Use updateMemberRequestDescriptor instead')
const UpdateMemberRequest$json = {
  '1': 'UpdateMemberRequest',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 5, '10': 'id'},
    {'1': 'email', '3': 2, '4': 1, '5': 9, '10': 'email'},
    {'1': 'name', '3': 3, '4': 1, '5': 9, '10': 'name'},
    {'1': 'password', '3': 4, '4': 1, '5': 9, '10': 'password'},
  ],
};

/// Descriptor for `UpdateMemberRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateMemberRequestDescriptor = $convert.base64Decode(
    'ChNVcGRhdGVNZW1iZXJSZXF1ZXN0Eg4KAmlkGAEgASgFUgJpZBIUCgVlbWFpbBgCIAEoCVIFZW'
    '1haWwSEgoEbmFtZRgDIAEoCVIEbmFtZRIaCghwYXNzd29yZBgEIAEoCVIIcGFzc3dvcmQ=');

@$core.Deprecated('Use memberResponseDescriptor instead')
const MemberResponse$json = {
  '1': 'MemberResponse',
  '2': [
    {'1': 'memberId', '3': 1, '4': 1, '5': 9, '10': 'memberId'},
  ],
};

/// Descriptor for `MemberResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List memberResponseDescriptor = $convert.base64Decode(
    'Cg5NZW1iZXJSZXNwb25zZRIaCghtZW1iZXJJZBgBIAEoCVIIbWVtYmVySWQ=');

@$core.Deprecated('Use getMemberProfileRequestDescriptor instead')
const GetMemberProfileRequest$json = {
  '1': 'GetMemberProfileRequest',
  '2': [
    {'1': 'memberId', '3': 1, '4': 1, '5': 5, '10': 'memberId'},
  ],
};

/// Descriptor for `GetMemberProfileRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getMemberProfileRequestDescriptor =
    $convert.base64Decode(
        'ChdHZXRNZW1iZXJQcm9maWxlUmVxdWVzdBIaCghtZW1iZXJJZBgBIAEoBVIIbWVtYmVySWQ=');

@$core.Deprecated('Use membershipStatusDescriptor instead')
const MembershipStatus$json = {
  '1': 'MembershipStatus',
  '2': [
    {'1': 'isActive', '3': 1, '4': 1, '5': 8, '10': 'isActive'},
    {'1': 'expiryDate', '3': 2, '4': 1, '5': 9, '10': 'expiryDate'},
  ],
};

/// Descriptor for `MembershipStatus`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List membershipStatusDescriptor = $convert.base64Decode(
    'ChBNZW1iZXJzaGlwU3RhdHVzEhoKCGlzQWN0aXZlGAEgASgIUghpc0FjdGl2ZRIeCgpleHBpcn'
    'lEYXRlGAIgASgJUgpleHBpcnlEYXRl');

@$core.Deprecated('Use addTenantRequestDescriptor instead')
const AddTenantRequest$json = {
  '1': 'AddTenantRequest',
  '2': [
    {'1': 'name', '3': 1, '4': 1, '5': 9, '10': 'name'},
    {'1': 'slug', '3': 2, '4': 1, '5': 9, '10': 'slug'},
    {'1': 'address', '3': 3, '4': 1, '5': 9, '10': 'address'},
    {'1': 'isActive', '3': 4, '4': 1, '5': 8, '10': 'isActive'},
  ],
};

/// Descriptor for `AddTenantRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List addTenantRequestDescriptor = $convert.base64Decode(
    'ChBBZGRUZW5hbnRSZXF1ZXN0EhIKBG5hbWUYASABKAlSBG5hbWUSEgoEc2x1ZxgCIAEoCVIEc2'
    'x1ZxIYCgdhZGRyZXNzGAMgASgJUgdhZGRyZXNzEhoKCGlzQWN0aXZlGAQgASgIUghpc0FjdGl2'
    'ZQ==');

@$core.Deprecated('Use updateTenantRequestDescriptor instead')
const UpdateTenantRequest$json = {
  '1': 'UpdateTenantRequest',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 5, '10': 'id'},
    {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
    {'1': 'slug', '3': 3, '4': 1, '5': 9, '10': 'slug'},
    {'1': 'address', '3': 4, '4': 1, '5': 9, '10': 'address'},
    {'1': 'isActive', '3': 5, '4': 1, '5': 8, '10': 'isActive'},
  ],
};

/// Descriptor for `UpdateTenantRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateTenantRequestDescriptor = $convert.base64Decode(
    'ChNVcGRhdGVUZW5hbnRSZXF1ZXN0Eg4KAmlkGAEgASgFUgJpZBISCgRuYW1lGAIgASgJUgRuYW'
    '1lEhIKBHNsdWcYAyABKAlSBHNsdWcSGAoHYWRkcmVzcxgEIAEoCVIHYWRkcmVzcxIaCghpc0Fj'
    'dGl2ZRgFIAEoCFIIaXNBY3RpdmU=');

@$core.Deprecated('Use tenantResponseDescriptor instead')
const TenantResponse$json = {
  '1': 'TenantResponse',
  '2': [
    {'1': 'tenantId', '3': 1, '4': 1, '5': 9, '10': 'tenantId'},
  ],
};

/// Descriptor for `TenantResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List tenantResponseDescriptor = $convert.base64Decode(
    'Cg5UZW5hbnRSZXNwb25zZRIaCgh0ZW5hbnRJZBgBIAEoCVIIdGVuYW50SWQ=');

@$core.Deprecated('Use getTenantRequestDescriptor instead')
const GetTenantRequest$json = {
  '1': 'GetTenantRequest',
  '2': [
    {'1': 'tenantId', '3': 1, '4': 1, '5': 5, '10': 'tenantId'},
  ],
};

/// Descriptor for `GetTenantRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getTenantRequestDescriptor = $convert.base64Decode(
    'ChBHZXRUZW5hbnRSZXF1ZXN0EhoKCHRlbmFudElkGAEgASgFUgh0ZW5hbnRJZA==');

@$core.Deprecated('Use tenantDescriptor instead')
const Tenant$json = {
  '1': 'Tenant',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 5, '10': 'id'},
    {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
    {'1': 'slug', '3': 3, '4': 1, '5': 9, '10': 'slug'},
    {'1': 'address', '3': 4, '4': 1, '5': 9, '10': 'address'},
    {'1': 'isActive', '3': 5, '4': 1, '5': 8, '10': 'isActive'},
    {
      '1': 'createdAt',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'createdAt'
    },
  ],
};

/// Descriptor for `Tenant`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List tenantDescriptor = $convert.base64Decode(
    'CgZUZW5hbnQSDgoCaWQYASABKAVSAmlkEhIKBG5hbWUYAiABKAlSBG5hbWUSEgoEc2x1ZxgDIA'
    'EoCVIEc2x1ZxIYCgdhZGRyZXNzGAQgASgJUgdhZGRyZXNzEhoKCGlzQWN0aXZlGAUgASgIUghp'
    'c0FjdGl2ZRI4CgljcmVhdGVkQXQYBiABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUg'
    'ljcmVhdGVkQXQ=');

@$core.Deprecated('Use addPlanRequestDescriptor instead')
const AddPlanRequest$json = {
  '1': 'AddPlanRequest',
  '2': [
    {'1': 'name', '3': 1, '4': 1, '5': 9, '10': 'name'},
    {'1': 'price', '3': 2, '4': 1, '5': 3, '10': 'price'},
    {'1': 'duration', '3': 3, '4': 1, '5': 5, '10': 'duration'},
    {'1': 'tenantId', '3': 4, '4': 1, '5': 5, '10': 'tenantId'},
  ],
};

/// Descriptor for `AddPlanRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List addPlanRequestDescriptor = $convert.base64Decode(
    'Cg5BZGRQbGFuUmVxdWVzdBISCgRuYW1lGAEgASgJUgRuYW1lEhQKBXByaWNlGAIgASgDUgVwcm'
    'ljZRIaCghkdXJhdGlvbhgDIAEoBVIIZHVyYXRpb24SGgoIdGVuYW50SWQYBCABKAVSCHRlbmFu'
    'dElk');

@$core.Deprecated('Use updatePlanRequestDescriptor instead')
const UpdatePlanRequest$json = {
  '1': 'UpdatePlanRequest',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 5, '10': 'id'},
    {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
    {'1': 'price', '3': 3, '4': 1, '5': 3, '10': 'price'},
    {'1': 'duration', '3': 4, '4': 1, '5': 5, '10': 'duration'},
  ],
};

/// Descriptor for `UpdatePlanRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updatePlanRequestDescriptor = $convert.base64Decode(
    'ChFVcGRhdGVQbGFuUmVxdWVzdBIOCgJpZBgBIAEoBVICaWQSEgoEbmFtZRgCIAEoCVIEbmFtZR'
    'IUCgVwcmljZRgDIAEoA1IFcHJpY2USGgoIZHVyYXRpb24YBCABKAVSCGR1cmF0aW9u');

@$core.Deprecated('Use planResponseDescriptor instead')
const PlanResponse$json = {
  '1': 'PlanResponse',
  '2': [
    {'1': 'planId', '3': 1, '4': 1, '5': 9, '10': 'planId'},
  ],
};

/// Descriptor for `PlanResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List planResponseDescriptor = $convert
    .base64Decode('CgxQbGFuUmVzcG9uc2USFgoGcGxhbklkGAEgASgJUgZwbGFuSWQ=');

@$core.Deprecated('Use getPlanRequestDescriptor instead')
const GetPlanRequest$json = {
  '1': 'GetPlanRequest',
  '2': [
    {'1': 'planId', '3': 1, '4': 1, '5': 5, '10': 'planId'},
  ],
};

/// Descriptor for `GetPlanRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getPlanRequestDescriptor = $convert
    .base64Decode('Cg5HZXRQbGFuUmVxdWVzdBIWCgZwbGFuSWQYASABKAVSBnBsYW5JZA==');

@$core.Deprecated('Use planDescriptor instead')
const Plan$json = {
  '1': 'Plan',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 5, '10': 'id'},
    {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
    {'1': 'price', '3': 3, '4': 1, '5': 3, '10': 'price'},
    {'1': 'duration', '3': 4, '4': 1, '5': 5, '10': 'duration'},
    {'1': 'tenantId', '3': 5, '4': 1, '5': 5, '10': 'tenantId'},
    {
      '1': 'tenant',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.app.Tenant',
      '10': 'tenant'
    },
  ],
};

/// Descriptor for `Plan`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List planDescriptor = $convert.base64Decode(
    'CgRQbGFuEg4KAmlkGAEgASgFUgJpZBISCgRuYW1lGAIgASgJUgRuYW1lEhQKBXByaWNlGAMgAS'
    'gDUgVwcmljZRIaCghkdXJhdGlvbhgEIAEoBVIIZHVyYXRpb24SGgoIdGVuYW50SWQYBSABKAVS'
    'CHRlbmFudElkEiMKBnRlbmFudBgGIAEoCzILLmFwcC5UZW5hbnRSBnRlbmFudA==');

@$core.Deprecated('Use membershipDescriptor instead')
const Membership$json = {
  '1': 'Membership',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 5, '10': 'id'},
    {'1': 'userId', '3': 2, '4': 1, '5': 5, '10': 'userId'},
    {'1': 'plan', '3': 3, '4': 1, '5': 11, '6': '.app.Plan', '10': 'plan'},
    {'1': 'status', '3': 4, '4': 1, '5': 9, '10': 'status'},
    {
      '1': 'startDate',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'startDate'
    },
    {
      '1': 'endDate',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'endDate'
    },
    {
      '1': 'offering',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.app.Offering',
      '10': 'offering'
    },
    {'1': 'planId', '3': 8, '4': 1, '5': 5, '10': 'planId'},
    {'1': 'offeringId', '3': 9, '4': 1, '5': 5, '10': 'offeringId'},
  ],
};

/// Descriptor for `Membership`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List membershipDescriptor = $convert.base64Decode(
    'CgpNZW1iZXJzaGlwEg4KAmlkGAEgASgFUgJpZBIWCgZ1c2VySWQYAiABKAVSBnVzZXJJZBIdCg'
    'RwbGFuGAMgASgLMgkuYXBwLlBsYW5SBHBsYW4SFgoGc3RhdHVzGAQgASgJUgZzdGF0dXMSOAoJ'
    'c3RhcnREYXRlGAUgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIJc3RhcnREYXRlEj'
    'QKB2VuZERhdGUYBiABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUgdlbmREYXRlEikK'
    'CG9mZmVyaW5nGAcgASgLMg0uYXBwLk9mZmVyaW5nUghvZmZlcmluZxIWCgZwbGFuSWQYCCABKA'
    'VSBnBsYW5JZBIeCgpvZmZlcmluZ0lkGAkgASgFUgpvZmZlcmluZ0lk');

@$core.Deprecated('Use createTransactionRequestDescriptor instead')
const CreateTransactionRequest$json = {
  '1': 'CreateTransactionRequest',
  '2': [
    {'1': 'memberId', '3': 1, '4': 1, '5': 5, '10': 'memberId'},
    {'1': 'planId', '3': 2, '4': 1, '5': 5, '9': 0, '10': 'planId', '17': true},
    {
      '1': 'offeringId',
      '3': 3,
      '4': 1,
      '5': 5,
      '9': 1,
      '10': 'offeringId',
      '17': true
    },
    {'1': 'method', '3': 4, '4': 1, '5': 9, '10': 'method'},
  ],
  '8': [
    {'1': '_planId'},
    {'1': '_offeringId'},
  ],
};

/// Descriptor for `CreateTransactionRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createTransactionRequestDescriptor = $convert.base64Decode(
    'ChhDcmVhdGVUcmFuc2FjdGlvblJlcXVlc3QSGgoIbWVtYmVySWQYASABKAVSCG1lbWJlcklkEh'
    'sKBnBsYW5JZBgCIAEoBUgAUgZwbGFuSWSIAQESIwoKb2ZmZXJpbmdJZBgDIAEoBUgBUgpvZmZl'
    'cmluZ0lkiAEBEhYKBm1ldGhvZBgEIAEoCVIGbWV0aG9kQgkKB19wbGFuSWRCDQoLX29mZmVyaW'
    '5nSWQ=');

@$core.Deprecated('Use getTransactionsRequestDescriptor instead')
const GetTransactionsRequest$json = {
  '1': 'GetTransactionsRequest',
  '2': [
    {
      '1': 'tenantId',
      '3': 1,
      '4': 1,
      '5': 5,
      '9': 0,
      '10': 'tenantId',
      '17': true
    },
    {
      '1': 'startDate',
      '3': 2,
      '4': 1,
      '5': 9,
      '9': 1,
      '10': 'startDate',
      '17': true
    },
    {
      '1': 'endDate',
      '3': 3,
      '4': 1,
      '5': 9,
      '9': 2,
      '10': 'endDate',
      '17': true
    },
  ],
  '8': [
    {'1': '_tenantId'},
    {'1': '_startDate'},
    {'1': '_endDate'},
  ],
};

/// Descriptor for `GetTransactionsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getTransactionsRequestDescriptor = $convert.base64Decode(
    'ChZHZXRUcmFuc2FjdGlvbnNSZXF1ZXN0Eh8KCHRlbmFudElkGAEgASgFSABSCHRlbmFudElkiA'
    'EBEiEKCXN0YXJ0RGF0ZRgCIAEoCUgBUglzdGFydERhdGWIAQESHQoHZW5kRGF0ZRgDIAEoCUgC'
    'UgdlbmREYXRliAEBQgsKCV90ZW5hbnRJZEIMCgpfc3RhcnREYXRlQgoKCF9lbmREYXRl');

@$core.Deprecated('Use getTransactionRequestDescriptor instead')
const GetTransactionRequest$json = {
  '1': 'GetTransactionRequest',
  '2': [
    {'1': 'transactionId', '3': 1, '4': 1, '5': 9, '10': 'transactionId'},
  ],
};

/// Descriptor for `GetTransactionRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getTransactionRequestDescriptor = $convert.base64Decode(
    'ChVHZXRUcmFuc2FjdGlvblJlcXVlc3QSJAoNdHJhbnNhY3Rpb25JZBgBIAEoCVINdHJhbnNhY3'
    'Rpb25JZA==');

@$core.Deprecated('Use financeSummaryDescriptor instead')
const FinanceSummary$json = {
  '1': 'FinanceSummary',
  '2': [
    {'1': 'totalRevenue', '3': 1, '4': 1, '5': 3, '10': 'totalRevenue'},
    {
      '1': 'totalTransactions',
      '3': 2,
      '4': 1,
      '5': 5,
      '10': 'totalTransactions'
    },
    {
      '1': 'activeMemberships',
      '3': 3,
      '4': 1,
      '5': 5,
      '10': 'activeMemberships'
    },
  ],
};

/// Descriptor for `FinanceSummary`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List financeSummaryDescriptor = $convert.base64Decode(
    'Cg5GaW5hbmNlU3VtbWFyeRIiCgx0b3RhbFJldmVudWUYASABKANSDHRvdGFsUmV2ZW51ZRIsCh'
    'F0b3RhbFRyYW5zYWN0aW9ucxgCIAEoBVIRdG90YWxUcmFuc2FjdGlvbnMSLAoRYWN0aXZlTWVt'
    'YmVyc2hpcHMYAyABKAVSEWFjdGl2ZU1lbWJlcnNoaXBz');

@$core.Deprecated('Use transactionDescriptor instead')
const Transaction$json = {
  '1': 'Transaction',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'memberId', '3': 2, '4': 1, '5': 5, '10': 'memberId'},
    {'1': 'planId', '3': 3, '4': 1, '5': 5, '9': 0, '10': 'planId', '17': true},
    {'1': 'amount', '3': 4, '4': 1, '5': 3, '10': 'amount'},
    {'1': 'method', '3': 5, '4': 1, '5': 9, '10': 'method'},
    {'1': 'status', '3': 6, '4': 1, '5': 9, '10': 'status'},
    {'1': 'qrisUrl', '3': 7, '4': 1, '5': 9, '10': 'qrisUrl'},
    {
      '1': 'createdAt',
      '3': 8,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'createdAt'
    },
    {
      '1': 'memberName',
      '3': 9,
      '4': 1,
      '5': 9,
      '9': 1,
      '10': 'memberName',
      '17': true
    },
    {
      '1': 'planName',
      '3': 10,
      '4': 1,
      '5': 9,
      '9': 2,
      '10': 'planName',
      '17': true
    },
    {
      '1': 'offeringId',
      '3': 11,
      '4': 1,
      '5': 5,
      '9': 3,
      '10': 'offeringId',
      '17': true
    },
    {
      '1': 'offeringName',
      '3': 12,
      '4': 1,
      '5': 9,
      '9': 4,
      '10': 'offeringName',
      '17': true
    },
  ],
  '8': [
    {'1': '_planId'},
    {'1': '_memberName'},
    {'1': '_planName'},
    {'1': '_offeringId'},
    {'1': '_offeringName'},
  ],
};

/// Descriptor for `Transaction`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List transactionDescriptor = $convert.base64Decode(
    'CgtUcmFuc2FjdGlvbhIOCgJpZBgBIAEoCVICaWQSGgoIbWVtYmVySWQYAiABKAVSCG1lbWJlck'
    'lkEhsKBnBsYW5JZBgDIAEoBUgAUgZwbGFuSWSIAQESFgoGYW1vdW50GAQgASgDUgZhbW91bnQS'
    'FgoGbWV0aG9kGAUgASgJUgZtZXRob2QSFgoGc3RhdHVzGAYgASgJUgZzdGF0dXMSGAoHcXJpc1'
    'VybBgHIAEoCVIHcXJpc1VybBI4CgljcmVhdGVkQXQYCCABKAsyGi5nb29nbGUucHJvdG9idWYu'
    'VGltZXN0YW1wUgljcmVhdGVkQXQSIwoKbWVtYmVyTmFtZRgJIAEoCUgBUgptZW1iZXJOYW1liA'
    'EBEh8KCHBsYW5OYW1lGAogASgJSAJSCHBsYW5OYW1liAEBEiMKCm9mZmVyaW5nSWQYCyABKAVI'
    'A1IKb2ZmZXJpbmdJZIgBARInCgxvZmZlcmluZ05hbWUYDCABKAlIBFIMb2ZmZXJpbmdOYW1liA'
    'EBQgkKB19wbGFuSWRCDQoLX21lbWJlck5hbWVCCwoJX3BsYW5OYW1lQg0KC19vZmZlcmluZ0lk'
    'Qg8KDV9vZmZlcmluZ05hbWU=');

@$core.Deprecated('Use addOfferingRequestDescriptor instead')
const AddOfferingRequest$json = {
  '1': 'AddOfferingRequest',
  '2': [
    {'1': 'name', '3': 1, '4': 1, '5': 9, '10': 'name'},
    {'1': 'price', '3': 2, '4': 1, '5': 3, '10': 'price'},
    {'1': 'type', '3': 3, '4': 1, '5': 9, '10': 'type'},
    {'1': 'duration', '3': 4, '4': 1, '5': 5, '10': 'duration'},
    {'1': 'stock', '3': 5, '4': 1, '5': 5, '10': 'stock'},
    {'1': 'quota', '3': 6, '4': 1, '5': 5, '10': 'quota'},
    {'1': 'tenantId', '3': 7, '4': 1, '5': 5, '10': 'tenantId'},
  ],
};

/// Descriptor for `AddOfferingRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List addOfferingRequestDescriptor = $convert.base64Decode(
    'ChJBZGRPZmZlcmluZ1JlcXVlc3QSEgoEbmFtZRgBIAEoCVIEbmFtZRIUCgVwcmljZRgCIAEoA1'
    'IFcHJpY2USEgoEdHlwZRgDIAEoCVIEdHlwZRIaCghkdXJhdGlvbhgEIAEoBVIIZHVyYXRpb24S'
    'FAoFc3RvY2sYBSABKAVSBXN0b2NrEhQKBXF1b3RhGAYgASgFUgVxdW90YRIaCgh0ZW5hbnRJZB'
    'gHIAEoBVIIdGVuYW50SWQ=');

@$core.Deprecated('Use updateOfferingRequestDescriptor instead')
const UpdateOfferingRequest$json = {
  '1': 'UpdateOfferingRequest',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 5, '10': 'id'},
    {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
    {'1': 'price', '3': 3, '4': 1, '5': 3, '10': 'price'},
    {'1': 'type', '3': 4, '4': 1, '5': 9, '10': 'type'},
    {'1': 'duration', '3': 5, '4': 1, '5': 5, '10': 'duration'},
    {'1': 'stock', '3': 6, '4': 1, '5': 5, '10': 'stock'},
    {'1': 'quota', '3': 7, '4': 1, '5': 5, '10': 'quota'},
  ],
};

/// Descriptor for `UpdateOfferingRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateOfferingRequestDescriptor = $convert.base64Decode(
    'ChVVcGRhdGVPZmZlcmluZ1JlcXVlc3QSDgoCaWQYASABKAVSAmlkEhIKBG5hbWUYAiABKAlSBG'
    '5hbWUSFAoFcHJpY2UYAyABKANSBXByaWNlEhIKBHR5cGUYBCABKAlSBHR5cGUSGgoIZHVyYXRp'
    'b24YBSABKAVSCGR1cmF0aW9uEhQKBXN0b2NrGAYgASgFUgVzdG9jaxIUCgVxdW90YRgHIAEoBV'
    'IFcXVvdGE=');

@$core.Deprecated('Use offeringResponseDescriptor instead')
const OfferingResponse$json = {
  '1': 'OfferingResponse',
  '2': [
    {'1': 'offeringId', '3': 1, '4': 1, '5': 5, '10': 'offeringId'},
  ],
};

/// Descriptor for `OfferingResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List offeringResponseDescriptor = $convert.base64Decode(
    'ChBPZmZlcmluZ1Jlc3BvbnNlEh4KCm9mZmVyaW5nSWQYASABKAVSCm9mZmVyaW5nSWQ=');

@$core.Deprecated('Use getOfferingRequestDescriptor instead')
const GetOfferingRequest$json = {
  '1': 'GetOfferingRequest',
  '2': [
    {'1': 'offeringId', '3': 1, '4': 1, '5': 5, '10': 'offeringId'},
  ],
};

/// Descriptor for `GetOfferingRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getOfferingRequestDescriptor = $convert.base64Decode(
    'ChJHZXRPZmZlcmluZ1JlcXVlc3QSHgoKb2ZmZXJpbmdJZBgBIAEoBVIKb2ZmZXJpbmdJZA==');

@$core.Deprecated('Use offeringDescriptor instead')
const Offering$json = {
  '1': 'Offering',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 5, '10': 'id'},
    {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
    {'1': 'price', '3': 3, '4': 1, '5': 3, '10': 'price'},
    {'1': 'type', '3': 4, '4': 1, '5': 9, '10': 'type'},
    {'1': 'duration', '3': 5, '4': 1, '5': 5, '10': 'duration'},
    {'1': 'stock', '3': 6, '4': 1, '5': 5, '10': 'stock'},
    {'1': 'quota', '3': 7, '4': 1, '5': 5, '10': 'quota'},
    {'1': 'tenantId', '3': 8, '4': 1, '5': 5, '10': 'tenantId'},
  ],
};

/// Descriptor for `Offering`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List offeringDescriptor = $convert.base64Decode(
    'CghPZmZlcmluZxIOCgJpZBgBIAEoBVICaWQSEgoEbmFtZRgCIAEoCVIEbmFtZRIUCgVwcmljZR'
    'gDIAEoA1IFcHJpY2USEgoEdHlwZRgEIAEoCVIEdHlwZRIaCghkdXJhdGlvbhgFIAEoBVIIZHVy'
    'YXRpb24SFAoFc3RvY2sYBiABKAVSBXN0b2NrEhQKBXF1b3RhGAcgASgFUgVxdW90YRIaCgh0ZW'
    '5hbnRJZBgIIAEoBVIIdGVuYW50SWQ=');

@$core.Deprecated('Use checkInRequestDescriptor instead')
const CheckInRequest$json = {
  '1': 'CheckInRequest',
  '2': [
    {'1': 'memberId', '3': 1, '4': 1, '5': 9, '10': 'memberId'},
  ],
};

/// Descriptor for `CheckInRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List checkInRequestDescriptor = $convert.base64Decode(
    'Cg5DaGVja0luUmVxdWVzdBIaCghtZW1iZXJJZBgBIAEoCVIIbWVtYmVySWQ=');

@$core.Deprecated('Use checkInResponseDescriptor instead')
const CheckInResponse$json = {
  '1': 'CheckInResponse',
  '2': [
    {'1': 'checkInId', '3': 1, '4': 1, '5': 9, '10': 'checkInId'},
    {'1': 'timestamp', '3': 2, '4': 1, '5': 9, '10': 'timestamp'},
  ],
};

/// Descriptor for `CheckInResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List checkInResponseDescriptor = $convert.base64Decode(
    'Cg9DaGVja0luUmVzcG9uc2USHAoJY2hlY2tJbklkGAEgASgJUgljaGVja0luSWQSHAoJdGltZX'
    'N0YW1wGAIgASgJUgl0aW1lc3RhbXA=');

@$core.Deprecated('Use getAttendanceHistoryRequestDescriptor instead')
const GetAttendanceHistoryRequest$json = {
  '1': 'GetAttendanceHistoryRequest',
  '2': [
    {'1': 'memberId', '3': 1, '4': 1, '5': 9, '10': 'memberId'},
  ],
};

/// Descriptor for `GetAttendanceHistoryRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getAttendanceHistoryRequestDescriptor =
    $convert.base64Decode(
        'ChtHZXRBdHRlbmRhbmNlSGlzdG9yeVJlcXVlc3QSGgoIbWVtYmVySWQYASABKAlSCG1lbWJlck'
        'lk');

@$core.Deprecated('Use attendanceRecordDescriptor instead')
const AttendanceRecord$json = {
  '1': 'AttendanceRecord',
  '2': [
    {'1': 'checkInId', '3': 1, '4': 1, '5': 9, '10': 'checkInId'},
    {'1': 'timestamp', '3': 2, '4': 1, '5': 9, '10': 'timestamp'},
  ],
};

/// Descriptor for `AttendanceRecord`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List attendanceRecordDescriptor = $convert.base64Decode(
    'ChBBdHRlbmRhbmNlUmVjb3JkEhwKCWNoZWNrSW5JZBgBIAEoCVIJY2hlY2tJbklkEhwKCXRpbW'
    'VzdGFtcBgCIAEoCVIJdGltZXN0YW1w');

@$core.Deprecated('Use attendanceHistoryDescriptor instead')
const AttendanceHistory$json = {
  '1': 'AttendanceHistory',
  '2': [
    {
      '1': 'records',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.app.AttendanceRecord',
      '10': 'records'
    },
  ],
};

/// Descriptor for `AttendanceHistory`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List attendanceHistoryDescriptor = $convert.base64Decode(
    'ChFBdHRlbmRhbmNlSGlzdG9yeRIvCgdyZWNvcmRzGAEgAygLMhUuYXBwLkF0dGVuZGFuY2VSZW'
    'NvcmRSB3JlY29yZHM=');
