import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../core/constants/colors.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _isPasswordVisible = false;
  bool _isLoading = false;

  void _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      final token = await ApiService().login(
        emailController.text.trim(),
        passwordController.text,
      );

      if (mounted) {
        setState(() => _isLoading = false);

        if (token != null) {
          Navigator.pushReplacementNamed(context, '/dashboard');
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text(
                "⚠ Email atau Password salah!",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              backgroundColor: AppColors.accentPink,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: const BorderSide(color: AppColors.borderColor, width: 2),
              ),
            ),
          );
        }
      }
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  // Widget untuk kotak dekoratif di background
  Widget _buildDecoBox({
    required double size,
    required Color color,
    double rotation = 0,
  }) {
    return Transform.rotate(
      angle: rotation,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: color,
          border: Border.all(color: AppColors.borderColor, width: 3),
          borderRadius: BorderRadius.circular(8),
          boxShadow: const [
            BoxShadow(
              color: AppColors.borderColor,
              offset: Offset(3, 3),
              blurRadius: 0,
            ),
          ],
        ),
      ),
    );
  }

  // Widget untuk input field bergaya Neobrutalism
  Widget _buildNeoBrutalField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool isPassword = false,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardColor,
        border: Border.all(color: AppColors.borderColor, width: 3),
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: AppColors.borderColor,
            offset: Offset(4, 4),
            blurRadius: 0,
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        obscureText: isPassword && !_isPasswordVisible,
        keyboardType: keyboardType,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: AppColors.borderColor,
        ),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(
            color: Color(0xFF666666),
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
          prefixIcon: Icon(icon, color: AppColors.borderColor, size: 22),
          suffixIcon: isPassword
              ? IconButton(
                  icon: Icon(
                    _isPasswordVisible
                        ? Icons.visibility
                        : Icons.visibility_off,
                    color: AppColors.borderColor,
                  ),
                  onPressed: () =>
                      setState(() => _isPasswordVisible = !_isPasswordVisible),
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
          errorStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.accentPink,
          ),
        ),
        validator: validator,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 40),

                // === HEADER AREA ===
                // Elemen dekoratif atas
                Stack(
                  alignment: Alignment.center,
                  children: [
                    // Kotak dekoratif di belakang
                    Positioned(
                      left: 40,
                      top: 10,
                      child: _buildDecoBox(
                        size: 30,
                        color: AppColors.accentYellow,
                        rotation: 0.3,
                      ),
                    ),
                    Positioned(
                      right: 50,
                      top: 5,
                      child: _buildDecoBox(
                        size: 20,
                        color: AppColors.accentPink,
                        rotation: -0.2,
                      ),
                    ),
                    // Ikon utama dengan border neobrutalism
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: AppColors.primaryGreen,
                        border: Border.all(
                          color: AppColors.borderColor,
                          width: 4,
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: const [
                          BoxShadow(
                            color: AppColors.borderColor,
                            offset: Offset(5, 5),
                            blurRadius: 0,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.recycling,
                        size: 55,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Judul aplikasi
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.accentYellow,
                    border: Border.all(color: AppColors.borderColor, width: 3),
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: const [
                      BoxShadow(
                        color: AppColors.borderColor,
                        offset: Offset(3, 3),
                        blurRadius: 0,
                      ),
                    ],
                  ),
                  child: const Text(
                    "BANK SAMPAH",
                    style: TextStyle(
                      color: AppColors.borderColor,
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 3,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  "♻ Kelola sampah jadi berkah ♻",
                  style: TextStyle(
                    color: Color(0xFF666666),
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 36),

                // === KARTU LOGIN ===
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: AppColors.cardColor,
                    border: Border.all(color: AppColors.borderColor, width: 3),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: const [
                      BoxShadow(
                        color: AppColors.borderColor,
                        offset: Offset(6, 6),
                        blurRadius: 0,
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Label "MASUK"
                      Row(
                        children: [
                          Container(
                            width: 6,
                            height: 28,
                            decoration: BoxDecoration(
                              color: AppColors.primaryGreen,
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                          const SizedBox(width: 10),
                          const Text(
                            "Selamat Datang!",
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w900,
                              color: AppColors.borderColor,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      const Padding(
                        padding: EdgeInsets.only(left: 16),
                        child: Text(
                          "Silakan login untuk melanjutkan",
                          style: TextStyle(
                            color: Color(0xFF888888),
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(height: 28),

                      // Field Email
                      _buildNeoBrutalField(
                        controller: emailController,
                        label: "EMAIL",
                        icon: Icons.email_outlined,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) =>
                            value!.isEmpty ? "Email tidak boleh kosong" : null,
                      ),
                      const SizedBox(height: 20),

                      // Field Password
                      _buildNeoBrutalField(
                        controller: passwordController,
                        label: "PASSWORD",
                        icon: Icons.lock_outline,
                        isPassword: true,
                        validator: (value) => value!.isEmpty
                            ? "Password tidak boleh kosong"
                            : null,
                      ),
                      const SizedBox(height: 32),

                      // Tombol Login
                      SizedBox(
                        width: double.infinity,
                        height: 58,
                        child: GestureDetector(
                          onTap: _isLoading ? null : _handleLogin,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 100),
                            decoration: BoxDecoration(
                              color: _isLoading
                                  ? AppColors.primaryGreen.withValues(alpha: 0.7)
                                  : AppColors.primaryGreen,
                              border: Border.all(
                                color: AppColors.borderColor,
                                width: 3,
                              ),
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.borderColor,
                                  offset: _isLoading
                                      ? const Offset(1, 1)
                                      : const Offset(5, 5),
                                  blurRadius: 0,
                                ),
                              ],
                            ),
                            child: Center(
                              child: _isLoading
                                  ? const SizedBox(
                                      height: 24,
                                      width: 24,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 3,
                                      ),
                                    )
                                  : const Text(
                                      "MASUK →",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w900,
                                        letterSpacing: 2,
                                      ),
                                    ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),

                // === FOOTER DEKORASI ===
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildDecoBox(
                      size: 14,
                      color: AppColors.primaryGreen,
                      rotation: 0.4,
                    ),
                    const SizedBox(width: 10),
                    _buildDecoBox(
                      size: 10,
                      color: AppColors.accentYellow,
                      rotation: -0.3,
                    ),
                    const SizedBox(width: 10),
                    _buildDecoBox(
                      size: 14,
                      color: AppColors.accentPink,
                      rotation: 0.2,
                    ),
                    const SizedBox(width: 10),
                    _buildDecoBox(
                      size: 10,
                      color: AppColors.primaryGreen,
                      rotation: -0.5,
                    ),
                  ],
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
