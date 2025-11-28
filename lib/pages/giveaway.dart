import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:lxg_au/constant/app_constant.dart';
import 'package:url_launcher/url_launcher.dart';
import '../config/api_urls.dart';

class GiveawaysPage extends StatefulWidget {
  const GiveawaysPage({super.key});

  @override
  State<GiveawaysPage> createState() => _GiveawaysPageState();
}

class _GiveawaysPageState extends State<GiveawaysPage> {
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
                        child: const Icon(CupertinoIcons.gift_fill, color: Color(0xFFFEC404), size: 20),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Our Giveaways',
                        style: TextStyle(fontSize: 26, fontWeight: FontWeight.w700, color: Colors.white.withOpacity(0.95), letterSpacing: -0.5),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Join any draw now, x5 entries are now active, GOODLUCK!',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: Colors.white.withOpacity(0.7), height: 1.4),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Giveaway cards
              _giveawayCard(
                title: "Win this 2019 Mercedes Benz AMG GT63S or \$250,000 CASH!",
                subtitle: "capped at 15,000 entrant's only",
                progress: 0.62,
                imagePath: "assets/images/GT63S.jpg",
                buttonText: "ENTER NOW!",
                link: ApiUrls.mercedesBenzGiveaway,
              ),

              _giveawayCard(
                title: "Win this Fortuner Crusade or \$40,000 CASH!!",
                subtitle: "capped at 2500 entrant's only",
                progress: 0.41,
                imagePath: "assets/images/TYT2.jpg",
                buttonText: "ENTER NOW!",
                link: ApiUrls.fortunerGiveaway,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _giveawayCard({
    required String title,
    required String subtitle,
    required double progress,
    required String imagePath,
    required String buttonText,
    required String link,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 20, offset: const Offset(0, 8))],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Car image with glassmorphism overlay
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
              ),
              child: Stack(
                children: [
                  Image.asset(imagePath, width: double.infinity, height: 200, fit: BoxFit.cover),
                  // Gradient overlay
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
                      ),
                    ),
                  ),
                  // Progress badge overlay
                  Positioned(
                    top: 16,
                    right: 16,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFFEC404).withOpacity(0.3), width: 1),
                      ),
                      child: Text(
                        '${(progress * 100).toStringAsFixed(0)}% filled',
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFFFEC404)),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Content section
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Progress bar
                  Container(
                    height: 6,
                    decoration: BoxDecoration(color: Colors.white.withOpacity(0.1), borderRadius: BorderRadius.circular(3)),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(3),
                      child: LinearProgressIndicator(
                        value: progress,
                        backgroundColor: Colors.transparent,
                        valueColor: const AlwaysStoppedAnimation(Color(0xFFFEC404)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Title
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.white.withOpacity(0.95),
                      letterSpacing: -0.3,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Subtitle badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
                    ),
                    child: Text(
                      subtitle,
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Colors.white.withOpacity(0.7)),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Enter button
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
                        onPressed: () async {
                          final Uri url = Uri.parse(link);
                          if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
                            if (!mounted) return;
                            ScaffoldMessenger.of(
                              context,
                            ).showSnackBar(const SnackBar(content: Text('Could not open link'), behavior: SnackBarBehavior.floating));
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(CupertinoIcons.gift, color: Colors.black, size: 18),
                            const SizedBox(width: 8),
                            Text(
                              buttonText,
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
