// import 'package:flutter/material.dart';
//
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
//
// class ChatScreen extends StatefulWidget {
//   static String routeName = 'ChatScreen';
//   @override
//   _ChatScreenState createState() => _ChatScreenState();
// }
//
//
//
// class _ChatScreenState extends State<ChatScreen> {
//   TextEditingController _controller = TextEditingController();
//   List<String> _messages = [];
//
//   final String apiUrl = 'https://api.openai.com/v1/chat/completions'; // Update this URL with the correct endpoint
//
//   Future<void> main(List<String> arg) async {
//
//   }
//   Future<String?> callGPT (String prompt) async {
//
//     const apiKey = 'Bearer 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';
//     const apiUrl = 'https://api.openai.com/v1/chat/completions';
//
//     final headers = {
//       'Content-Type': 'application/json',
//       'Authorization': apiKey,
//     };
//
//     final body = jsonEncode(
//         {
//           "model": "text-davinci-003",
//           "prompt": prompt,
//           'max_tokens': 7
//         }
//     );
//
//     final response = await http.post(
//         Uri.parse(apiUrl),
//         headers: headers,
//         body: body
//     );
//     if(response.statusCode ==200){
//       final jsonResponse = jsonDecode(response.body);
//       final result = jsonResponse['choices'][0]['text'];
//       return result.toString().trim();
//     }else{
//       print('Failed to call GPT ${response.statusCode}');
//     }
//   }
//
//
//
//   Future<void> _sendMessage(String message) async {
//     setState(() {
//       _messages.add("Me: $message");
//     });
//
//     try {
//       const apiKey = 'Bearer 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';
//       const apiUrl = 'https://api.openai.com/v1/chat/completions';
//
//       final headers = {
//         'Content-Type': 'application/json',
//         'Authorization': apiKey,
//       };
//
//       final body = jsonEncode(
//           {
//             "model": "text-davinci-003",
//             "prompt": message,
//             'max_tokens': 7
//           }
//       );
//
//       final response = await http.post(
//           Uri.parse(apiUrl),
//           headers: headers,
//           body: body
//       );
//       if(response.statusCode ==200){
//         final jsonResponse = jsonDecode(response.body);
//         final result = jsonResponse['choices'][0]['text'];
//
//       }else{
//         print('Failed to call GPT ${response.statusCode}');
//       }
//     } catch (e) {
//       print('Error: $e');
//     }
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Doctor\'s AI'),
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: ListView.builder(
//               itemCount: _messages.length,
//               itemBuilder: (context, index) {
//                 return ListTile(
//                   title: Text(_messages[index]),
//                 );
//               },
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: TextField(
//                     controller: _controller,
//                     decoration: InputDecoration(hintText: 'Type a message...'),
//                   ),
//                 ),
//                 IconButton(
//                   icon: Icon(Icons.send),
//                   onPressed: () {
//                     String message = _controller.text;
//                     if (message.isNotEmpty) {
//                       _sendMessage(message);
//                       _controller.clear();
//                     }
//                   },
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
