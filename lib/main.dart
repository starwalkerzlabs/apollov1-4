import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'APOLLO Tutorbot EMS BetaV1',
      theme: ThemeData(
        primaryColor: const Color(0xFF00BCD4),
        scaffoldBackgroundColor: const Color(0xFF212242),
        textTheme: const TextTheme(
          bodyText1: TextStyle(color: Colors.white),
          bodyText2: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      home: const MyHomePage(title: 'APOLLO Tutorbot EMS BetaV1'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _textEditingController = TextEditingController();
  final List<ChatMessage> _messages = [];
  int _characterCount = 0;

  void _sendMessage(String message) async {
    _textEditingController.clear();

    final client = http.Client();

    final response = await client.post(
      Uri.parse('https://api.openai.com/v1/chat/completions'),
      headers: {
        'Authorization': 'Bearer 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',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'messages': _getChatMessages(message),
        'model': 'gpt-3.5-turbo',
      }),
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      final chatMessage = ChatMessage(
        role: 'apollo', // Set the role as 'apollo'
        content: responseData['choices'][0]['message']['content'].replaceAll('chatgpt', 'apollo').replaceAll('openai', 'Starwalkerz'),
      );
      final userMessage = ChatMessage(
        role: 'user',
        content: message,
      );
      setState(() {
        if (userMessage.content.isNotEmpty) {
          _messages.insert(0, userMessage);
        }
        _messages.insert(0, chatMessage);
        _characterCount += message.length;
      });
    }
  }

  List<Map<String, String>> _getChatMessages(String message) {
    final List<Map<String, String>> chatMessages = [];

    if (_characterCount == 0) {
      // Add initial system message to set tone and name
      chatMessages.add({'role': 'system', 'content': 'You are a tutor. Be patient and helpful.'});
      chatMessages.add({'role': 'system', 'content': 'I am Apollo.'});
    }

    chatMessages.add({'role': 'user', 'content': message});

    if (_characterCount >= 20000) {
      // Add reminder message to set tone and name
      chatMessages.add({'role': 'system', 'content': 'I am still Apollo.'});
      _characterCount = 0;
    }

    return chatMessages;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset(
              'assets/images/apollo_desktop_logo.png',
              width: 60,
              height: 60,
            ),
            const SizedBox(width: 8),
            Text(
              widget.title,
              style: const TextStyle(color: Colors.black),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true,
              itemCount: _messages.length,
              itemBuilder: (BuildContext context, int index) {
                final chatMessage = _messages[index];
                final isUserMessage = chatMessage.role == 'user';

                if (isUserMessage) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: GestureDetector( // Added GestureDetector for the user's message
                              onLongPress: () {
                                // Copy the user's message to the clipboard
                                final data = ClipboardData(text: chatMessage.content);
                                Clipboard.setData(data);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('User message copied to clipboard')),
                                );
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: const Color(0xFF00BCD4),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                padding: const EdgeInsets.all(8.0),
                                margin: const EdgeInsets.only(left: 8.0),
                                child: Text(
                                  chatMessage.content,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  } else {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          backgroundImage: AssetImage('assets/images/apollo_profile.png'),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: GestureDetector(
                            onLongPress: () {
                              // Copy the bot's response to the clipboard
                              final data = ClipboardData(text: chatMessage.content);
                              Clipboard.setData(data);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Bot response copied to clipboard')),
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: const Color(0xFF00BCD4),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              padding: const EdgeInsets.all(8.0),
                              margin: const EdgeInsets.only(right: 64.0, left: 8.0),
                              child: Text(
                                chatMessage.content,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: TextField(
                      controller: _textEditingController,
                      decoration: const InputDecoration(
                        hintText: "What's up?",
                        hintStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                        border: InputBorder.none,
                      ),
                      style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                      onSubmitted: (value) {
                        _sendMessage(value);
                      },
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    final message = _textEditingController.text.trim();
                    if (message.isNotEmpty) {
                      _sendMessage(message);
                    }
                  },
                  icon: const Icon(Icons.send),
                  color: Colors.white,
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

class ChatMessage {
  final String role;
  final String content;

  ChatMessage({required this.role, required this.content});
}
