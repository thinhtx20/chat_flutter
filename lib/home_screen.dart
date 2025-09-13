import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import 'ChatScreen/chatbot_screen.dart';
import 'Image/Ai_image.dart';
import 'login_firebase.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('AI Assistant'),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) => const LoginPopup(),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            Container(
              height: 120,
              margin: EdgeInsets.symmetric(vertical: 10.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Center(
                child: ListTile(
                  contentPadding: EdgeInsets.all(16.0),
                  leading: Lottie.asset('assets/lottie/ai_hand_waving.json', width: 120, height: 120),
                  title: Text('AI ChatBot', style: TextStyle(fontSize: 20)),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ChatPage()),
                    );
                  },
                ),
              ),
            ),
            // Container(
            //   height: 120,
            //   margin: EdgeInsets.symmetric(vertical: 10.0),
            //   decoration: BoxDecoration(
            //     color: Colors.white,
            //     borderRadius: BorderRadius.circular(8.0),
            //     boxShadow: [
            //       BoxShadow(
            //         color: Colors.grey.withOpacity(0.5),
            //         spreadRadius: 2,
            //         blurRadius: 4,
            //         offset: Offset(0, 2),
            //       ),
            //     ],
            //   ),
            //   child: Center(
            //     child: ListTile(
            //       contentPadding: EdgeInsets.all(16.0),
            //       leading: Lottie.asset('assets/lottie/ai_play.json', width: 120, height: 120),
            //       title: Text('AI Image', style: TextStyle(fontSize: 20)),
            //       onTap: () {
            //         Navigator.push(
            //           context,
            //           MaterialPageRoute(builder: (context) => LicensePlateScreen()),
            //         );
            //       },
            //     ),
            //   ),
            // ),
          ],
        ),
      )
    );
  }

}