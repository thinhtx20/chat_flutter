import 'dart:convert';

import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;

class ChatController extends GetxController {
  final TextEditingController textC = TextEditingController();
  final ScrollController scrollC = ScrollController();
  final RxList<Map<String, String>> list = <Map<String, String>>[].obs; // Explicitly typed RxList
  final String apiKey = "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";
  final String apiUrl = "https://api.groq.com/openai/v1/chat/completions";

  final isLoading = false.obs;
  late Box chatBox;

  @override
  void onInit() {
    super.onInit();
    chatBox = Hive.box('chatBox');

    // Load lịch sử chat khi mở app
    final saved = chatBox.get('messages', defaultValue: []);
    if (saved is List && saved.isNotEmpty) {
      list.addAll(saved.map((e) => Map<String, String>.from(e)));
    } else {
      // 👇 Nếu chưa có dữ liệu, thêm tin nhắn chào mặc định
      list.add({
        "role": "assistant",
        "content": "Xin chào! Tôi có thể giúp gì cho bạn về luật của Việt Nam?"
      });
      saveMessages();
    }
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
          "model": "meta-llama/llama-4-scout-17b-16e-instruct",
          "messages": [
            {
              "role": "system",
              "content":
              "Bạn là một trợ lý pháp luật. Bạn chỉ trả lời các câu hỏi liên quan đến luật pháp Việt Nam. "
                  "Nếu câu hỏi không liên quan đến luật Việt Nam, hãy trả lời đúng một câu: "
                  "\"Câu hỏi của bạn không nằm trong lĩnh vực luật Việt Nam.\""
            },
            {
              "role": "user",
              "content": userPrompt
            }
          ],
          "max_tokens": 1000,
          "temperature": 0.3, // giảm để AI trả lời chính xác, ít sáng tạo
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
    saveMessages();
  }

  void saveMessages() {
    chatBox.put('messages', list.toList());
  }
}
