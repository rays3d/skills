import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class MembershipDetails {
  final String planType;
  final DateTime expiresAt;

  MembershipDetails({required this.planType, required this.expiresAt});

  factory MembershipDetails.fromJson(Map<String, dynamic> json) =>
      _$MembershipDetailsFromJson(json);

  Map<String, dynamic> toJson() => _$MembershipDetailsToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class UserModel {
  final int id;
  final String fullName;
  final bool isVerified;
  final MembershipDetails membershipDetails;
  final List<String> tags;
  final String? bio;

  UserModel({
    required this.id,
    required this.fullName,
    required this.isVerified,
    required this.membershipDetails,
    required this.tags,
    this.bio,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}
