import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';



class MessageCard extends StatelessWidget {
  final Map<String, String> message;

  const MessageCard({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    const r = Radius.circular(15);
    final isUser = message["role"] == "user";
    final content = message["content"] ?? "";

    return isUser
        ? Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Flexible(
          child: Container(
            constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * .6),
            margin: EdgeInsets.only(bottom: MediaQuery.of(context).size.height * .02, right: MediaQuery.of(context).size.width * .02),
            padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height * .01, horizontal: MediaQuery.of(context).size.width * .02),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
              borderRadius: const BorderRadius.only(topLeft: r, topRight: r, bottomLeft: r),
              color: Colors.white,
            ),
            child: Text(
              content,
              textAlign: TextAlign.right,
            ),
          ),
        ),
        const SizedBox(width: 6),
        const CircleAvatar(
          radius: 18,
          backgroundColor: Colors.white,
          child: Icon(Icons.person, color: Colors.blue),
        ),
      ],
    )
        : Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(width: 6),
        CircleAvatar(
          radius: 18,
          backgroundColor: Colors.white,
          child: Image.asset('assets/images/logo.png', width: 24, height: 24),
        ),
        Flexible(
          child: Container(
            constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * .6),
            margin: EdgeInsets.only(bottom: MediaQuery.of(context).size.height * .02, left: MediaQuery.of(context).size.width * .02),
            padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height * .01, horizontal: MediaQuery.of(context).size.width * .02),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.blue),
              borderRadius: const BorderRadius.only(topLeft: r, topRight: r, bottomRight: r),
              color: Colors.white,
            ),
            child: content.isEmpty
                ? AnimatedTextKit(
              animatedTexts: [
                TypewriterAnimatedText(
                  ' Please wait... ',
                  speed: const Duration(milliseconds: 100),
                ),
              ],
              repeatForever: true,
            )
                : Text(
              content,
              textAlign: TextAlign.left,
            ),
          ),
        ),
      ],
    );
  }
}