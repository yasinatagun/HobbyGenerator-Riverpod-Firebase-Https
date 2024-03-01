import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hobby_generator/screens/bookmark_screen.dart';
import 'package:hobby_generator/screens/generator_screen.dart';
import 'package:hobby_generator/services/locator.dart';
import 'package:hobby_generator/services/sp_service.dart';
import 'package:hobby_generator/services/user_service.dart';

class TabScreen extends StatefulWidget {
  const TabScreen({super.key});

  @override
  State<TabScreen> createState() => _TabScreenState();
}

class _TabScreenState extends State<TabScreen> {
  int selectedTab = 0;
  
  void saveUserEmail() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null && user.email != null) {
      await locator<SharedPreferencesService>()
          .setString('userEmail', user.email!);
      locator<UserManager>().setUserEmail(user.email!);
    }
  }

  void changeTab(int index) {
    setState(() {
      selectedTab = index;
    });
  }

  final List tabPages = [
    const GeneratorScreen(),
    const BookmarkScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        showUnselectedLabels: true,
        showSelectedLabels: true,
        type: BottomNavigationBarType.fixed,
        currentIndex: selectedTab,
        onTap: (index) => changeTab(index),
        selectedItemColor: Colors.deepPurple,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
              icon: Icon(Icons.bookmark), label: "Bookmarks"),
        ],
      ),
      body: tabPages[selectedTab],
    );
  }
}
