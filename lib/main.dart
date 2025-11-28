import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:lxg_au/constant/app_constant.dart';
import 'features/auth/services/auth_service.dart';
import '../services/lxg_api_service.dart';
import 'pages/giveaway.dart';
import 'pages/affiliate.dart';
import 'pages/settings.dart';
import 'features/auth/screens/login_screen.dart';
import 'features/dashboard/pages/dashboard_page.dart';
import 'models/models.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  bool isLoading = true;
  bool isLoggedIn = false;
  User? user;
  Membership? membership;

  @override
  void initState() {
    super.initState();
    _checkAuthenticationStatus();
  }

  Future<void> _checkAuthenticationStatus() async {
    try {
      // Check if token exists
      final token = await AuthService.getToken();
      if (token == null) {
        setState(() {
          isLoading = false;
          isLoggedIn = false;
        });
        return;
      }

      // Validate token by fetching user data
      final fetchedUser = await ApiService.getMe();
      final fetchedMembership = await ApiService.getMemberStatus();

      setState(() {
        isLoading = false;
        isLoggedIn = true;
        user = fetchedUser;
        membership = fetchedMembership;
      });
    } catch (e) {
      // Token is invalid or expired
      print('Authentication check failed: $e');
      await AuthService.logout();
      setState(() {
        isLoading = false;
        isLoggedIn = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LXG AU App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue, scaffoldBackgroundColor: Colors.black),
      home: isLoading
          ? const _LoadingScreen()
          : isLoggedIn
          ? HomePage(initialUser: user, initialMembership: membership)
          : const LoginScreen(),
    );
  }
}

// ---------------- Home Page ----------------
class HomePage extends StatefulWidget {
  final User? initialUser;
  final Membership? initialMembership;

  const HomePage({super.key, this.initialUser, this.initialMembership});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  User? user;
  Entries? entriesData;
  Membership? membership;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    user = widget.initialUser;
    membership = widget.initialMembership;
    fetchData();
  }

  Future<void> fetchData() async {
    setState(() => isLoading = true);

    try {
      user = await ApiService.getMe();
      entriesData = await ApiService.getEntries();
      membership = await ApiService.getMemberStatus();
      print('Membership: $membership');
    } catch (e) {
      print('Error fetching data: $e');
    }

    if (!mounted) return;
    setState(() => isLoading = false);
  }

  void logout() async {
    final shouldLogout = await showDialog<bool>(
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
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 8))],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFFF3B30).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(50),
                  border: Border.all(color: const Color(0xFFFF3B30).withOpacity(0.3), width: 2),
                ),
                child: const Icon(CupertinoIcons.power, color: Color(0xFFFF3B30), size: 28),
              ),
              const SizedBox(height: 20),
              Text(
                'Logout',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: Colors.white.withOpacity(0.95), letterSpacing: -0.5),
              ),
              const SizedBox(height: 8),
              Text(
                'Are you sure you want to logout?',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: Colors.white.withOpacity(0.7)),
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
                        border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
                      ),
                      child: TextButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        style: TextButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
                        child: Text(
                          'Cancel',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white.withOpacity(0.8)),
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
                        boxShadow: [BoxShadow(color: const Color(0xFFFF3B30).withOpacity(0.4), blurRadius: 12, offset: const Offset(0, 4))],
                      ),
                      child: TextButton(
                        onPressed: () => Navigator.of(context).pop(true),
                        style: TextButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
                        child: const Text(
                          'Logout',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
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

    if (shouldLogout == true) {
      await AuthService.logout();
      if (!mounted) return;
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginScreen()));
    }
  }

  void _onItemTapped(int index) async {
    if (index == 4) {
      logout();
      return;
    }

    setState(() => _selectedIndex = index);
  }

  Widget get _page {
    switch (_selectedIndex) {
      case 0:
        return DashboardPage(initialUser: user, initialMembership: membership);
      case 1:
        return AffiliatePage(membership: membership);
      case 2:
        return const GiveawaysPage();
      case 3:
        return const SettingsPage();
      default:
        return DashboardPage(initialUser: user, initialMembership: membership);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _page,
      extendBody: true,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [const Color(0xFFFEC404).withOpacity(0.95), const Color(0xFFFFD700).withOpacity(0.95)],
          ),
          borderRadius: const BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25)),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 20, offset: const Offset(0, -5), spreadRadius: 0)],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25)),
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.transparent,
            elevation: 0,
            selectedItemColor: Colors.black87,
            unselectedItemColor: Colors.black54,
            selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
            unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 11),
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
            items: [
              BottomNavigationBarItem(
                icon: Container(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Icon(_selectedIndex == 0 ? CupertinoIcons.house_fill : CupertinoIcons.house, size: _selectedIndex == 0 ? 26 : 22),
                ),
                label: 'Dashboard',
              ),
              BottomNavigationBarItem(
                icon: Container(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Icon(_selectedIndex == 1 ? CupertinoIcons.person_2_fill : CupertinoIcons.person_2, size: _selectedIndex == 1 ? 26 : 22),
                ),
                label: 'Affiliate',
              ),
              BottomNavigationBarItem(
                icon: Container(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Icon(_selectedIndex == 2 ? CupertinoIcons.gift_fill : CupertinoIcons.gift, size: _selectedIndex == 2 ? 26 : 22),
                ),
                label: 'Giveaways',
              ),
              BottomNavigationBarItem(
                icon: Container(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Icon(_selectedIndex == 3 ? CupertinoIcons.settings_solid : CupertinoIcons.settings, size: _selectedIndex == 3 ? 26 : 22),
                ),
                label: 'Settings',
              ),
              BottomNavigationBarItem(
                icon: Container(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Icon(
                    CupertinoIcons.power,
                    size: _selectedIndex == 4 ? 26 : 22,
                    color: _selectedIndex == 4 ? const Color(0xFFFF3B30) : Colors.black54,
                  ),
                ),
                label: 'Logout',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------- Loading Screen ----------------
class _LoadingScreen extends StatefulWidget {
  const _LoadingScreen();

  @override
  State<_LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<_LoadingScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(duration: const Duration(milliseconds: 1500), vsync: this);

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeInOut));

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(CurvedAnimation(parent: _animationController, curve: Curves.elasticOut));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF000000), Color(0xFF1a1a1a), Color(0xFF000000)],
            stops: [0.0, 0.5, 1.0],
          ),
        ),
        child: Center(
          child: AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return FadeTransition(
                opacity: _fadeAnimation,
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [BoxShadow(color: const Color(0xFFFEC404).withOpacity(0.3), blurRadius: 30, spreadRadius: 5)],
                        ),
                        child: Image.asset(AppConstant.logo, height: 100),
                      ),
                      const SizedBox(height: 48),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
                        ),
                        child: const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(strokeWidth: 3, valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFEC404))),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Loading...',
                        style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 17, fontWeight: FontWeight.w500, letterSpacing: 0.5),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
