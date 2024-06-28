import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skinlesion/screens/home/analysis/analyze_now_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}
 String? _name;

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
  getUserInfo();
    // TODO: implement initState
    super.initState();
  }

    Future<void> getUserInfo() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userData = await FirebaseFirestore.instance.collection('users')
          .doc(user.uid)
          .get();
      setState(() {
        _name = userData['name'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff7f7f7),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 20.h,
            ),
            _buildHeader(),
            const SizedBox(height: 20),
            _buildAnalyzeNowCard(context),
            const SizedBox(height: 30),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Text(
                'What do you want to do today?',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
            ),
            const SizedBox(height: 20),
            _buildOptions(),
            const SizedBox(height: 30),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Text(
                'Explore Lesions',
                style: TextStyle(
                    decoration: TextDecoration.underline,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
            ),
            const SizedBox(height: 20),
            _buildExploreLesions(),
            const SizedBox(height: 20),
            _buildArticlesAboutLesions(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset('assets/Frame.png', width: 45, height: 45),
              SizedBox(
                height: 10.h,
              ),
               Text(
                'Welcome back, ${'$_name'}',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildAnalyzeNowCard(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.green,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Stack(
          children: [
            Positioned(
              right: 0,
              child: Image.asset('assets/home_analyz.png', height: 150),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Get Your Skin',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    'Analyzed Now!',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const AnalyzeNowScreen()));
                    },
                    style: ElevatedButton.styleFrom(
                      textStyle:
                          TextStyle(color: Colors.white, fontSize: 16.sp),
                      backgroundColor: Colors.orange,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'Analyze Now',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptions() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          _buildOptionCard(
              'Skin Analysis',
              'Upload a photo of your skin for a quick analysis and get insights about any detected lesions.',
              Icons.camera_alt),
          _buildOptionCard(
              'Support & Guidance',
              'Access articles and resources to learn more about skin health and lesion detection.',
              Icons.help),
          _buildOptionCard(
              'Personalized Assistance',
              'Reach out to our team for personalized support and answers to your questions.',
              Icons.person),
        ],
      ),
    );
  }

  Widget _buildOptionCard(String title, String description, IconData icon) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: ListTile(
        leading: Icon(icon, color: Colors.green, size: 40),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(description),
        trailing: Container(
            decoration: BoxDecoration(
                shape: BoxShape.circle, color: Colors.green.shade300),
            child: const Icon(color: Colors.white, Icons.arrow_forward)),
        onTap: () {},
      ),
    );
  }

  Widget _buildExploreLesions() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Wrap(
        spacing: 8,
        runSpacing: 5,
        children: [
          _buildChip('Melanoma'),
          _buildChip('Actinic keratosis'),
          _buildChip('Vascular lesion'),
          _buildChip('Basal cell carcinoma'),
          _buildChip('Melanocytic nevus'),
          _buildChip('Benign keratosis'),
          _buildChip('Squamous cell carcinoma'),
          _buildChip('Dermatofibroma'),
        ],
      ),
    );
  }

  Widget _buildChip(String label) {
    return Chip(
      label: Text(label),
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(7),
        side: const BorderSide(color: Color(0xfff5f5f5)),
      ),
    );
  }

  Widget _buildArticlesAboutLesions() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Articles about lesions',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 22,
            ),
          ),
          const SizedBox(height: 10),
          _buildArticleCard(),
          _buildArticleCard(),
          _buildArticleCard(),
          const SizedBox(height: 10),
          TextButton(
            onPressed: () {},
            child: const Center(child: Text('View All')),
          ),
        ],
      ),
    );
  }

  Widget _buildArticleCard() {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: ListTile(
        leading: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: Colors.green.withOpacity(0.1),
            shape: BoxShape.circle,
            image: const DecorationImage(
              image: AssetImage('assets/analyze.png'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        title: const Text(
            'Different causes of Actinic Keratosis and its symptoms and precautions.'),
        onTap: () {},
      ),
    );
  }
}
