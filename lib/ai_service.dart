import 'dart:convert';
import 'package:http/http.dart' as http;

class AIService {
  static const String apiKey = 'sk-proj-jKXqCRlSh2ryqGVQ8ep0T3BlbkFJepiHUYTbtTnxHbUQ8xKY';
  static const String apiUrl = 'https://api.openai.com/v1/chat/completions';

  static Future<String> getResponse(String prompt) async {
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey',
        },
        body: jsonEncode({
          'model': 'gpt-3.5-turbo',
          'messages': [
            {'role': 'user', 'content': prompt}
          ],
          'max_tokens': 150,
          'n': 1,
          'temperature': 0.7,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['choices'][0]['message']['content'].trim();
      } else {
        print('Error response: ${response.body}');
        throw Exception('Failed to get AI response: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception occurred: $e');
      throw Exception('Failed to get AI response');
    }
  }

  static Future<bool> checkApiKey() async {
    const String checkUrl = 'https://api.openai.com/v1/models';

    try {
      final response = await http.get(
        Uri.parse(checkUrl),
        headers: {
          'Authorization': 'Bearer $apiKey',
        },
      );

      if (response.statusCode == 200) {
        print('API key is valid. Available models: ${response.body}');
        return true;
      } else {
        print('API key is invalid. Status code: ${response.statusCode}');
        print('Error message: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error occurred while checking API key: $e');
      return false;
    }
  }
}

void main() async {
  // First, check if the API key is valid
  bool isValid = await AIService.checkApiKey();
  print('Is API key valid? $isValid');

  if (isValid) {
    // If the key is valid, try to get a response
    try {
      String response = await AIService.getResponse("Hello, how are you?");
      print('AI Response: $response');
    } catch (e) {
      print('Error getting AI response: $e');
    }
  }
}