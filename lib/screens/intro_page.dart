import 'package:flutter/material.dart';
import 'sign_in_page.dart';

class IntroPage extends StatelessWidget {
  const IntroPage({super.key});

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
                "assets/I-HOMEY (4).png",
                width: 300,
                fit: BoxFit.cover, // Ensures the image fills the space properly
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(30,30,10,20),
              child: Text(
                "Get comfy ! \nCustomizable Smart Home System",
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
                "Explore your dream house with an advanced control system",
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
                  MaterialPageRoute(builder: (context) => SignIn()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF19202A), // Change this to your preferred color
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