import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UpdateEmailPage extends StatefulWidget {
  final String currentEmail;

  const UpdateEmailPage({Key? key, required this.currentEmail})
    : super(key: key);

  @override
  State<UpdateEmailPage> createState() => _UpdateEmailPageState();
}

class _UpdateEmailPageState extends State<UpdateEmailPage> {
  late TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(text: widget.currentEmail);
  }

  Future<void> saveEmail(String newEmail) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('email', newEmail);
  }

  void _updateEmail() {
    final newEmail = _emailController.text.trim();
    if (newEmail.isNotEmpty && newEmail.contains('@')) {
      saveEmail(newEmail).then((_) {
        Navigator.pop(context, newEmail);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Please enter a valid email address."),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Email'),
        centerTitle: true,
        backgroundColor: Color(0xFFF0E7D6),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email Address',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _updateEmail,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF1B2635),
                foregroundColor: Color(0xFFF4F4F4),
                minimumSize: Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              child: Text('Save Email'),
            ),
          ],
        ),
      ),
    );
  }
}
