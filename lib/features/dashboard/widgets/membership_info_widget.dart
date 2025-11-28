import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../models/models.dart';
import '../../../config/api_urls.dart';

class MembershipInfoWidget extends StatelessWidget {
  final String plan;
  final int daysLeft;
  final DateTime? expireDate;
  final Membership? membership;
  final bool showUpgrade;
  final VoidCallback onUpgradePressed;

  const MembershipInfoWidget({
    super.key,
    required this.plan,
    required this.daysLeft,
    this.expireDate,
    this.membership,
    required this.showUpgrade,
    required this.onUpgradePressed,
  });

  Color _getPlanColor() {
    switch (plan.toLowerCase()) {
      case 'gold':
        return const Color(0xFFFFD700);
      case 'silver':
        return const Color(0xFFC0C0C0);
      case 'bronze':
        return const Color(0xFFCD7F32);
      default:
        return Colors.grey;
    }
  }

  IconData _getPlanIcon() {
    switch (plan.toLowerCase()) {
      case 'gold':
        return CupertinoIcons.star_fill;
      case 'silver':
        return CupertinoIcons.star;
      case 'bronze':
        return CupertinoIcons.circle_fill;
      default:
        return CupertinoIcons.circle;
    }
  }

  @override
  Widget build(BuildContext context) {
    final planColor = _getPlanColor();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 20, offset: const Offset(0, 8))],
      ),
      child: Column(
        children: [
          if (plan.toLowerCase() != 'none' && plan.isNotEmpty)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(color: planColor.withOpacity(0.2), borderRadius: BorderRadius.circular(12)),
                      child: Icon(_getPlanIcon(), color: planColor, size: 18),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      '$plan Plan',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: planColor, letterSpacing: -0.5),
                    ),
                  ],
                ),
                if (membership?.isMember == true && expireDate != null)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: daysLeft > 7 ? const Color(0xFF34C759).withOpacity(0.2) : const Color(0xFFFF9500).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: daysLeft > 7 ? const Color(0xFF34C759).withOpacity(0.4) : const Color(0xFFFF9500).withOpacity(0.4),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(CupertinoIcons.time, color: daysLeft > 7 ? const Color(0xFF34C759) : const Color(0xFFFF9500), size: 14),
                        const SizedBox(width: 6),
                        Text(
                          '${daysLeft}d left',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: daysLeft > 7 ? const Color(0xFF34C759) : const Color(0xFFFF9500),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          if (showUpgrade) ...[
            if (plan.toLowerCase() != 'none' && plan.isNotEmpty)
              const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFEC404), Color(0xFFFFD700)],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [BoxShadow(color: const Color(0xFFFEC404).withOpacity(0.4), blurRadius: 12, offset: const Offset(0, 4))],
                ),
                child: ElevatedButton(
                  onPressed: onUpgradePressed,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(CupertinoIcons.arrow_up_circle, color: Colors.black, size: 18),
                      const SizedBox(width: 8),
                      const Text(
                        'Upgrade Membership',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
          // Add cancel membership option for active members
          if (membership?.isMember == true) ...[
            const SizedBox(height: 12),
            Container(
              height: 40,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.red.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: TextButton(
                onPressed: () => _showCancelDialog(context),
                style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(CupertinoIcons.xmark_circle, color: Colors.red, size: 16),
                    SizedBox(width: 6),
                    Text(
                      'Manage Membership',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _showCancelDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.7),
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.8),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(50),
                  border: Border.all(
                    color: Colors.red.withOpacity(0.3),
                    width: 2,
                  ),
                ),
                child: const Icon(
                  CupertinoIcons.exclamationmark_triangle,
                  color: Colors.red,
                  size: 28,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Manage Membership',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: Colors.white.withOpacity(0.95),
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'You will be redirected to the membership management page where you can cancel your subscription.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Colors.white.withOpacity(0.7),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 48,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.2),
                          width: 1,
                        ),
                      ),
                      child: TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        style: TextButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: Text(
                          'Cancel',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white.withOpacity(0.8),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      height: 48,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFFFF3B30), Color(0xFFFF6B6B)],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFFF3B30).withOpacity(0.4),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: TextButton(
                        onPressed: () async {
                          Navigator.of(context).pop();
                          await _cancelMembership(context);
                        },
                        style: TextButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: const Text(
                          'Continue',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _cancelMembership(BuildContext context) async {
    const url = ApiUrls.cancelSubscription;
    try {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        await launchUrl(uri, mode: LaunchMode.platformDefault);
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Could not open membership management page'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }
}
