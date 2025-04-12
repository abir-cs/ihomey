import 'package:flutter/material.dart';
import '../main.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE7E7E9),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // SizedBox(height: 200),
            ClipRRect(
              borderRadius: BorderRadius.circular(20), // Adjust the radius as needed
              child: Image.asset(
                "assets/I-HOMEY (5).png",
                width: 300,
                fit: BoxFit.cover, // Ensures the image fills the space properly
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(30,30,10,20),
              child: Text(
                "laaalalalalalal",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                  fontSize: 30,
                  color: Color(0xFF112035),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(30, 0, 20, 50),
              child: Text(
                "alalalala",
                style: TextStyle(
                  letterSpacing: 2,
                  fontSize:15 ,
                  color: Colors.grey[700],
                ),
              ),
            ) ,
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => MainScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFA9ADB6), // Change this to your preferred color
              ),
              child: Icon(
                Icons.double_arrow_rounded,
                color: Colors.white,
              ),

            ),
          ],
        ),
      ),
    );
  }
}