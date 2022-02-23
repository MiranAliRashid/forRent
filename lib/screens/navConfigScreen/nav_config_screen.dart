import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:forrent/providers/auth_service.dart';
import 'package:forrent/screens/allPostScreen/all_post_screen.dart';
import 'package:forrent/screens/userPostScreen/user_rent_posts.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';

class NavConfigScreen extends StatefulWidget {
  NavConfigScreen({Key? key}) : super(key: key);

  @override
  State<NavConfigScreen> createState() => _NavConfigScreenState();
}

class _NavConfigScreenState extends State<NavConfigScreen> {
  @override
  int _selectedIndex = 1;

  static List<Widget> _widgetOptions = <Widget>[
    UserRentPosts(),
    AllPostScreen(),
    Text(
      'Index 2: School',
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.holiday_village_outlined),
            label: 'Business',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.room_preferences_outlined),
            label: 'School',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Color.fromARGB(255, 62, 128, 177),
        backgroundColor: Color.fromARGB(255, 239, 248, 248),
        elevation: 0,
        iconSize: 30,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        onTap: _onItemTapped,
      ),
    );
  }
}
