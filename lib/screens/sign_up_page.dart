import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passkeyController = TextEditingController();

  String _savedUsername = '';

  void _saveUsername() {
    setState(() {
      _savedUsername = _usernameController.text;
    });
  }

    Widget _buildInputField({
    required String label,
    required String hint,
    required TextEditingController controller,
    bool obscureText = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            letterSpacing: 2,
            fontSize: 13,
            color: Colors.grey[700],
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: 250,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: TextField(
            controller: controller,
            obscureText: obscureText,
            decoration: InputDecoration(
              hintText: hint,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE7E7E9),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 50),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Sign up Fields (similar to your Sign In fields)
                // Username
                              ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset(
                    "assets/I-HOMEY (5).png",
                    width: 300,
                    fit: BoxFit.cover,
                  ),
                ),

                SizedBox(height: 30,),

                // Username field
                _buildInputField(
                  label: "Username",
                  hint: "Enter your username",
                  controller: _usernameController,
                ),
                const SizedBox(height: 20),

                // Password field
                _buildInputField(
                  label: "Password",
                  hint: "Enter your password",
                  controller: _passwordController,
                  obscureText: true,
                ),
                const SizedBox(height: 30),

                // Passkey field
                _buildInputField(
                  label: "iHomeY passkey passcode idk bro",
                  hint: "Enter your passkey",
                  controller: _passkeyController,
                  obscureText: true,
                ),
                const SizedBox(height: 30),

                // Navigation button
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // Go back to Sign In page
                  },
                  style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(Color(0xFF1B2635)),
                  foregroundColor: WidgetStateProperty.all(Color(0xFFF4F4F4)),
                  elevation: WidgetStateProperty.all(8),
                  shadowColor: WidgetStateProperty.all(Colors.black.withOpacity(0.5)), 
                      overlayColor: WidgetStateProperty.resolveWith<Color?>(
                        (Set<WidgetState> states) {
                          if (states.contains(WidgetState.pressed)) {
                            return Color(0xFFF4F4F4).withOpacity(0.3); // Change ripple effect color
                          }
                          return null; // Default ripple color
                        },
                      ),
                  minimumSize: WidgetStateProperty.all(Size(150, 50)),
                  shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15), // Reduce roundness
                    ),
                  ),
                ),
                  child: Text(
                    "Sign Up",
                    style: TextStyle(
                    fontSize: 18,
                    ),
                    ),
                ),
                const SizedBox(height: 30),

                // Sign In label
                TextButton(
                  onPressed: () {
                    Navigator.pop(context); // Go back to Sign In page
                  },
                  child: const Text(
                    'Already have an account? Sign In',
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
