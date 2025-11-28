import 'user.dart';
import 'membership.dart';

class LoginResponse {
  final String token;
  final User user;
  final Membership membership;

  LoginResponse({
    required this.token,
    required this.user,
    required this.membership,
  });

  // Create from individual components
  factory LoginResponse.create({
    required String token,
    required Map<String, dynamic> userJson,
    required Map<String, dynamic> membershipJson,
  }) {
    return LoginResponse(
      token: token,
      user: User.fromJson(userJson),
      membership: Membership.fromJson(membershipJson),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'user': user.toJson(),
      'membership': membership.toJson(),
    };
  }

  @override
  String toString() {
    return 'LoginResponse(token: ${token.substring(0, 10)}..., user: ${user.displayName}, membership: ${membership.currentPlan})';
  }
}