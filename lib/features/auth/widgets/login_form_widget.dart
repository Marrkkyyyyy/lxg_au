import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class LoginFormWidget extends StatefulWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool isLoading;
  final String error;
  final VoidCallback onLogin;

  const LoginFormWidget({
    super.key,
    required this.emailController,
    required this.passwordController,
    required this.isLoading,
    required this.error,
    required this.onLogin,
  });

  @override
  State<LoginFormWidget> createState() => _LoginFormWidgetState();
}

class _LoginFormWidgetState extends State<LoginFormWidget> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(duration: const Duration(milliseconds: 800), vsync: this);

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Widget _buildTextField({required TextEditingController controller, required String placeholder, required IconData icon, bool obscureText = false}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        textInputAction: obscureText ? TextInputAction.done : TextInputAction.next,
        onSubmitted: (_) {
          if (!obscureText) {
            // Move to next field (password)
            FocusScope.of(context).nextFocus();
          } else {
            // Submit form if on password field
            FocusScope.of(context).unfocus();
            widget.onLogin();
          }
        },
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black87),
        decoration: InputDecoration(
          hintText: placeholder,
          hintStyle: TextStyle(color: Colors.grey[500], fontWeight: FontWeight.w400),
          prefixIcon: Icon(icon, color: Colors.grey[600], size: 22),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: GestureDetector(
              onTap: () {
                // Dismiss keyboard when tapping on the form container
                FocusScope.of(context).unfocus();
              },
              behavior: HitTestBehavior.opaque,
              child: Container(
                width: width * 0.85,
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 8))],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome Back',
                      style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700, color: Colors.white.withOpacity(0.95), letterSpacing: -0.5),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Sign in to continue',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: Colors.white.withOpacity(0.7)),
                    ),
                    const SizedBox(height: 32),
                    _buildTextField(controller: widget.emailController, placeholder: 'Email', icon: CupertinoIcons.mail),
                    const SizedBox(height: 16),
                    _buildTextField(controller: widget.passwordController, placeholder: 'Password', icon: CupertinoIcons.lock, obscureText: true),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFFFEC404), Color(0xFFFFD700)],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [BoxShadow(color: const Color(0xFFFEC404).withOpacity(0.4), blurRadius: 12, offset: const Offset(0, 6))],
                        ),
                        child: ElevatedButton(
                          onPressed: widget.isLoading ? null : widget.onLogin,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          ),
                          child: widget.isLoading
                              ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(strokeWidth: 3, valueColor: AlwaysStoppedAnimation<Color>(Colors.black)),
                                )
                              : const Text(
                                  'Sign In',
                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black, letterSpacing: 0.5),
                                ),
                        ),
                      ),
                    ),
                    if (widget.error.isNotEmpty)
                      Container(
                        margin: const EdgeInsets.only(top: 16),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.red.withOpacity(0.3), width: 1),
                        ),
                        child: Row(
                          children: [
                            Icon(CupertinoIcons.exclamationmark_triangle, color: Colors.red[400], size: 18),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                widget.error,
                                style: TextStyle(color: Colors.red[400], fontSize: 14, fontWeight: FontWeight.w500),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
