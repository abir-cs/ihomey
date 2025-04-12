import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'screens/home_page.dart';
import 'screens/dashboard_page.dart';
import 'screens/settings_page.dart';
import 'screens/intro_page.dart';
import 'screens/temperature_page.dart';
import 'screens/light_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    systemNavigationBarColor: Colors.transparent, // Make background transparent
    systemNavigationBarIconBrightness: Brightness.dark, // Keep icons visible
    systemNavigationBarContrastEnforced: false, // Ensures transparency effect

  ));
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  runApp( MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        '/temp':(context)=>Temp(),
        '/light':(context)=>Light(),
      },
      theme: ThemeData(
        fontFamily: 'InriaSans',
      ),
      home: IntroPage(),
    );
  }
}

class MainScreen extends StatefulWidget {
    final String username;
  const MainScreen({super.key, required this.username});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 1;
  late List<Widget> _pages;

    @override
  void initState() {
    super.initState();
    
    // Initialize _pages in initState, where you can safely access widget.username
    _pages = [
      DashboardPage(),
      HomePage(name: widget.username),  // Passing username correctly
      SettingsPage(name: widget.username),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        elevation: 20,
        type: BottomNavigationBarType.fixed, // Ensures the background color works
        backgroundColor:Colors.white, //Color(0xFFF4F2F0), // Your preferred background color
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Color(0xFF1A1F25), // Orange for selected item
        unselectedItemColor: Colors.grey[700], // Lighter grey for unselected labels
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Stats'),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),

    );
  }
}







