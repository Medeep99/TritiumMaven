
// import 'package:flutter/material.dart';
// import 'package:fl_chart/fl_chart.dart';
// import 'package:intl/intl.dart';
// import 'package:maven/feature/ml_model/calorie_record.dart';


// class CalorieBurntLineChart extends StatelessWidget {
//   final List<CalorieRecord> calorieHistory;

//   const CalorieBurntLineChart({Key? key, required this.calorieHistory}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     if (calorieHistory.isEmpty) {
//       return Center(
//         child: Text(
//           'No calorie data available',
//           style: TextStyle(color: Colors.grey),
//         ),
//       );
//     }

//     return Container(
      
      
//       height: 150, // Set a fixed height for the chart
//       padding: EdgeInsets.all(16),

//       decoration: BoxDecoration(
//         color: Theme.of(context).colorScheme.secondaryContainer,
//         borderRadius: BorderRadius.circular(16),
        
        
//       ),
//       child: LineChart(
//         LineChartData(
//           gridData: FlGridData(show: false),
//           titlesData: FlTitlesData(
//             bottomTitles: AxisTitles(
//               sideTitles: SideTitles(
//                 showTitles: true,
//                 getTitlesWidget: (value, meta) {
//                   final index = value.toInt();
//                   if (index >= 0 && index < (calorieHistory.length) && calorieHistory[index].calories!= 0.00 ) {
                   
//                     final date = calorieHistory[index].timestamp;
//                     return Text(
//                       DateFormat('MM/dd').format(date),
//                       style: TextStyle(fontSize: 10),
//                     );
//                   }
                  
//                   return Text('');
//                 },
//               ),
//             ),
//             leftTitles: AxisTitles(
//               sideTitles: SideTitles(
//                 showTitles: true,
//                 getTitlesWidget: (value, meta) {
//                   return Text(
//                     value.toInt().toString(),
//                     style: TextStyle(fontSize: 10),
//                   );
//                 },
//               ),
//             ),
//             rightTitles: AxisTitles(
//               sideTitles: SideTitles(showTitles: false),
//             ),
//             topTitles: AxisTitles(
//               sideTitles: SideTitles(showTitles: false),
//             ),
//           ),
//           borderData: FlBorderData(show: false),
//           lineBarsData: [
//             LineChartBarData(
//               spots: calorieHistory.asMap().entries.map((entry) {
//                 final index = entry.key;
//                 final record = entry.value;
//                 return FlSpot(index.toDouble(), record.calories);
//               }).toList(),
//               isCurved: false,
//               color: Colors.orange,
//               dotData: FlDotData(show: false),
//               belowBarData: BarAreaData(show: false),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }



// import 'package:flutter/material.dart';
// import 'package:fl_chart/fl_chart.dart';
// import 'package:intl/intl.dart';
// import 'package:maven/feature/ml_model/calorie_record.dart';
// import 'package:maven/feature/theme/theme.dart';

// class CalorieBurntLineChart extends StatelessWidget {
//   final List<CalorieRecord> calorieHistory;

//   const CalorieBurntLineChart({Key? key, required this.calorieHistory}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     if (calorieHistory.isEmpty) {
//       return Center(
//         child: Text(
//           'No calorie data available',
//           style: TextStyle(color: Colors.grey),
//         ),
//       );
//     }

//     // Generate data points dynamically
//     final List<FlSpot> spots = [];
//     final List<String> xLabels = [];

//     for (int i = 0; i < calorieHistory.length; i++) {
//       final record = calorieHistory[i];

//       if (record.calories > 0) { // Only include non-zero calorie values
//         spots.add(FlSpot(i.toDouble(), record.calories));
//         xLabels.add(DateFormat('MM/dd').format(record.timestamp));
//       }
//     }

//     return Container(
//       height: 200,
//       padding: EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Theme.of(context).colorScheme.secondaryContainer,
//         borderRadius: BorderRadius.circular(16),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             'Calories Burnt',
//             style:  T(context).textStyle.titleMedium
//           ),
//           SizedBox(height: 8),
//           Expanded(
//             child: LineChart(
//               LineChartData(
//                 gridData: FlGridData(show: true),
//                 titlesData: FlTitlesData(
//                   bottomTitles: AxisTitles(
//                     sideTitles: SideTitles(
//                       showTitles: true,
//                       getTitlesWidget: (value, meta) {
//                         int index = value.toInt();
//                         if (index >= 0 && index < xLabels.length) {
//                           return Text(
//                             xLabels[index],
//                             style: TextStyle(fontSize: 10),
//                           );
//                         }
//                         return SizedBox.shrink();
//                       },
//                     ),
//                   ),
//                   leftTitles: AxisTitles(
//                     sideTitles: SideTitles(
//                       showTitles: true,
//                       getTitlesWidget: (value, meta) {
//                         return Text(
//                           value.toInt().toString(),
//                           style: TextStyle(fontSize: 10),
//                         );
//                       },
//                     ),
//                   ),
//                   rightTitles: AxisTitles(
//                     sideTitles: SideTitles(showTitles: false),
//                   ),
//                   topTitles: AxisTitles(
//                     sideTitles: SideTitles(showTitles: false),
//                   ),
//                 ),
//                 borderData: FlBorderData(show: false),
//                 lineBarsData: [
//                   LineChartBarData(
//                     spots: spots,
//                     isCurved: false,
//                     color: Colors.orange,
//                     dotData: FlDotData(show: true),
//                     belowBarData: BarAreaData(show: false),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:maven/feature/ml_model/calorie_record.dart';
import 'package:maven/feature/theme/theme.dart';

class CalorieBurntLineChart extends StatelessWidget {
  final List<CalorieRecord> calorieHistory;

  const CalorieBurntLineChart({Key? key, required this.calorieHistory}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (calorieHistory.isEmpty) {
      return Center(
        child: Text(
          'No calorie data available',
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    // Generate data points dynamically
    final List<FlSpot> spots = [];
    final List<String> xLabels = [];

    for (int i = 0; i < calorieHistory.length; i++) {
      final record = calorieHistory[i];

      if (record.calories > 0) { // Only include non-zero calorie values
        spots.add(FlSpot(spots.length.toDouble(), record.calories));
        xLabels.add(DateFormat('MM/dd').format(record.timestamp));
      }
    }

    // return Container(
    //   height: 200,
    //   padding: EdgeInsets.all(16),
    //   decoration: BoxDecoration(
    //     color: Theme.of(context).colorScheme.secondaryContainer,
    //     borderRadius: BorderRadius.circular(16),
    //   ),
    //   child: Column(
    //     crossAxisAlignment: CrossAxisAlignment.start,
    //     children: [
    //       Text(
    //         'Calories Burnt',
    //         style: T(context).textStyle.titleMedium,
    //       ),
    //       SizedBox(height: 8),
    //       Expanded(
    //         child: LineChart(
    //           LineChartData(
    //             gridData: FlGridData(show: false),
    //             titlesData: FlTitlesData(
    //               bottomTitles: AxisTitles(
    //                 sideTitles: SideTitles(
    //                   showTitles: true,
    //                   getTitlesWidget: (value, meta) {
    //                     int index = value.toInt();
    //                     if (index >= 0 && index < spots.length) {
    //                       return Padding(
    //                         padding: const EdgeInsets.only(top: 4.0),
    //                         child: Text(
    //                           xLabels[index],
    //                           style: TextStyle(fontSize: 10),
    //                         ),
    //                       );
    //                     }
    //                     return SizedBox.shrink();
    //                   },
    //                   interval: 1, // Ensure correct spacing
    //                 ),
    //               ),
    //               leftTitles: AxisTitles(
    //                 sideTitles: SideTitles(
    //                   showTitles: true,
    //                   getTitlesWidget: (value, meta) {
    //                     return Text(
    //                       value.toInt().toString(),
    //                       style: TextStyle(fontSize: 10),
    //                     );
    //                   },
    //                 ),
    //               ),
    //               rightTitles: AxisTitles(
    //                 sideTitles: SideTitles(showTitles: false),
    //               ),
    //               topTitles: AxisTitles(
    //                 sideTitles: SideTitles(showTitles: false),
    //               ),
    //             ),
    //             borderData: FlBorderData(show: false),
    //             lineBarsData: [
    //               LineChartBarData(
    //                 spots: spots,
    //                 isCurved: false,
    //                 color: Colors.orange,
    //                 dotData: FlDotData(show: true),
    //                 belowBarData: BarAreaData(show: false),
    //               ),
    //             ],
    //           ),
    //         ),
    //       ),
    //     ],
    //   ),
    // );
    return Container(
  margin: EdgeInsets.only(bottom: 16), // Added bottom margin
  height: 200,
  padding: EdgeInsets.all(16),
  decoration: BoxDecoration(
    color: Theme.of(context).colorScheme.secondaryContainer,
    borderRadius: BorderRadius.circular(16),
  ),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        'Calories Burnt',
        style: T(context).textStyle.titleMedium,
      ),
      SizedBox(height: 8),
      Expanded(
        child: LineChart(
          LineChartData(
            gridData: FlGridData(show: false),
            titlesData: FlTitlesData(
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) {
                    int index = value.toInt();
                    if (index >= 0 && index < spots.length) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: Text(
                          xLabels[index],
                          style: TextStyle(fontSize: 10),
                        ),
                      );
                    }
                    return SizedBox.shrink();
                  },
                  interval: 1, // Ensure correct spacing
                ),
              ),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) {
                    return Text(
                      value.toInt().toString(),
                      style: TextStyle(fontSize: 10),
                    );
                  },
                ),
              ),
              rightTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              topTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
            ),
            borderData: FlBorderData(show: false),
            lineBarsData: [
              LineChartBarData(
                spots: spots,
                isCurved: false,
                color: Colors.orange,
                dotData: FlDotData(show: true),
                belowBarData: BarAreaData(show: false),
              ),
            ],
          ),
        ),
      ),
    ],
  ),
);

  }
}
