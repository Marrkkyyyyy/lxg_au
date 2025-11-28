import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:lxg_au/constant/app_constant.dart';
import 'package:url_launcher/url_launcher.dart';
import '../config/api_urls.dart';
import '../models/models.dart';

class AffiliatePage extends StatelessWidget {
  final Membership? membership;

  const AffiliatePage({super.key, this.membership});

  final List<Map<String, String>> affiliates = const [
    {
      'logo': 'assets/images/1Bloomingdale.jpg',
      'title': 'Bloomingdales',
      'category': 'Apparel',
      'description':
          "Bloomingdale's AU standard shipping: Free shipping on orders \$300+ AUD. Express shipping: \$40 AUD flat rate shipping on orders \$400+ AUD.",
      'link': ApiUrls.bloomingdales,
    },
    {
      'logo': 'assets/images/2DesignerWardrobe.jpg',
      'title': 'Designer Wardrobe',
      'category': 'Apparel',
      'description': 'Join Designer Wardrobe (325k+ members), shop pre-loved fashion & save up to 60% off RRP all your favourite brands.',
      'link': ApiUrls.designerWardrobe,
    },
    {
      'logo': 'assets/images/femme.jpg',
      'title': 'Femme Connection',
      'category': 'Apparel',
      'description': 'Free Shipping AUS wide on all orders over \$40!',
      'link': ApiUrls.femmeConnection,
    },
    {
      'logo': 'assets/images/jd.jpg',
      'title': 'JD Sports Australia',
      'category': 'Apparel',
      'description': 'Up To 40% Off Sale',
      'link': ApiUrls.jdSports,
    },
    {
      'logo': 'assets/images/locc.jpg',
      'title': "L'OCCITANE Australia",
      'category': 'Apparel',
      'description': 'Free Express Shipping on orders \$120+ | Automatic at checkout',
      'link': ApiUrls.loccitane,
    },
    {
      'logo': 'assets/images/lornajane.jpg',
      'title': "Lorna Jane APAC",
      'category': 'Apparel',
      'description': 'Up To 40% Off Sale',
      'link': ApiUrls.lornaJane,
    },
    {
      'logo': 'assets/images/oca.jpg',
      'title': "Online Courses AU",
      'category': 'Courses',
      'description': 'Time to upskill, reskill, and learn a new skill with Online Courses Australia. Enjoy 50% off your enrolment.',
      'link': ApiUrls.onlineCoursesAu,
    },
  ];

  void _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $url';
    }
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
      // Handle error silently or show a snackbar if needed
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isLocked = !(membership?.isMember ?? false);

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 120),
          child: Column(
            children: [
              // Top logo
              Image.asset(AppConstant.logo, height: 120),
              const SizedBox(height: 24),

              if (isLocked) _buildLockedState() else _buildAffiliateContent(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLockedState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 20, offset: const Offset(0, 8))],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFFFF3B30).withOpacity(0.1),
              borderRadius: BorderRadius.circular(50),
              border: Border.all(color: const Color(0xFFFF3B30).withOpacity(0.3), width: 2),
            ),
            child: const Icon(CupertinoIcons.lock_fill, color: Color(0xFFFF3B30), size: 40),
          ),
          const SizedBox(height: 24),
          Text(
            'Affiliate Locked',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: Colors.white.withOpacity(0.95), letterSpacing: -0.5),
          ),
          const SizedBox(height: 12),
          Text(
            'You must have an active membership to access our affiliate partners.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: Colors.white.withOpacity(0.7), height: 1.4),
          ),
          const SizedBox(height: 32),
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
                onPressed: _handleUpgradeMembership,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(CupertinoIcons.arrow_up_circle, color: Colors.black, size: 18),
                    SizedBox(width: 8),
                    Text(
                      'Upgrade Membership',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAffiliateContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Main title
        const Text(
          "Affiliate Partners",
          style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        const SizedBox(height: 4),

        // Subtitle
        const Text("Selected options to help you spend less", style: TextStyle(fontSize: 15, color: Colors.white70)),
        const SizedBox(height: 20),

        // Affiliate cards
        Column(
          children: affiliates.map((affiliate) {
            return _affiliateCard(context, affiliate);
          }).toList(),
        ),
      ],
    );
  }

  Widget _affiliateCard(BuildContext context, Map<String, String> affiliate) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
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
            // Logo container with glassmorphism
            Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.03),
                border: Border(bottom: BorderSide(color: Colors.white.withOpacity(0.1), width: 1)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Image.asset(affiliate['logo']!, fit: BoxFit.contain),
              ),
            ),

            // Content section
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFEC404).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFFEC404).withOpacity(0.3), width: 1),
                    ),
                    child: Text(
                      affiliate['category']!,
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFFFEC404)),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Title
                  Text(
                    affiliate['title']!,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Colors.white.withOpacity(0.95), letterSpacing: -0.5),
                  ),
                  const SizedBox(height: 8),

                  // Description
                  Text(
                    affiliate['description']!,
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400, color: Colors.white.withOpacity(0.7), height: 1.4),
                  ),
                  const SizedBox(height: 20),

                  // Button with iOS-style design
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
                        onPressed: () => _launchURL(affiliate['link']!),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(CupertinoIcons.link, color: Colors.black, size: 18),
                            SizedBox(width: 8),
                            Text(
                              'Visit Partner',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black),
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
