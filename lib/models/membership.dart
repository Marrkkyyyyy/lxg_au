import 'subscription.dart';

class Membership {
  final bool isMember;
  final List<Subscription> subscriptions;

  Membership({
    required this.isMember,
    required this.subscriptions,
  });

  // Create Membership from JSON
  factory Membership.fromJson(Map<String, dynamic> json) {
    // Parse subscriptions list
    List<Subscription> subscriptions = [];
    if (json['subscriptions'] is List) {
      subscriptions = (json['subscriptions'] as List)
          .map((subJson) => Subscription.fromJson(subJson))
          .where((sub) => sub.isValidPlan && sub.isActive)
          .toList();

      // Sort by expiration date (latest first)
      subscriptions.sort((a, b) {
        final dateA = a.expirationDate ?? DateTime.now();
        final dateB = b.expirationDate ?? DateTime.now();
        return dateB.compareTo(dateA);
      });
    }

    // Determine if user is a member based on active subscriptions
    bool isMember = subscriptions.isNotEmpty;

    return Membership(
      isMember: isMember,
      subscriptions: isMember ? [subscriptions.first] : [],
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'is_member': isMember,
      'subscriptions': subscriptions.map((sub) => sub.toJson()).toList(),
    };
  }

  // Get current active subscription
  Subscription? get currentSubscription {
    return subscriptions.isNotEmpty ? subscriptions.first : null;
  }

  // Get current plan name
  String get currentPlan {
    return currentSubscription?.planType ?? 'None';
  }

  // Get days left for current subscription
  int get daysLeft {
    return currentSubscription?.daysLeft ?? 0;
  }

  // Get expiration date for current subscription
  DateTime? get expirationDate {
    return currentSubscription?.expirationDate;
  }

  // Check if user should see upgrade button
  bool get shouldShowUpgrade {
    if (!isMember) return true;
    return currentPlan.toLowerCase() != 'gold';
  }

  // Check if membership is expired
  bool get isExpired {
    return currentSubscription?.isExpired ?? false;
  }

  // Create empty membership
  static Membership empty() {
    return Membership(
      isMember: false,
      subscriptions: [],
    );
  }

  @override
  String toString() {
    return 'Membership(isMember: $isMember, plan: $currentPlan, subscriptions: ${subscriptions.length})';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Membership && 
           other.isMember == isMember && 
           other.subscriptions.length == subscriptions.length;
  }

  @override
  int get hashCode {
    return isMember.hashCode ^ subscriptions.length.hashCode;
  }
}