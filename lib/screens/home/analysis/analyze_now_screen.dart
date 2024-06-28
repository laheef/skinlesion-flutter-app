import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AnalyzeNowScreen extends StatefulWidget {
  const AnalyzeNowScreen({super.key});

  @override
  AnalyzeNowScreenState createState() => AnalyzeNowScreenState();
}

class AnalyzeNowScreenState extends State<AnalyzeNowScreen> {
  File? _image;
  final picker = ImagePicker();
  bool _loading = false;
  String? _result;

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await picker.pickImage(source: source);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future<void> _uploadImage() async {
    if (_image == null) return;

    setState(() {
      _loading = true;
    });

    try {
      // Upload to Firebase Storage
      String fileName = 'images/${DateTime.now().millisecondsSinceEpoch}.jpg';
      Reference storageRef = FirebaseStorage.instance.ref().child(fileName);
      UploadTask uploadTask = storageRef.putFile(_image!);

      TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => {});
      String downloadURL = await taskSnapshot.ref.getDownloadURL();

      // Send URL to API
      await _sendToApi(downloadURL);
    } catch (e) {
      _showSnackbar('Error: $e');
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  Future<void> _sendToApi(String downloadURL) async {
    try {
      var response = await http.post(
        Uri.parse('YOUR_API_ENDPOINT'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({'imageURL': downloadURL}),
      );

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        setState(() {
          _result = data['result'];
        });
        _showResultDialog();
      } else {
        _showSnackbar('Error: ${response.statusCode}');
      }
    } catch (e) {
      _showSnackbar('Error: $e');
    }
  }

  void _showResultDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Analysis Result'),
          content: Text(_result ?? 'No result available'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: const Color(0xff047857),
        title: const Text('Analyze the Skin',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      backgroundColor: const Color(0xfff7f7f7),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const SizedBox(height: 10),
              _buildAnalyzeNowCard(),
              const SizedBox(height: 20),
              _buildInstructions(),
              const SizedBox(height: 100),
              _image == null
                ? Text('No image selected.')
                : Image.file(_image!),
              if (_loading) CircularProgressIndicator(),
            ],
          ),
        ),
      ),
      floatingActionButton: Container(
        width: MediaQuery.of(context).size.width - 32, // Adjust the width as needed
        margin: const EdgeInsets.symmetric(horizontal: 16),
        child: FloatingActionButton.extended(
          onPressed: () async {
            await _pickImage(ImageSource.gallery); // Pick image from gallery
            if (_image != null) {
              await _uploadImage(); // Upload image if one was picked
            }
          },
          backgroundColor: const Color(0xff047857),
          icon: const Icon(color: Colors.white, Icons.camera_alt),
          label: const Text('Capture Image / Upload Image',
              style: TextStyle(color: Colors.white)),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
  Widget _buildAnalyzeNowCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.green.shade200,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.orange.withOpacity(0.5), width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Analyze Now',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const Text(
            'Get Your Skin Analyzed in Seconds',
            style: TextStyle(
              fontSize: 14,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.7),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'How to Perform analysis?',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      '5 min',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
                Image.asset('assets/videoicon.png', width: 45, height: 36),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInstructions() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(0, 3), // changes position of shadow
          ),
        ]
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Instructions',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xff242425),
            ),
          ),
          const SizedBox(height: 10),
          _buildInstructionStep(
            'Step 1: Capture or Upload Image',
            'Tap the button below to capture a photo of the skin lesion using your device\'s camera. Alternatively, you can upload an existing image from your device\'s gallery.',
          ),
          const SizedBox(height: 10),
          _buildInstructionStep(
            'Step 2: Analyze Image',
            'Once the image is captured or uploaded, our advanced algorithms will analyze the skin lesion to provide you with accurate insights.',
          ),
          const SizedBox(height: 10),
          _buildInstructionStep(
            'Step 3: View Results',
            'After analysis, you will receive detailed information about the skin lesion detected, including type, risk level, and recommendations for further action.',
          ),
          const SizedBox(height: 20),
          const Text(
            'Note: Analysis may take a few moments. Please ensure good lighting conditions for accurate results.',
            style: TextStyle(
              fontSize: 14,
              color: Colors.red,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInstructionStep(String title, String description) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xff434248),
          ),
        ),
        const SizedBox(height: 5),
        Text(
          description,
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xff4c535e),
          ),
        ),
      ],
    );
  }
}
