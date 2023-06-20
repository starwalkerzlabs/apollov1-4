import 'package:http/http.dart' as http;

class ChatGPTService {
  final String apiUrl = 'https://api.openai.com/v1/chat/completions'; // Update the API endpoint here
  final String apiKey = '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'; // Replace with your OpenAI API key

  Future<String> sendMessage(String message) async {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {'Authorization': 'Bearer $apiKey'},
      body: {'messages': [{'role': 'system', 'content': 'You are a user'}, {'role': 'user', 'content': message}]},
    );

    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to send message to ChatGPT API');
    }
  }
}

