// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:maven/database/database.dart';

// import 'dart:convert';
// import 'package:http/http.dart' as http;

// Future<String> getPrediction(Map<String, dynamic> inputData) async {
//   final String url = 'http://10.0.2.2:5002/predict'; // Emulator localhost

//   try {
//     // Format data to match the test function (values as lists)
//     final formattedInputData = {
//       'Gender': [inputData['Gender']],  // Convert to list
//       'Age': [inputData['Age']],  
//       'Height': [inputData['Height']],  
//       'Weight': [inputData['Weight']],  
//       'Duration': [inputData['Duration']],  
//       'Heart_Rate': [inputData['Heart_Rate']],  
//       'Body_Temp': [inputData['Body_Temp']],  
//     };

//     final response = await http.post(
//       Uri.parse(url),
//       headers: {"Content-Type": "application/json"},
//       body: jsonEncode(formattedInputData),
//     );

//    if (response.statusCode == 200) {
//       final dynamic decodedResponse = jsonDecode(response.body);

//       if (decodedResponse is List) {
//         // If the response is a list, take the first item
//         final Map<String, dynamic> responseData = decodedResponse.first;
//         return responseData['prediction'].toString();
//       } else if (decodedResponse is Map<String, dynamic>) {
//         // If it's already a map, extract prediction normally
//         return decodedResponse['prediction'].toString();
//       } else {
//         return 'Error: Unexpected response format';
//       }
//     } else {
//       return 'Error: ${response.reasonPhrase}';
//     }
//   } catch (e) {
//     return 'Error: $e';
//   }
// }

import 'dart:convert';
import 'package:http/http.dart' as http;

Future<String> getPrediction(Map<String, dynamic> inputData) async {
  final String url = 'http://10.0.2.2:5005/predict'; // Emulator localhost

  try {
    // Format data to match the expected format
    final formattedInputData = {
      'Gender': [inputData['Gender']],
      'Age': [inputData['Age']],
      'Height': [inputData['Height']],
      'Weight': [inputData['Weight']],
      'Duration': [inputData['Duration']],
      'Heart_Rate': [inputData['Heart_Rate']],
      'Body_Temp': [inputData['Body_Temp']],
    };

    final response = await http.post(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(formattedInputData),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> decodedResponse = jsonDecode(response.body);
      
      if (decodedResponse['status'] == 'success') {
        return decodedResponse['prediction'].toString();
      } else {
        return 'Error: ${decodedResponse['message']}';
      }
    } else {
      return 'Error: ${response.reasonPhrase}';
    }
  } catch (e) {
    return 'Error: $e';
  }
}