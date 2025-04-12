
import 'package:flutter/material.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Temp extends StatefulWidget {
  const Temp({super.key});

  @override
  State<Temp> createState() => _TempState();
}

class _TempState extends State<Temp> {
  //temp adjustment
  double _temperature = 30;

  //current data
  int current_temp=14;
  int current_humidity=50;

  //schedule variables
  bool isOn= false;
  TimeOfDay selectedTime1 = TimeOfDay.now();
  TimeOfDay selectedTime2 = TimeOfDay.now();
  int selectedTemp=30;



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

  Future<void> loadTempadj() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _temperature  = prefs.getDouble("tempadj") ?? 14; // default to "Abir" if no saved value
    });
  }
  Future<void> saveTempadj(double newTemp) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('tempadj', newTemp);
  }
  Future<void> loadTemp() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      selectedTemp = prefs.getInt("temp") ?? 14; // default to "Abir" if no saved value
    });
  }
  Future<void> saveTemp(int newTemp) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('temp', newTemp);
  }
  Future<void> loadStatus() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isOn = prefs.getBool("status") ?? false; // default to "Abir" if no saved value
    });
  }
  Future<void> saveStatus(bool newStatus) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('status', newStatus);
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadTempadj();
    loadTemp();
    loadStatus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Light background
      appBar: AppBar(
        title: Text("Temperature"),
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          //temp adjustment
          Container(
            margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
            width: double.maxFinite,
            //color: Colors.blue,
            child: Column(
              children: [
                SleekCircularSlider(
                  min: 0,
                  max: 40,
                  initialValue: _temperature,
                  appearance: CircularSliderAppearance(
                    size: 250, // Adjust size
                    customColors: CustomSliderColors(
                      trackColor: Colors.grey[300]!,
                      progressBarColors: [Color(0xFFF0E7D6), Colors.blueGrey], // Gradient
                      dotColor: Color(0xFFF4F4F4),
                    ),
                    customWidths: CustomSliderWidths(
                      trackWidth: 10,
                      progressBarWidth: 12,
                      handlerSize: 16, // Little draggable circle
                    ),
                  ),
                  onChange: (value) {
                    setState(() {
                      _temperature = value;
                      saveTempadj(_temperature );
                    });
                  },
                  innerWidget: (value) => Container(
                    margin: EdgeInsets.all(30),
                    width: 200,height: 200,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFFF4F4F4),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "${value.toInt()}°C",
                          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                        ),
                        Text("Adjust Temperature",
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                      ],
                    ),
                  ),
                ),
                Text(
                  "Mode",
                  style: TextStyle(
                    color :Color(0xFF6B6464),
                    fontSize: 16,
                  ),
                ),
                Text(
                  "POWERFULL",
                  style: TextStyle(
                    color: Color(0xFF1B2635),
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                )
              ],
            ),
          ),
          //current data
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  Text(
                    "Current Temp",
                    style: TextStyle(
                      color: Color(0xFF19202A),
                      fontSize: 15,
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    width: 145,height: 150,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Color(0xFF888990),
                    ),
                    child:Text(
                      "$current_temp°C",
                      style: TextStyle(
                        fontSize: 30,
                      ),
                    ),
                  )
                ],
              ),
              Column(
                children: [
                  Text(
                    "Current Humidity",
                    style: TextStyle(
                      color: Color(0xFF19202A),
                      fontSize: 15,
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    width: 145,height: 150,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Color(0xFF888990),
                    ),
                    child:Text(
                      "$current_humidity%",
                      style: TextStyle(
                        fontSize: 30,
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
          //schedule
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
                    saveStatus(isOn);
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
              Text("Select Temperature ",style: TextStyle(color: Color(0xFF6B6464),)),
              Container(
                padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                decoration: BoxDecoration(
                  color: Color(0xFFF4F4F4),
                  borderRadius: BorderRadius.circular(5)
                ),
                child: DropdownButton<int>(
                  value: selectedTemp,
                  items: List.generate(41, (index) => index).map((temp) {
                    return DropdownMenuItem(
                      value: temp,
                      child: Text("$temp°C"),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                  setState(() {
                  selectedTemp = newValue!;
                  });
                  },
                  underline: SizedBox(),
                  dropdownColor: Colors.white,
                ),
              ),
            ],
          ),
          SizedBox(height: 20,)

        ],
      ),
    );
  }
}
