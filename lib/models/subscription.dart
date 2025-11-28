class Subscription {
  final String subscriptionId;
  final int planId;
  final String planName;
  final String status;
  final DateTime? expirationDate;
  final DateTime? startDate;

  Subscription({
    required this.subscriptionId,
    required this.planId,
    required this.planName,
    required this.status,
    this.expirationDate,
    this.startDate,
  });

  // Create Subscription from JSON
  factory Subscription.fromJson(Map<String, dynamic> json) {
    return Subscription(
      subscriptionId: json['subscription_id']?.toString() ?? '',
      planId: _parsePlanId(json['plan_id']),
      planName: json['plan_name']?.toString() ?? 'Unknown',
      status: json['status']?.toString() ?? '',
      expirationDate: _parseDate(json['expiration_date']),
      startDate: _parseDate(json['start_date']),
    );
  }

  // Parse plan ID from various formats
  static int _parsePlanId(dynamic planId) {
    if (planId is int) return planId;
    if (planId is String) return int.tryParse(planId) ?? 0;
    return 0;
  }

  // Parse date string to DateTime
  static DateTime? _parseDate(dynamic dateStr) {
    if (dateStr == null || dateStr.toString().isEmpty) return null;
    return DateTime.tryParse(dateStr.toString());
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'subscription_id': subscriptionId,
      'plan_id': planId,
      'plan_name': planName,
      'status': status,
      'expiration_date': expirationDate?.toIso8601String(),
      'start_date': startDate?.toIso8601String(),
    };
  }

  // Check if subscription is active
  bool get isActive => status.toLowerCase() == 'active';

  // Check if subscription is valid (Bronze, Silver, Gold)
  bool get isValidPlan => [2831, 2832, 2833].contains(planId);

  // Get days left until expiration
  int get daysLeft {
    if (expirationDate == null) return 0;
    return expirationDate!.difference(DateTime.now()).inDays;
  }

  // Check if subscription is expired
  bool get isExpired {
    if (expirationDate == null) return false;
    return DateTime.now().isAfter(expirationDate!);
  }

  // Get plan type
  String get planType {
    switch (planId) {
      case 2831:
        return 'Bronze';
      case 2832:
        return 'Silver';
      case 2833:
        return 'Gold';
      default:
        return planName;
    }
  }

  @override
  String toString() {
    return 'Subscription(id: $subscriptionId, plan: $planName, status: $status, expires: $expirationDate)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Subscription && other.subscriptionId == subscriptionId;
  }

  @override
  int get hashCode {
    return subscriptionId.hashCode;
  }
}