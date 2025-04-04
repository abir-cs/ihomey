import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'notifications.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String url="https://api.open-meteo.com/v1/forecast?latitude=36.36&longitude=6.61&current_weather=true";
  String name="chems";
  DateTime today= DateTime.now();
  String formattedDate='';
  double degree =0;

  //setting up today's weather and date 
  void gettemp()async{
    final response=await http.get(Uri.parse(url));
    var data =jsonDecode(response.body);
    setState(() {
      degree=data["current_weather"]["temperature"];
    });
  }
  @override
  void initState() {
    super.initState();
    formattedDate = DateFormat("MMMdd, yyyy").format(today);
    gettemp();
  }

  bool isOn = false;
  List <String> weather_icons =["Icons.cloud_queue_rounded"];
  List <notification> notifs=[notification("First","blalblalblklmjab","9:00 AM"),notification("Second","blalblalbljab","9:00 AM")];


  Widget NotifCard(notification n){
    return Container(
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
         children: [
           Row(
             mainAxisAlignment: MainAxisAlignment.spaceBetween,
             children: [
               Text(
                 '${n.title}',
                 style:TextStyle(
                   color: Color(0xFF19202A),
                   fontWeight: FontWeight.bold,
                 ),
               ),
               Text(
                 '${n.time}',
                 style:TextStyle(
                   color: Color(0xFF606060),
                 ),
               ),
             ],
  
           ),
           Text(
             '${n.disc}',
             style:TextStyle(
               color: Color(0xFF19202A),
             ),
           ),
         ],
      ),
    );
  }
  void _showNotificationsSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.4, // Start at 40% of screen height
          minChildSize: 0.2, // Minimum size when dragged down
          maxChildSize: 0.8, // Maximum size when dragged up
          builder: (context, scrollController) {
            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  Container(
                    width: 40,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.grey[400],
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  SizedBox(height: 10),
                  Text("Notifications", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  Expanded(
                    child: ListView.builder(
                      controller: scrollController, // Enables draggable scrolling
                      itemCount: notifs.length, // Replace with dynamic count
                      itemBuilder: (context, index){
                        notification n = notifs[index];
                        return NotifCard(n);
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor: Color(0xFFF0E7D6),
      body:SafeArea(
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.fromLTRB(20, 10, 20, 30),

                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      "Welcome Home $name !",
                      style: TextStyle(
                        letterSpacing: 1.5,
                        fontSize: 18,
                        color: Colors.grey[800]
                      ),

                    ),
                    SizedBox(width: 20,),
                    GestureDetector(
                      onTap: (){
                        _showNotificationsSheet(context);
                      },
                        child: Icon(Icons.notifications_none,size: 40,color: Color(0xFF19202A),)
                    ),
                    SizedBox(width: 10,),
                    CircleAvatar(
                      backgroundImage: AssetImage("assets/pic6.png"),
                      radius: 25,
                    ),
                  ],
                ),
              ),
              Container(
                width: 335,height: 196,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/white_petals.jpg"),
                    fit: BoxFit.cover,
                    opacity: 0.5,
                  ),
                  color:  Color(0xFFFFFFFF),
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

                child:Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,

                      children: [

                        Container(
                          padding:EdgeInsets.fromLTRB(10, 5, 10, 5),
                            decoration : BoxDecoration(
                              color:  Color(0xFFBCBABA),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Text('$formattedDate')
                        ),
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: "$degree", // Variable for temperature
                                style: TextStyle(fontSize: 40,),
                              ),
                              WidgetSpan(
                                child: Transform.translate(
                                  offset: Offset(0, -5), // Moves the ° symbol up
                                  child: Text(
                                    "°",
                                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              TextSpan(
                                text: "c", // Celsius symbol
                                style: TextStyle(fontSize: 40,fontWeight: FontWeight.w100),
                              ),
                            ],
                          ),
                        ),



                      ],
                    ),
                    Icon(Icons.cloud_queue_rounded,size: 100,color: Colors.grey[700]),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //light
                  Container(
                    margin: EdgeInsets.fromLTRB(0, 44, 0, 0),
                    width: 162,height: 195, // Adjust as needed
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Color(0xFF8F8F8F), // Grey background
                      borderRadius: BorderRadius.circular(20), // Rounded corners
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Circular Icon Container
                        Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Color(0xFF19202A), // Dark navy circle
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.lightbulb_outline,
                            size: 30,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 12),

                        // Title
                        Text(
                          "Lighting",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),

                        // Subtitle
                        Text(
                          "2 lamps",
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFFD9CBB4), // Beige-like color
                          ),
                        ),

                        Spacer(),

                        // Bottom Row: "On" Text + Switch
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              isOn ? "On" : "Off",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),

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
                       ],
                     ),
                  ),
                  Column(

                    children: [
                      //advanced
                      GestureDetector(
                        onTap: (){
                          print("advanced");
                          Navigator.pushNamed(context, '/light');
                        },
                        child: Container(
                          width: 165,height: 81,
                          margin: EdgeInsets.fromLTRB(0, 44, 0, 0),
                          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                          decoration: BoxDecoration(
                            color: Color(0xFF8F8F8F), // Background color
                            borderRadius: BorderRadius.circular(20), // Rounded corners
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Advanced",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    "2 lamps",
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Color(0xFFD9CBB4),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(width: 5,),
                              Container(
                                  padding: EdgeInsets.all(7),
                                  decoration: BoxDecoration(
                                  color: Color(0xFF19202A), // Dark navy circle
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.lightbulb_outline,
                                  size: 28,
                                  color: Colors.white,
                                ),
                              ),

                            ],
                          ),
                        ),
                      ),
                      //gas
                      GestureDetector(
                        onTap: (){
                          print("Gas");
                        },
                        child: Container(
                          width: 165,height: 81,
                          margin: EdgeInsets.fromLTRB(0, 12, 0, 0),
                          padding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                          decoration: BoxDecoration(
                            color: Color(0xFF8F8F8F), // Background color
                            borderRadius: BorderRadius.circular(20), // Rounded corners
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Gas",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    "MQ-2",
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Color(0xFFD9CBB4),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(width: 5,),
                              Container(
                                padding: EdgeInsets.all(7),
                                decoration: BoxDecoration(
                                  color: Color(0xFF19202A), // Dark navy circle
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.local_fire_department,
                                  size: 28,
                                  color: Colors.white,
                                ),
                              ),

                            ],
                          ),
                        ),
                      )
                    ],
                  )

                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  //temperature
                  GestureDetector(
                    onTap: (){
                      print ("temperature : ");
                      Navigator.pushNamed(context, '/temp');
                    },
                    child: Container(

                      padding: EdgeInsets.all(8),
                      margin: EdgeInsets.fromLTRB(0, 20, 0, 10),
                      width: 180,
                      height: 125,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Icon & Text
                          Row(
                            children: [
                              Icon(Icons.thermostat, size: 37, color: Color(0xFF19202A)),
                              SizedBox(width: 10), // Spacing between icon & text
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Temperature",
                                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    "DHT22",
                                    style: TextStyle(fontSize: 14, color: Colors.black54),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  //humidity
                  GestureDetector(
                    onTap: (){
                      print ("humidity : ");
                      Navigator.pushNamed(context, '/temp');
                    },
                    child: Container(

                      padding: EdgeInsets.all(8),
                      margin: EdgeInsets.fromLTRB(0, 20, 0, 10),
                      width: 150,
                      height: 125,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage("assets/white_petals.jpg"),
                          opacity: 0.5,
                          fit: BoxFit.cover,
                        ),
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Icon & Text
                          Row(
                            children: [
                              Icon(Icons.opacity, size: 36, color: Color(0xFF19202A)),
                              SizedBox(width: 10), // Spacing between icon & text
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Humidity",
                                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    "DHT22",
                                    style: TextStyle(fontSize: 14, color: Colors.black54),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
      ) ,
    );
  }
}