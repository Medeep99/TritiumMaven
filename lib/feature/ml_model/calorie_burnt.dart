

import 'dart:convert';
import 'package:http/http.dart' as http;

Future<String> getPrediction(Map<String, dynamic> inputData) async {
  // final String url = 'http://10.0.2.2:5005/predict'; // Emulator localhost
  
final String url = 'http://192.168.31.125:5005/predict' ; //physical phone host
// final String url = 'http://192.168.1.105:5005/predict' ; //physical phone host
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

    // if (response.statusCode == 200) {
    //   final Map<String, dynamic> decodedResponse = jsonDecode(response.body);
      
    //   if (decodedResponse['status'] == 'success') {
    //     return decodedResponse['prediction'].toString();
    //   } else {
    //     return 'Error: ${decodedResponse['message']}';
    //   }
    // } else {
    //   return 'Error: ${response.reasonPhrase}';
    // }
    if (response.statusCode == 200) {
      final Map<String, dynamic> decodedResponse = jsonDecode(response.body);

      if (decodedResponse['status'] == 'success' && decodedResponse.containsKey('prediction')) {
        return decodedResponse['prediction'].toString();
      } else {
        print('API Error: ${decodedResponse['message']}');
        return '500'; // API returned an error message
      }
    } else {
      print('HTTP Error: ${response.statusCode} - ${response.reasonPhrase}');
      return '404'; // API response was not successful
    }
  } catch (e) {
    return 'Error: $e';
  }

  
}