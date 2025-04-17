import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'sign_in_page.dart';

class SettingsPage extends StatefulWidget {
String name;
SettingsPage({super.key, required this.name});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool isOn = false;
  String email = "username@gmail.com";
Future<void> saveName(String newName) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('name', newName);
}

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF0E7D6),
      appBar: AppBar(
        backgroundColor: Color(0xFFF0E7D6),
        title: Text(
          "Profile/Settings",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            //pfp + username + email
            Container(
              margin: EdgeInsets.fromLTRB(15, 10, 20, 30),
              width: 335,
              height: 196,
              decoration: BoxDecoration(
                color: Color(0xFFF4F4F4),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    spreadRadius: 2,
                    blurRadius: 6,
                    offset: Offset(2, 4),
                  ),
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(width: 30),
                  CircleAvatar(
                    backgroundImage: AssetImage("assets/pic6.png"),
                    radius: 37,
                  ),
                  SizedBox(width: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "${widget.name}", // Use the local 'name' variable here
                        style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 5),
                      Text(
                        email,
                        style: TextStyle(fontSize: 12, color: Color(0xFF6B6464)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),
            //change username button
            SizedBox(
              width: 300,
              
              child: ElevatedButton(
onPressed: () async  {
  TextEditingController controller = TextEditingController(text: widget.name); // Use the state 'name'

  // Wait for the current frame to finish rendering (keyboard delay trick)
  await Future.delayed(Duration.zero);

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      return Padding(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 20,
          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Edit Username',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            TextField(
              controller: controller,
              autofocus: true,
              decoration: InputDecoration(
                labelText: 'New username',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      widget.name = controller.text;  // Update state variable 'name'
                    });
                    saveName(widget.name);  // Save updated name to SharedPreferences
                    Navigator.pop(context);
                  },
                  child: Text('Save'),
                ),
              ],
            ),
          ],
        ),
      );
    },
  );
},



                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(Color(0xFFF4F4F4)),
                  foregroundColor: WidgetStateProperty.all(Color(0xFF1B2635)),
                  elevation: WidgetStateProperty.all(8),
                  shadowColor: WidgetStateProperty.all(Colors.black.withOpacity(0.5)), 
                      overlayColor: WidgetStateProperty.resolveWith<Color?>(
                        (Set<WidgetState> states) {
                          if (states.contains(WidgetState.pressed)) {
                            return Color.fromARGB(255, 31, 51, 80).withOpacity(0.3); // Change ripple effect color
                          }
                          return null; // Default ripple color
                        },
                      ),
                  minimumSize: WidgetStateProperty.all(Size(300, 50)),
                  shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15), // Reduce roundness
                    ),
                  ),
                ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.create_outlined, size: 20, color: Color(0xFF19202A)),
                  Text('  Change Username'),
                ],
              )
              )
            ),
            SizedBox(height: 35),
            //change email button
            SizedBox(
              width: 300,
              child: ElevatedButton(
              onPressed: () {},
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(Color(0xFFF4F4F4)),
                  foregroundColor: WidgetStateProperty.all(Color(0xFF1B2635)),
                  elevation: WidgetStateProperty.all(8),
                  shadowColor: WidgetStateProperty.all(Colors.black.withOpacity(0.5)), 
                      overlayColor: WidgetStateProperty.resolveWith<Color?>(
                        (Set<WidgetState> states) {
                          if (states.contains(WidgetState.pressed)) {
                            return Color.fromARGB(255, 31, 51, 80).withOpacity(0.3); // Change ripple effect color
                          }
                          return null; // Default ripple color
                        },
                      ),
                  minimumSize: WidgetStateProperty.all(Size(300, 50)),
                  shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15), // Reduce roundness
                    ),
                  ),
                ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.create_outlined, size: 20, color: Color(0xFF19202A)),
                  Text('  Change Email Address'),
                ],
              )
              

              )
            ),
            SizedBox(height: 35),
            //change language button
            SizedBox(
              width: 300,
              child: ElevatedButton(
              onPressed: () {},
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(Color(0xFFF4F4F4)),
                  foregroundColor: WidgetStateProperty.all(Color(0xFF1B2635)),
                  elevation: WidgetStateProperty.all(8),
                  shadowColor: WidgetStateProperty.all(Colors.black.withOpacity(0.5)), 
                      overlayColor: WidgetStateProperty.resolveWith<Color?>(
                        (Set<WidgetState> states) {
                          if (states.contains(WidgetState.pressed)) {
                            return Color.fromARGB(255, 31, 51, 80).withOpacity(0.3); // Change ripple effect color
                          }
                          return null; // Default ripple color
                        },
                      ),
                  minimumSize: WidgetStateProperty.all(Size(300, 50)),
                  shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15), // Reduce roundness
                    ),
                  ),
                ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.create_outlined, size: 20, color: Color(0xFF19202A)),
                  Text('  Language'),
                ],
              ),
              
              ),
            ),
            SizedBox(height: 35),
            //change mode button
            SizedBox(
              width: 300,
              child: ElevatedButton(
                onPressed: () {},
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(Color(0xFFF4F4F4)),
                  foregroundColor: WidgetStateProperty.all(Color(0xFF1B2635)),
                  elevation: WidgetStateProperty.all(8),
                  shadowColor: WidgetStateProperty.all(Colors.black.withOpacity(0.5)), 
                      overlayColor: WidgetStateProperty.resolveWith<Color?>(
                        (Set<WidgetState> states) {
                          if (states.contains(WidgetState.pressed)) {
                            return Color.fromARGB(255, 31, 51, 80).withOpacity(0.3); // Change ripple effect color
                          }
                          return null; // Default ripple color
                        },
                      ),
                  minimumSize: WidgetStateProperty.all(Size(300, 50)),
                  shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15), // Reduce roundness
                    ),
                  ),
                ),
              child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Dark Mode         '),
                            /*Text(
                              isOn ? "On" : "Off",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),*/

                            // Custom Styled Switch
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  isOn = !isOn;
                                });
                              },
                              child: AnimatedContainer(
                                duration: Duration(milliseconds: 300),
                                width: 50,
                                height: 32,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: isOn ? Colors.white : Color(0xFF19202A),
                                  border: Border.all(color: Colors.white, width: 2),
                                ),
                                child: Stack(
                                  children: [
                                    AnimatedPositioned(
                                      duration: Duration(milliseconds: 300),
                                      curve: Curves.easeInOut,
                                      left: isOn ? 22 : 2,
                                      top: 2,
                                      child: Container(
                                        width: 24,
                                        height: 24,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: isOn ? Color(0xFF19202A) : Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
              ),
            ),
            SizedBox(height: 35),
             //log out button
             Center(
              child: ElevatedButton(
              onPressed: () {
                //navigate to sign in page

                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => SignIn()),
                );
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
                  minimumSize: WidgetStateProperty.all(Size(100, 50)),
                  shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15), // Reduce roundness
                    ),
                  ),
                ),
              child: Text('Log out')
              )
            ),
            
          ],
        )
      )
    );
  }
}