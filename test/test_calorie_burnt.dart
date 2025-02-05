import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_test/flutter_test.dart';

// Function to get prediction from the Flask API
Future<void> getPrediction() async {
  // Define the URL for your Flask server (running locally)
  final String url = 'http://127.0.0.1:5002/predict';

  // Create sample input data (as per your model's input format)
  final Map<String, dynamic> sampleData = {
    'Gender': ['male'],
    'Age': [23],
    'Height': [210.0],
    'Weight': [84.0],
    'Duration': [45.0],
    'Heart_Rate': [180.0],
    'Body_Temp': [40.8],
  };

  // Send POST request to Flask API
  final response = await http.post(
    Uri.parse(url),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode(sampleData),
  );

  // Check the response
  if (response.statusCode == 200) {
    // Parse the response as JSON
    final result = jsonDecode(response.body);
    print('Prediction: $result');
  } else {
    print('Failed to get prediction: ${response.statusCode}');
  }
}

void main() {
  test('Test calorie burn prediction API', () async {
    // Call the getPrediction function
    await getPrediction();
  });
}
