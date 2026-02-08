import 'dart:convert';
import 'dart:io';

Future<void> main() async {
  // Key from your firebase_options.dart
  const apiKey = 'AIzaSyAfRYoZT9c4O0flc39iROdgC1bTQkUXq88';
  final url = Uri.parse('https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=$apiKey');

  print('Testing API Key: $apiKey');

  try {
    final response = await HttpClient().postUrl(url).then((request) {
      request.headers.contentType = ContentType.json;
      request.write(jsonEncode({
        "contents": [{
          "parts": [{"text": "Hello, are you working?"}]
        }]
      }));
      return request.close();
    });

    final body = await response.transform(utf8.decoder).join();
    
    print('Status Code: ${response.statusCode}');
    if (response.statusCode == 200) {
      print('✅ SUCCESS! This API key works for Gemini/AI.');
      print('Response: $body');
    } else {
      print('❌ FAILED. This key does not have Gemini API access.');
      print('Error: $body');
    }
  } catch (e) {
    print('Network Error: $e');
  }
}
