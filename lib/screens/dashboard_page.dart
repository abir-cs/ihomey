import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {

  final List<_BarData> temperatureData = [
    const _BarData(Colors.transparent, 20, 20),
    const _BarData(Color(0xFF273D59), 20, 20),
    const _BarData(Color(0xFF273D59), 10, 10),
    const _BarData(Color(0xFF273D59), 30, 30),
    const _BarData(Color(0xFF273D59), 35, 45),
    const _BarData(Color(0xFF273D59), 28, 2.5),
    const _BarData(Color(0xFF273D59), 0, 2),
    const _BarData(Color(0xFF273D59), 0, 2),
  ];

    final List<_BarData> humidityData = [
    const _BarData(Colors.transparent, 20, 20),
    const _BarData(Color(0xFF273D59), 45, 20),
    const _BarData(Color(0xFF273D59), 30, 10),
    const _BarData(Color(0xFF273D59), 40, 30),
    const _BarData(Color(0xFF273D59), 35, 45),
    const _BarData(Color(0xFF273D59), 28, 2.5),
    const _BarData(Color(0xFF273D59), 0, 2),
    const _BarData(Color(0xFF273D59), 0, 2),
  ];

  BarChartGroupData generateBarGroup(
    int x,
    Color color,
    double value,
    double shadowValue,
  ) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: value,
          color: color,
          width: 25,
          borderRadius: BorderRadius.circular(8),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF0E7D6),
      appBar: AppBar(
        backgroundColor: Color(0xFFF0E7D6),
        title: Text(
          "Statistics",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          children: [
          SizedBox(height : 20),
          Container(
          width: 370, height: 300,
          decoration: BoxDecoration(
                  color:  Color(0xFFF4F4F4),
                  borderRadius: BorderRadius.circular(16),
                ),
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(child: Container()),
                  const Text(
                    'Temperature Dashboard',
                    style: TextStyle(
                      color: Color(0xFF1B2635),
                      fontSize: 17,
                    ),
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerRight,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              AspectRatio(
                aspectRatio: 1.6,
                child: BarChart(
                  BarChartData(
                    alignment: BarChartAlignment.spaceBetween, 
                    borderData: FlBorderData(
                      show: true,
                      border: Border.symmetric(
                        horizontal: BorderSide(
                          color: Colors.black.withOpacity(0.2),
                        ),
                      ),
                    ),
                    titlesData: FlTitlesData(
                      show: true,
                      leftTitles: const AxisTitles(
                        drawBelowEverything: true,
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 30,
                        ),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 36,
                          getTitlesWidget: (value, meta) {
                            final index = value.toInt();
                            final days = [' ','Mon.', 'Tue.', 'Wed.', 'Thu.', 'Fri.', 'Sat.', 'Sun.'];

                            return SideTitleWidget(
                              meta: meta,
                              child: Text(
                                days[index],
                                style: TextStyle(color: Color(0xFF1B2635)),
                              ),
                            );
                          },
                        ),
                      ),
                      rightTitles: const AxisTitles(),
                      topTitles: const AxisTitles(),
                    ),
                    gridData: FlGridData(
                      show: true,
                      drawVerticalLine: false,
                      getDrawingHorizontalLine: (value) => FlLine(
                        color: Colors.black.withOpacity(0.2),
                        strokeWidth: 1,
                      ),
                    ),
                    barGroups: temperatureData.asMap().entries.map((e) {
                      final index = e.key;
                      final data = e.value;
                      return generateBarGroup(
                        index,
                        data.color,
                        data.value,
                        data.shadowValue,
                      );
                    }).toList(),
                    maxY: 50,
                    barTouchData: BarTouchData(
                      enabled: true,
                      handleBuiltInTouches: false,
                      touchTooltipData: BarTouchTooltipData(
                        getTooltipColor: (group) => Colors.transparent,
                        tooltipMargin: 0,
                        getTooltipItem: (
                          BarChartGroupData group,
                          int groupIndex,
                          BarChartRodData rod,
                          int rodIndex,
                        ) {
                          return BarTooltipItem(
                            rod.toY.toString(),
                            TextStyle(
                              fontWeight: FontWeight.bold,
                              color: rod.color,
                              fontSize: 18,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        SizedBox(height : 40),

                Container(
          width: 370, height: 300,
          decoration: BoxDecoration(
                  color:  Color(0xFFF4F4F4),
                  borderRadius: BorderRadius.circular(16),
                ),
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(child: Container()),
                  const Text(
                    'Humidity Dashboard',
                    style: TextStyle(
                      color: Color(0xFF1B2635),
                      fontSize: 17,
                    ),
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerRight,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              AspectRatio(
                aspectRatio: 1.6,
                child: BarChart(
                  BarChartData(
                    alignment: BarChartAlignment.spaceBetween, 
                    borderData: FlBorderData(
                      show: true,
                      border: Border.symmetric(
                        horizontal: BorderSide(
                          color: Colors.black.withOpacity(0.2),
                        ),
                      ),
                    ),
                    titlesData: FlTitlesData(
                      show: true,
                      leftTitles: const AxisTitles(
                        drawBelowEverything: true,
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 30,
                        ),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 36,
                          getTitlesWidget: (value, meta) {
                            final index = value.toInt();
                            final days = [' ','Mon.', 'Tue.', 'Wed.', 'Thu.', 'Fri.', 'Sat.', 'Sun.'];

                            return SideTitleWidget(
                              meta: meta,
                              child: Text(
                                days[index],
                                style: TextStyle(color: Color(0xFF1B2635)),
                              ),
                            );
                          },
                        ),
                      ),
                      rightTitles: const AxisTitles(),
                      topTitles: const AxisTitles(),
                    ),
                    gridData: FlGridData(
                      show: true,
                      drawVerticalLine: false,
                      getDrawingHorizontalLine: (value) => FlLine(
                        color: Colors.black.withOpacity(0.2),
                        strokeWidth: 1,
                      ),
                    ),
                    barGroups: humidityData.asMap().entries.map((e) {
                      final index = e.key;
                      final data = e.value;
                      return generateBarGroup(
                        index,
                        data.color,
                        data.value,
                        data.shadowValue,
                      );
                    }).toList(),
                    maxY: 70,
                    barTouchData: BarTouchData(
                      enabled: true,
                      handleBuiltInTouches: false,
                      touchTooltipData: BarTouchTooltipData(
                        getTooltipColor: (group) => Colors.transparent,
                        tooltipMargin: 0,
                        getTooltipItem: (
                          BarChartGroupData group,
                          int groupIndex,
                          BarChartRodData rod,
                          int rodIndex,
                        ) {
                          return BarTooltipItem(
                            rod.toY.toString(),
                            TextStyle(
                              fontWeight: FontWeight.bold,
                              color: rod.color,
                              fontSize: 18,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

          ],
        )
        

      ),
    );
  }
}

class _BarData {
  const _BarData(this.color, this.value, this.shadowValue);

  final Color color;
  final double value;
  final double shadowValue;
}
