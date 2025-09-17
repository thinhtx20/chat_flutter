import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'chat_controller.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final ChatController _c = Get.put(ChatController());

  @override
  void initState() {
    super.initState();

    // 👇 Auto scroll xuống cuối khi có tin nhắn mới
    ever(_c.list, (_) {
      Future.delayed(const Duration(milliseconds: 100), () {
        if (_c.scrollC.hasClients) {
          _c.scrollC.animateTo(
            _c.scrollC.position.maxScrollExtent, // 👈 cuộn xuống cuối
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    });
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
        title: const Text('Chat với AI Grok'),
        scrolledUnderElevation: 0,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _c.textC,
                textAlign: TextAlign.left,
                minLines: 1,
                maxLines: 3,
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
              child: Obx(() => _c.isLoading.value
                  ? const CircularProgressIndicator(color: Colors.white)
                  : IconButton(
                onPressed: _c.askQuestion,
                icon: const Icon(Icons.rocket_launch_rounded,
                    color: Colors.white, size: 28),
              )),
            ),
          ],
        ),
      ),
      body: Obx(() => ListView(
        physics: const BouncingScrollPhysics(),
        controller: _c.scrollC,
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).size.height * .02,
          bottom: MediaQuery.of(context).size.height * .1,
        ),
        children: _c.list.map((e) {
          final isUser = e['role'] == 'user';
          return Align(
            alignment:
            isUser ? Alignment.centerRight : Alignment.centerLeft,
            child: Container(
              margin:
              const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color:
                isUser ? Colors.blueAccent : Colors.grey.shade300,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                e['content'] ?? '',
                style: TextStyle(
                  color: isUser ? Colors.white : Colors.black87,
                ),
              ),
            ),
          );
        }).toList(),
      )),
    );
  }
}
