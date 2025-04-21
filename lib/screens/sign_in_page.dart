import 'package:flutter/material.dart';
import 'package:ihomey/screens/authentication.dart';
import '../main.dart';
import 'sign_up_page.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final String correctUsername = 'abir';
  final String correctPassword = '24022005';
  final authservice= AuthService();


  String _savedUsername = '';

  void _login() {
  String username = _usernameController.text.trim();
  String password = _passwordController.text;

  if (username == correctUsername && password == correctPassword) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => MainScreen(username: _usernameController.text)),
    );
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Invalid username or password'),
        backgroundColor: Colors.red,
      ),
    );
  }
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
                // Logo
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset(
                    "assets/I-HOMEY (4).png",
                    width: 300,
                    fit: BoxFit.cover,
                  ),
                ),
                Container(
              margin: EdgeInsets.fromLTRB(30,30,10,20),
              child: Text(
                "Get comfy ! \nCustomizable Smart Home System",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                  fontSize: 27,
                  color: Color(0xFF112035),
                ),
              ),
            ),

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

                // Navigation button
                ElevatedButton(
                  onPressed: () async {
                    final result = await authservice.login(
                      username: _usernameController.text.trim(),
                      password: _passwordController.text,
                    );

                    if (result == null) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => MainScreen(username: _usernameController.text)),
                      );
                      print('Login successful');
                    } else {
                      // Login failed – show SnackBar with the error message
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Invalid username or password'),
                          backgroundColor: Colors.red,
                        ),
                      );
                      print('Error: $result');
                    }
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
                    "Sign In",
                    style: TextStyle(
                    fontSize: 18,
                    ),
                    ),
                ),

                SizedBox(height: 10,),
                 // Sign Up / Sign In Labels at the bottom
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const SignUpPage()),
                        );
                      },
                      child: const Text(
                        'Don\'t have an account? Sign Up',
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),

              ],
            ),
         ] ) ,
        ),
      ),
    ) );
  }
}
