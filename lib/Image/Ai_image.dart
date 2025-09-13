// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
//
// class LicensePlateScreen extends StatefulWidget {
//   const LicensePlateScreen({super.key});
//
//   @override
//   _LicensePlateScreenState createState() => _LicensePlateScreenState();
// }
//
// class _LicensePlateScreenState extends State<LicensePlateScreen> {
//   File? _image;
//   String _plateNumber = 'Chưa có kết quả';
//   final ImagePicker _picker = ImagePicker();
//
//   // OCR recognizer của Google ML Kit
//   final TextRecognizer _textRecognizer =
//   TextRecognizer(script: TextRecognitionScript.latin);
//
//   // Chụp ảnh từ camera
//   Future<void> _takePicture() async {
//     final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
//     if (photo != null) {
//       setState(() {
//         _image = File(photo.path);
//         _plateNumber = 'Đang xử lý...';
//       });
//       await _processImage(photo.path);
//     }
//   }
//
//   // Chọn ảnh từ thư viện
//   Future<void> _pickImage() async {
//     final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
//     if (image != null) {
//       setState(() {
//         _image = File(image.path);
//         _plateNumber = 'Đang xử lý...';
//       });
//       await _processImage(image.path);
//     }
//   }
//
//   // Hàm xử lý ảnh bằng Google ML Kit OCR
//   Future<void> _processImage(String imagePath) async {
//     try {
//       final inputImage = InputImage.fromFilePath(imagePath);
//       final recognizedText = await _textRecognizer.processImage(inputImage);
//
//       final rawText = recognizedText.text;
//       // Regex cho biển số xe VN: 2 số + 1 chữ + 4–5 số, có thể có dấu gạch
//       final match = rawText;
//
//       print(match);
//       setState(() {
//         if (match.isNotEmpty) {
//           _plateNumber = match;
//         } else {
//           _plateNumber = 'Không nhận diện được biển số';
//         }
//       });
//     } catch (e) {
//       setState(() {
//         _plateNumber = 'Lỗi xử lý: $e';
//       });
//     }
//   }
//
//   @override
//   void dispose() {
//     _textRecognizer.close();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Nhận Diện Biển Số Xe'),
//         centerTitle: true,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             // Hiển thị ảnh
//             Container(
//               height: 200,
//               width: double.infinity,
//               decoration: BoxDecoration(
//                 border: Border.all(color: Colors.grey),
//                 borderRadius: BorderRadius.circular(10),
//               ),
//               child: _image == null
//                   ? const Center(child: Text('Chưa có ảnh được chọn'))
//                   : ClipRRect(
//                 borderRadius: BorderRadius.circular(10),
//                 child: Image.file(
//                   _image!,
//                   fit: BoxFit.cover,
//                 ),
//               ),
//             ),
//             const SizedBox(height: 20),
//             // Nút chọn ảnh
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 ElevatedButton.icon(
//                   onPressed: _takePicture,
//                   icon: const Icon(Icons.camera_alt),
//                   label: const Text('Chụp ảnh'),
//                 ),
//                 ElevatedButton.icon(
//                   onPressed: _pickImage,
//                   icon: const Icon(Icons.photo_library),
//                   label: const Text('Chọn ảnh'),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 20),
//             // Hiển thị kết quả
//             Card(
//               elevation: 4,
//               child: Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Column(
//                   children: [
//                     const Text(
//                       'Kết quả nhận diện:',
//                       style:
//                       TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                     ),
//                     const SizedBox(height: 10),
//                     Text(
//                       _plateNumber,
//                       style: const TextStyle(fontSize: 16),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
