import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginPopup extends StatefulWidget {
  const LoginPopup({super.key});

  @override
  State<LoginPopup> createState() => _LoginPopupState();
}

class _LoginPopupState extends State<LoginPopup> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool _obscurePassword = true;
  bool _loadingEmail = false;
  bool _loadingGoogle = false;

  /// Đăng nhập bằng Email + Password
  Future<void> _loginWithEmail() async {
    setState(() => _loadingEmail = true);
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("✅ Đăng nhập thành công")),
        );
      }
    } on FirebaseAuthException catch (e) {
      _showError(e.message ?? "Lỗi không xác định");
    } finally {
      setState(() => _loadingEmail = false);
    }
  }

  /// Đăng nhập bằng Google
  Future<void> _loginWithGoogle() async {
    setState(() => _loadingGoogle = true);
    try {
      final googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return;

      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("✅ Đăng nhập Google thành công")),
        );
      }
    } catch (e) {
      print(e);
      _showError("Google Sign-In thất bại: $e");
    } finally {
      setState(() => _loadingGoogle = false);
    }
  }

  /// Show lỗi gọn gàng
  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("❌ $message")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color(0xFF1A1A1A),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Nút đóng
              Row(
                children: [
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const Text(
                "Đăng nhập",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),

              _buildTextField(emailController, "Tài khoản", false),
              const SizedBox(height: 12),
              _buildTextField(passwordController, "Mật khẩu", true),

              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {},
                  child: const Text("Quên mật khẩu?",
                      style: TextStyle(color: Colors.blue)),
                ),
              ),

              const SizedBox(height: 10),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.greenAccent,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: _loadingEmail ? null : _loginWithEmail,
                child: _loadingEmail
                    ? const CircularProgressIndicator(color: Colors.black)
                    : const Text(
                  "Đăng nhập",
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 20),

              const Text("Hoặc", style: TextStyle(color: Colors.white70)),
              const SizedBox(height: 10),

              // Nút Google
              _buildSocialButton(
                text: "Đăng nhập với Google",
                color: Colors.white,
                textColor: Colors.black,
                icon: Icons.g_mobiledata,
                loading: _loadingGoogle,
                onTap: _loginWithGoogle,
              ),
              const SizedBox(height: 10),

              // Nút Facebook (placeholder)
              _buildSocialButton(
                text: "Đăng nhập với Facebook",
                color: Colors.blue,
                textColor: Colors.white,
                icon: Icons.facebook,
                onTap: () {
                  _showError("Chưa cài đặt Facebook Login");
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller, String hint, bool isPassword) {
    return TextField(
      controller: controller,
      obscureText: isPassword ? _obscurePassword : false,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.black54,
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white54),
        suffixIcon: isPassword
            ? IconButton(
          icon: Icon(
            _obscurePassword ? Icons.visibility_off : Icons.visibility,
            color: Colors.white54,
          ),
          onPressed: () =>
              setState(() => _obscurePassword = !_obscurePassword),
        )
            : null,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Widget _buildSocialButton({
    required String text,
    required Color color,
    required Color textColor,
    required IconData icon,
    required VoidCallback onTap,
    bool loading = false,
  }) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      icon: loading
          ? const SizedBox(
        height: 20,
        width: 20,
        child: CircularProgressIndicator(strokeWidth: 2),
      )
          : Icon(icon, color: textColor),
      label: Text(text, style: TextStyle(color: textColor)),
      onPressed: loading ? null : onTap,
    );
  }
}
