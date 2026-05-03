import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/colors.dart';
import '../services/auth_service.dart';
import 'login_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final AuthService _authService = AuthService();
  bool _isLoading = false;
  bool _obscureText = true;

  void _handleSignup() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      
      final result = await _authService.signup(
        _fullNameController.text.trim(),
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );

      setState(() => _isLoading = false);

      if (!mounted) return;

      if (result['success']) {
        // Navigate to Home/Dashboard
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Signup Successful!')),
        );
        // Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HomeScreen()));
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
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Background Decorative Elements
          Positioned(
            top: -100,
            right: -100,
            child: Container(
              width: 400,
              height: 400,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primaryContainer.withOpacity(0.1),
              ),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.4,
            left: -150,
            child: Container(
              width: 320,
              height: 320,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.secondaryContainer.withOpacity(0.05),
              ),
            ),
          ),
          // Blur layer for glass effect
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 80, sigmaY: 80),
              child: Container(color: Colors.transparent),
            ),
          ),
          
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 48.0),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 500),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Header
                      Padding(
                        padding: const EdgeInsets.only(left: 16.0, right: 8.0, bottom: 48.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 48,
                                  height: 4,
                                  decoration: BoxDecoration(
                                    color: AppColors.primary,
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'JOIN THE MOVEMENT',
                                  style: GoogleFonts.lexend(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                    letterSpacing: 2.0,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),
                            Text(
                              'The Living\nLarder',
                              style: GoogleFonts.lexend(
                                fontSize: 48,
                                height: 1.1,
                                fontWeight: FontWeight.bold,
                                color: AppColors.onSurface,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Share more, waste less. Begin your journey toward a sustainable pantry.',
                              style: GoogleFonts.inter(
                                fontSize: 16,
                                color: AppColors.onSurfaceVariant,
                                height: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Form
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            _buildInputField(
                              label: 'Full Name',
                              controller: _fullNameController,
                              hint: 'John Appleseed',
                              validator: (v) => v!.isEmpty ? 'Please enter your name' : null,
                            ),
                            const SizedBox(height: 20),
                            _buildInputField(
                              label: 'Email Address',
                              controller: _emailController,
                              hint: 'hello@livinglarder.com',
                              keyboardType: TextInputType.emailAddress,
                              validator: (v) => !v!.contains('@') ? 'Please enter a valid email' : null,
                            ),
                            const SizedBox(height: 20),
                            _buildInputField(
                              label: 'Password',
                              controller: _passwordController,
                              hint: '••••••••',
                              isPassword: true,
                              validator: (v) => v!.length < 6 ? 'Password must be at least 6 characters' : null,
                            ),
                            const SizedBox(height: 32),
                            
                            // Primary Button
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: AppColors.cloudShadow,
                              ),
                              child: ElevatedButton(
                                onPressed: _isLoading ? null : _handleSignup,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primary, // Using primary since gradient takes extra setup
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(vertical: 20),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  elevation: 0,
                                ),
                                child: _isLoading 
                                    ? const CircularProgressIndicator(color: Colors.white)
                                    : Text(
                                        'Create Account',
                                        style: GoogleFonts.lexend(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
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
                            'Already have an account? ',
                            style: GoogleFonts.inter(
                              color: AppColors.onSurfaceVariant,
                              fontSize: 14,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) => const LoginScreen()),
                              );
                            },
                            child: Text(
                              'Log In',
                              style: GoogleFonts.inter(
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),
                      Center(
                        child: Text(
                          '© 2024 THE LIVING LARDER. PREMIUM\nCOMMUNITY SUSTAINABILITY.',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.lexend(
                            fontSize: 10,
                            letterSpacing: 2,
                            color: AppColors.outlineVariant,
                          ),
                        ),
                      )
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

  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    required String hint,
    bool isPassword = false,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 24.0, bottom: 8.0),
          child: Text(
            label,
            style: GoogleFonts.lexend(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.onSurfaceVariant,
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
            controller: controller,
            obscureText: isPassword && _obscureText,
            keyboardType: keyboardType,
            validator: validator,
            style: GoogleFonts.inter(color: AppColors.onSurface),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: GoogleFonts.inter(color: AppColors.outlineVariant),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              suffixIcon: isPassword
                  ? IconButton(
                      icon: Icon(
                        _obscureText ? Icons.visibility_off : Icons.visibility,
                        color: AppColors.outlineVariant,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
                    )
                  : null,
            ),
          ),
        ),
      ],
    );
  }
}
