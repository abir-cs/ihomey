//import 'dart:nativewrappers/_internal/vm/lib/typed_data_patch.dart';

import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:shared_preferences/shared_preferences.dart';


//import 'package:mqtt_client/mqtt_browser_client.dart';

class Light extends StatefulWidget {
  const Light({super.key});

  @override
  State<Light> createState() => _TempState();
}

class _TempState extends State<Light> {
  double light_int = 0.6;
  late MqttClient client;

  Future<void> loadLight() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      light_int = prefs.getDouble("light") ?? 0.6;
    });
  }
  Future<void> saveLight(double newLight) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('light', newLight);
  }
  @override
  void initState() {
    super.initState();
    _initMqttClient();
    loadLight();
  }
  void _updateIntensity(DragUpdateDetails details, double containerHeight) {
    setState(() {
      double dy = details.localPosition.dy;
      double newValue = 1.0 - (dy / containerHeight);
      light_int = newValue.clamp(0.0, 1.0);
      saveLight(light_int);
    });
    final opacityPercentage = (light_int * 100).toInt().toString();
    final builder = MqttClientPayloadBuilder();
    builder.addString(opacityPercentage);

    if (client.connectionStatus?.state == MqttConnectionState.connected) {
      client.publishMessage('light/opacity', MqttQos.atLeastOnce, builder.payload!);
      print ("published :"+ opacityPercentage);
    } else {
      print("MQTT is not connected. Can't publish.");
    }

  }

  void _initMqttClient() async {
    client = MqttServerClient.withPort('test.mosquitto.org', 'flutter_client', 1883);
    client!.useWebSocket = true;
    client!.logging(on: true);
    client!.onConnected = onConnected;
    client!.onDisconnected = onDisconnected;

    final connMessage = MqttConnectMessage()
        .withClientIdentifier('flutter_client')
        .withWillTopic('flutter/lastwill')
        .withWillMessage('Disconnected')
        .startClean();
    client!.connectionMessage = connMessage;
    try {
      await client.connect();
      print("connection successful !");
    } catch (e) {
      print('❌❌❌ MQTT connection failed: $e');
      client.disconnect();
    }
  }
  //connected to MQTT broker
  void onConnected() {
    print('Connected to MQTT broker');
  }
  //subscription is successful
  void onSubscribed(String topic) {
    print('Subscribed to $topic');
  }
  void onDisconnected() {
    print('Disconnected from the MQTT broker');
  }


  bool isOn= false;
  bool lightOn=true;
  TimeOfDay selectedTime1 = TimeOfDay.now();
  TimeOfDay selectedTime2 = TimeOfDay.now();
  int selected_op =2;



  Future<void> _selectTime1(BuildContext context) async {
    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),

      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            timePickerTheme: TimePickerThemeData(
              dialHandColor:  Colors.blueGrey, // Color of the hand selector
              dialBackgroundColor:Color(0xFFF4F4F4), // Background of the dial
              hourMinuteTextColor: WidgetStateColor.resolveWith((states) =>
              states.contains(WidgetState.selected) ? Colors.white : Colors.black),
              hourMinuteColor: WidgetStateColor.resolveWith((states) =>
              states.contains(WidgetState.selected) ? Colors.blueGrey:Color(0xFFF4F4F4)),
              dayPeriodTextColor: WidgetStateColor.resolveWith((states) =>
              states.contains(WidgetState.selected) ? Colors.white : Colors.black),
              dayPeriodColor: WidgetStateColor.resolveWith((states) =>
              states.contains(WidgetState.selected) ? Color(0xFFBCB5A8):Colors.white),
              entryModeIconColor:Color(0xFF091525), // Icon color
            ),
            colorScheme: ColorScheme.light(
              primary: Color(0xFF091525), // OK button and selected time color
              onPrimary: Colors.white, // Text color on selected time
              onSurface: Colors.black, // Numbers & text color
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        selectedTime1 = picked;
      });
    }
  }
  Future<void> _selectTime2(BuildContext context) async {
    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),

      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            timePickerTheme: TimePickerThemeData(
              dialHandColor:  Colors.blueGrey, // Color of the hand selector
              dialBackgroundColor:Color(0xFFF4F4F4), // Background of the dial
              hourMinuteTextColor: WidgetStateColor.resolveWith((states) =>
              states.contains(WidgetState.selected) ? Colors.white : Colors.black),
              hourMinuteColor: WidgetStateColor.resolveWith((states) =>
              states.contains(WidgetState.selected) ? Colors.blueGrey:Color(0xFFF4F4F4)),
              dayPeriodTextColor: WidgetStateColor.resolveWith((states) =>
              states.contains(WidgetState.selected) ? Colors.white : Colors.black),
              dayPeriodColor: WidgetStateColor.resolveWith((states) =>
              states.contains(WidgetState.selected) ? Color(0xFFBCB5A8):Colors.white),
              entryModeIconColor:Color(0xFF091525), // Icon color
            ),
            colorScheme: ColorScheme.light(
              primary: Color(0xFF091525), // OK button and selected time color
              onPrimary: Colors.white, // Text color on selected time
              onSurface: Colors.black, // Numbers & text color
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        selectedTime2 = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double containerHeight = 250; // Height of the bar
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Light Settings"),
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              children: [
                //draggable pile for selecting light intensity
                GestureDetector(
                  onVerticalDragUpdate: (details) => _updateIntensity(details, containerHeight),
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      Container(
                        width: 100,
                        height: containerHeight,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.grey.shade200,
                        ),
                      ),
                      Container(
                        alignment: Alignment.center,
                        width: 100,
                        height: containerHeight * light_int,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                          color: Color(0xFFF0E7D6),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          "${(light_int* 100).toInt()}%",
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Positioned(
                        bottom: containerHeight * light_int - 20,
                        child: Text(
                          "",
                          style: TextStyle(fontSize: 24),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 5,),
                Text("Adjust\nLight Intensity",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,

                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),

            //schedule details
            Container(
              height: 300,
              margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
              decoration: BoxDecoration(
                border: Border.all(color:Colors.black),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        "Schedule on/off",
                        style: TextStyle(
                          color: Color(0xFF1B2635),
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            isOn = !isOn;
                          });
                        },
                        child: AnimatedContainer(
                          duration: Duration(milliseconds: 300),
                          width: 62,
                          height: 32,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: isOn ? Color(0xFF19202A) : Color(0xFF969696),
                            border: Border.all(color:Color(0xFFC8C8C8) , width: 2),
                          ),
                          child: Stack(
                            children: [
                              AnimatedPositioned(
                                duration: Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                                left: isOn ? 31 : 2,
                                top: 2,
                                child: Container(
                                  width: 23,
                                  height: 23,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color:isOn? Colors.grey[200]: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Divider(
                    height:10,
                    color: Colors.black,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text (
                        "From",
                        style: TextStyle(color: Color(0xFF6B6464),),
                      ),
                      TextButton(
                        onPressed: () => _selectTime1(context),
                        style: TextButton.styleFrom(
                          backgroundColor: Color(0xFFF4F4F4), // Background color
                          foregroundColor:Color(0xFF091525),  // Text color
                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5), // Padding
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5), // Border radius
                          ),
                        ),
                        child: Text(
                          selectedTime1.format(context),
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                      Text (
                        "To",
                        style: TextStyle(color: Color(0xFF6B6464),),
                      ),
                      TextButton(
                        onPressed: () => _selectTime2(context),
                        style: TextButton.styleFrom(
                          backgroundColor: Color(0xFFF4F4F4), // Background color
                          foregroundColor:Color(0xFF091525),  // Text color
                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5), // Padding
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5), // Border radius
                          ),
                        ),
                        child: Text(
                          selectedTime2.format(context),
                          style: TextStyle(fontSize: 18),
                        ),

                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text("Select Light opacity ",style: TextStyle(color: Color(0xFF6B6464),)),
                      Container(
                        padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                        decoration: BoxDecoration(
                            color: Color(0xFFF4F4F4),
                            borderRadius: BorderRadius.circular(5)
                        ),
                        child: DropdownButton<int>(
                          value: selected_op,
                          items: List.generate(11, (index) => index).map((light) {
                            return DropdownMenuItem(
                              value: light,
                              child: Text("${light*10}%"),
                            );
                          }).toList(),
                          onChanged: (newValue) {
                            setState(() {
                              selected_op = newValue!;
                            });
                          },
                          underline: SizedBox(),
                          dropdownColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        "lights on/off",
                        style: TextStyle(color: Color(0xFF6B6464),)
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            lightOn = !lightOn;
                          });
                        },
                        child: AnimatedContainer(
                          duration: Duration(milliseconds: 300),
                          width: 62,
                          height: 32,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: lightOn ? Color(0xFF19202A) : Color(0xFF969696),
                            border: Border.all(color:Color(0xFFC8C8C8) , width: 2),
                          ),
                          child: Stack(
                            children: [
                              AnimatedPositioned(
                                duration: Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                                left: lightOn ? 31 : 2,
                                top: 2,
                                child: Container(
                                  width: 23,
                                  height: 23,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color:lightOn? Colors.grey[200]: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  TextButton(
                    onPressed: () {
                      String topic = "light/schedule";
                      String message = '{"from": "${selectedTime1.format(context)}", "to": "${selectedTime2.format(context)}"}';

                      final builder = MqttClientPayloadBuilder();
                      builder.addString(message);

                      if (client.connectionStatus?.state == MqttConnectionState.connected) {
                        client.publishMessage('light/schedule', MqttQos.atLeastOnce, builder.payload!);
                        print("Schedule sent: $message");
                      } else {
                        print("MQTT is not connected. Can't publish.");
                      }

                    },
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                    ),
                    child: Text("Send Schedule"),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
  @override
  void dispose() {
    client.disconnect();
    super.dispose();
  }
}

extension on MqttClient {
  set useWebSocket(bool useWebSocket) {}
}

