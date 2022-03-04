import 'package:flutter/material.dart';
import 'package:forrent/screens/allPostScreen/all_post_screen.dart';
import 'package:forrent/screens/profileScreen/profile.dart';
import 'package:forrent/screens/userPostScreen/user_rent_posts.dart';

class NavConfigScreen extends StatefulWidget {
  const NavConfigScreen({Key? key}) : super(key: key);

  @override
  State<NavConfigScreen> createState() => _NavConfigScreenState();
}

class _NavConfigScreenState extends State<NavConfigScreen> {
  int _selectedIndex = 1;

  static final List<Widget> _widgetOptions = <Widget>[
    const UserRentPosts(),
    const AllPostScreen(),
    const UserProfile(),
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
        selectedItemColor: const Color.fromARGB(255, 62, 128, 177),
        backgroundColor: const Color.fromARGB(255, 239, 248, 248),
        elevation: 0,
        iconSize: 30,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        onTap: _onItemTapped,
      ),
    );
  }
}
