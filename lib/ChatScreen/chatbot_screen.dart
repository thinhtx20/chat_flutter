import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import 'message_card.dart';

class ChatController extends GetxController {
  final TextEditingController textC = TextEditingController();
  final ScrollController scrollC = ScrollController();
  final RxList<Map<String, String>> list = <Map<String, String>>[].obs; // Explicitly typed RxList
  final String apiKey = "";
  final String apiUrl = "https://api.groq.com/openai/v1/chat/completions";

  @override
  void onInit() {
    super.onInit();

  }

  @override
  void onClose() {
    textC.dispose();
    scrollC.dispose();
    super.onClose();
  }

  Future<void> askQuestion() async {
    String userPrompt = textC.text;
    if (userPrompt.isEmpty) return;

    list.add({"role": "user", "content": userPrompt});

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          "Authorization": "Bearer $apiKey",
          "Content-Type": "application/json",
          "X-Title": "chatbot",
        },
        body: jsonEncode({
          "model": "openai/gpt-oss-120b",
          "messages": [{"role": "user", "content": userPrompt}],
          "max_tokens": 1000,
          "temperature": 0.7,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final aiResponse = data['choices'][0]['message']['content'];
        print(aiResponse);
        list.add({"role": "assistant", "content": aiResponse});
      } else {
        list.add({"role": "assistant", "content": "Lỗi API: ${response.statusCode} - ${response.body}"});
      }
    } catch (e) {
      list.add({"role": "assistant", "content": "Lỗi kết nối: $e. Vui lòng kiểm tra API Key hoặc mạng."});
    }

    textC.clear();
    scrollC.animateTo(
      scrollC.position.maxScrollExtent,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
    update(); // Ensure UI updates
  }
}


class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final ChatController _c = Get.put(ChatController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _c.list.add({"role": "assistant", "content": 'Xin chào tôi có thể giúp gì cho bạn?'});
  }
  @override
  void dispose() {
    Get.delete<ChatController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat with AI Grok'),
        scrolledUnderElevation: 0,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Row(children: [
          Expanded(
            child: TextFormField(
              controller: _c.textC,
              textAlign: TextAlign.center,
              onTapOutside: (e) => FocusScope.of(context).unfocus(),
              decoration: InputDecoration(
                fillColor: Theme.of(context).scaffoldBackgroundColor,
                filled: true,
                isDense: true,
                hintText: 'Nhập tin nhắn...',
                hintStyle: const TextStyle(fontSize: 14),
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(50)),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          CircleAvatar(
            radius: 24,
            backgroundColor: Colors.red,
            child: IconButton(
              onPressed: _c.askQuestion,
              icon: const Icon(Icons.rocket_launch_rounded, color: Colors.white, size: 28),
            ),
          ),
        ]),
      ),
      body: Obx(
            () => ListView(
          physics: const BouncingScrollPhysics(),
          controller: _c.scrollC,
          padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * .02, bottom: MediaQuery.of(context).size.height * .1),
          children: _c.list.map((e) => MessageCard(message: e)).toList(),
        ),
      ),
    );
  }
}