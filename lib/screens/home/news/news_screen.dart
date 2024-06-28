import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skinlesion/constants/colors.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({super.key});

  @override
  NewsScreenState createState() => NewsScreenState();
}

class NewsScreenState extends State<NewsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: 30.h,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset('assets/Frame.png', width: 45, height: 45),
                IconButton(
                  icon: const Icon(Icons.notifications),
                  onPressed: () {},
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                Container(
                  height: 60,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset:
                              const Offset(0, 3), // changes position of shadow
                        ),
                      ]),
                  child: Center(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Find things to do',
                        hintStyle: TextStyle(color: Colors.grey),
                        border: InputBorder.none,
                        prefixIcon: Icon(Icons.search,
                            size: 35, color: Colors.grey.shade400),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 30.h),
                Row(
                  textDirection: TextDirection.ltr,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildFilterButton('All', true),
                    SizedBox(width: 5.w),
                    _buildFilterButton('Melanoma', false),
                    SizedBox(width: 5.w),
                    _buildFilterButton('Actinic keratosis', false),
                    SizedBox(width: 5.w),
                    _buildFilterButton('Vascular lesions', false),
                    SizedBox(width: 5.w),
                  ],
                ),
                const SizedBox(height: 20),
                const Text(
                  'Articles about lesions',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: 3,
              itemBuilder: (context, index) {
                return _buildArticleCard();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterButton(String text, bool isSelected) {
    return Expanded(
      child: ChoiceChip(
        color: WidgetStateProperty.all(isSelected ? primaryColor.withOpacity(0.7) : Colors.white),
        label: Text(text),
        selected: isSelected,
        onSelected: (selected) {
          // Handle filter button selection
        },
      ),
    );
  }

  Widget _buildArticleCard() {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      child: Container(
        width: 200,
        child: ListTile(
          leading: Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              image: const DecorationImage(
                image: NetworkImage(
                    'https://cdn-icons-png.flaticon.com/512/5556/5556468.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          title: const Text(
            'Different causes of Actinic Keratosis and its symptoms and precautions.',
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }
}
