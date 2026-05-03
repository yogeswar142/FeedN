import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/colors.dart';
import '../services/auth_service.dart';
import 'signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final AuthService _authService = AuthService();
  bool _isLoading = false;

  void _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      
      final result = await _authService.login(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );

      setState(() => _isLoading = false);

      if (!mounted) return;

      if (result['success']) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Login Successful!')),
        );
        // Navigate to Home
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result['message'])),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: Stack(
        children: [
          // Background Decor elements
          Positioned(
            top: -100,
            right: -100,
            child: Container(
              width: 400,
              height: 400,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF6FFBBE).withOpacity(0.2), // primary-fixed 20%
              ),
            ),
          ),
          Positioned(
            bottom: -200,
            left: -200,
            child: Container(
              width: 512,
              height: 512,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFFFDBCA).withOpacity(0.1), // secondary-fixed 10%
              ),
            ),
          ),
          // Blur layer for glassmorphism
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 100, sigmaY: 100),
              child: Container(color: Colors.transparent),
            ),
          ),
          
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 440),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Logo Box
                      Transform.rotate(
                        angle: -3 * 3.14159 / 180,
                        child: Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [AppColors.primary, AppColors.primaryContainer],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: AppColors.cloudShadow,
                          ),
                          child: const Center(
                            child: Icon(Icons.restaurant_menu, color: Colors.white, size: 40),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'The Living Larder',
                        style: GoogleFonts.lexend(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          letterSpacing: -0.5,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(height: 40),
                      
                      // Editorial Hero Text
                      SizedBox(
                        width: double.infinity,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RichText(
                              text: TextSpan(
                                style: GoogleFonts.lexend(
                                  fontSize: 48,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.onSurface,
                                  height: 1.1,
                                  letterSpacing: -1,
                                ),
                                children: const [
                                  TextSpan(text: 'Welcome\n'),
                                  TextSpan(text: 'Back', style: TextStyle(color: AppColors.primary)),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Your organic community awaits.',
                              style: GoogleFonts.inter(
                                fontSize: 18,
                                color: AppColors.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 40),

                      // Form Component
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            _buildEmailField(),
                            const SizedBox(height: 24),
                            _buildPasswordField(),
                            const SizedBox(height: 32),
                            // Login Button
                            SizedBox(
                              width: double.infinity,
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: AppColors.cloudShadow,
                                ),
                                child: ElevatedButton(
                                  onPressed: _isLoading ? null : _handleLogin,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.primary,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(vertical: 20),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    elevation: 0,
                                  ),
                                  child: _isLoading 
                                      ? const CircularProgressIndicator(color: Colors.white)
                                      : Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              'Sign In',
                                              style: GoogleFonts.lexend(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(width: 12),
                                            const Icon(Icons.arrow_forward),
                                          ],
                                        ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 48),

                      // Footer Logic
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Don't have an account? ",
                            style: GoogleFonts.inter(
                              color: AppColors.onSurfaceVariant,
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) => const SignupScreen()),
                              );
                            },
                            child: Text(
                              'Sign Up',
                              style: GoogleFonts.inter(
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmailField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16.0, bottom: 8.0),
          child: Text(
            'Email Address',
            style: GoogleFonts.lexend(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.onSurface,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerLow,
            borderRadius: BorderRadius.circular(12),
            boxShadow: AppColors.cloudShadow,
          ),
          child: TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            validator: (v) => v!.isEmpty ? 'Enter your email' : null,
            style: GoogleFonts.inter(color: AppColors.onSurface),
            decoration: InputDecoration(
              hintText: 'hello@livinglarder.com',
              hintStyle: GoogleFonts.inter(color: AppColors.outlineVariant),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              suffixIcon: const Icon(Icons.mail_outline, color: AppColors.outlineVariant),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Password',
                style: GoogleFonts.lexend(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.onSurface,
                ),
              ),
              GestureDetector(
                onTap: () {},
                child: Text(
                  'Forgot?',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.secondary,
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerLow,
            borderRadius: BorderRadius.circular(12),
            boxShadow: AppColors.cloudShadow,
          ),
          child: TextFormField(
            controller: _passwordController,
            obscureText: true,
            validator: (v) => v!.isEmpty ? 'Enter your password' : null,
            style: GoogleFonts.inter(color: AppColors.onSurface),
            decoration: InputDecoration(
              hintText: '••••••••',
              hintStyle: GoogleFonts.inter(color: AppColors.outlineVariant),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              suffixIcon: const Icon(Icons.lock_outline, color: AppColors.outlineVariant),
            ),
          ),
        ),
      ],
    );
  }
}
