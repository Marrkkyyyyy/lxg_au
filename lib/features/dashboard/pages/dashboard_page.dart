import 'package:flutter/material.dart';
import 'package:lxg_au/constant/app_constant.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../services/lxg_api_service.dart';
import '../../../config/api_urls.dart';
import '../../../models/models.dart';
import '../widgets/user_profile_widget.dart';
import '../widgets/membership_info_widget.dart';
import '../widgets/entries_list_widget.dart';

class DashboardPage extends StatefulWidget {
  final User? initialUser;
  final Membership? initialMembership;

  const DashboardPage({super.key, this.initialUser, this.initialMembership});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  User? user;
  Entries? entriesData;
  Membership? membership;
  bool isLoadingEntries = true;

  @override
  void initState() {
    super.initState();
    user = widget.initialUser;
    membership = widget.initialMembership;
    fetchData();
  }

  Future<void> fetchData() async {
    setState(() => isLoadingEntries = true);

    try {
      // Only fetch user and membership if not already provided
      if (user == null) {
        user = await ApiService.getMe();
        print('Fetched user data from API');
      }

      if (membership == null) {
        membership = await ApiService.getMemberStatus();
        print('Fetched membership data from API');
      }

      // Always fetch entries (they change frequently)
      entriesData = await ApiService.getEntries();
      print('Fetched entries data from API');
      print('Membership: $membership');
    } catch (e) {
      print('Error fetching data: $e');
    }

    if (!mounted) return;
    setState(() => isLoadingEntries = false);
  }

  Future<void> _handleUpgradeMembership() async {
    const url = ApiUrls.membershipUpgrade;
    try {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        await launchUrl(uri, mode: LaunchMode.platformDefault);
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Could not open membership page'), behavior: SnackBarBehavior.floating));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (user == null) {
      return const Center(
        child: Text('Failed to fetch user', style: TextStyle(color: Colors.white)),
      );
    }

    // Get membership info from model
    final plan = membership?.currentPlan ?? 'None';
    final daysLeft = membership?.daysLeft ?? 0;
    final expireDate = membership?.expirationDate;
    final showUpgrade = membership?.shouldShowUpgrade ?? true;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 120),
          child: Column(
            children: [
              // Logo
              Image.asset(AppConstant.logo, height: 120),
              const SizedBox(height: 24),

              UserProfileWidget(user: user!, membership: membership),

              const SizedBox(height: 20),

              MembershipInfoWidget(
                plan: plan,
                daysLeft: daysLeft,
                expireDate: expireDate,
                membership: membership,
                showUpgrade: showUpgrade,
                onUpgradePressed: _handleUpgradeMembership,
              ),

              const SizedBox(height: 20),

              EntriesListWidget(entries: entriesData, isLoading: isLoadingEntries),
            ],
          ),
        ),
      ),
    );
  }
}
