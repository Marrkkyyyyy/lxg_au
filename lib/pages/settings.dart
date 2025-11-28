import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:lxg_au/constant/app_constant.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _notifications = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _notifications = prefs.getBool('notifications') ?? true;
    });
  }

  Future<void> _updateNotifications(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _notifications = value;
      prefs.setBool('notifications', value);
    });
  }

  Future<void> _openSupportEmail() async {
    const email = 'support@lxgau.com.au';
    const subject = 'Support Request';

    // Try different URL formats
    final List<String> urlFormats = ['mailto:$email?subject=${Uri.encodeComponent(subject)}', 'mailto:$email'];

    bool launched = false;

    for (final urlString in urlFormats) {
      try {
        final uri = Uri.parse(urlString);
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
          launched = true;
          break;
        }
      } catch (e) {
        print('Failed to launch $urlString: $e');
        continue;
      }
    }

    if (!launched && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Could not open email client. Please contact support@lxgau.com.au'),
          backgroundColor: Colors.red.withOpacity(0.8),
          duration: const Duration(seconds: 4),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 120),
          child: Column(
            children: [
              // Logo
              Image.asset(AppConstant.logo, height: 120),
              const SizedBox(height: 24),

              // Header section
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(color: const Color(0xFFFEC404).withOpacity(0.2), borderRadius: BorderRadius.circular(12)),
                        child: const Icon(CupertinoIcons.settings, color: Color(0xFFFEC404), size: 20),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Settings',
                        style: TextStyle(fontSize: 26, fontWeight: FontWeight.w700, color: Colors.white.withOpacity(0.95), letterSpacing: -0.5),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Customize your app preferences',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: Colors.white.withOpacity(0.7), height: 1.4),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Settings Cards
              _buildSettingsCard(
                icon: CupertinoIcons.bell_fill,
                title: 'Notifications',
                subtitle: 'Manage push notifications',
                trailing: CupertinoSwitch(value: _notifications, onChanged: _updateNotifications, activeTrackColor: const Color(0xFFFEC404)),
              ),

              const SizedBox(height: 16),

              _buildSettingsCard(
                icon: CupertinoIcons.mail,
                title: 'Contact Support',
                subtitle: 'Get help from our support team',
                trailing: const Icon(CupertinoIcons.chevron_forward, color: Colors.white54, size: 16),
                onTap: _openSupportEmail,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsCard({required IconData icon, required String title, required String subtitle, Widget? trailing, VoidCallback? onTap}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 20, offset: const Offset(0, 8))],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: const Color(0xFFFEC404).withOpacity(0.2), borderRadius: BorderRadius.circular(12)),
                  child: Icon(icon, color: const Color(0xFFFEC404), size: 20),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white.withOpacity(0.95), letterSpacing: -0.3),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Colors.white.withOpacity(0.6)),
                      ),
                    ],
                  ),
                ),
                if (trailing != null) ...[const SizedBox(width: 16), trailing],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
