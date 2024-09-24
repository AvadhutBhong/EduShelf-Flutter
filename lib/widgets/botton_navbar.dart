import 'package:edu_shelf/admin/admin_home.dart';
import 'package:edu_shelf/admin/admin_login.dart';
import 'package:edu_shelf/screens/pre_sell_screen.dart';
import 'package:flutter/material.dart';
import 'package:edu_shelf/colors.dart';
import 'package:edu_shelf/screens/Chat_Files/chat_screen.dart';
import 'package:edu_shelf/screens/Homepage_files/home.dart';
import 'package:edu_shelf/screens/Profile/profile.dart';

class BottomNavbar extends StatefulWidget {
  const BottomNavbar({super.key});

  @override
  State<BottomNavbar> createState() => _BottomNavbarState();
}

class _BottomNavbarState extends State<BottomNavbar> {
  late List<Widget> pages;
  late HomePage homepage;
  late PreSellPage sellproduct;
  late Profile profile;
  late ChatScreen chatScreen;
  int currentTabIndex = 0;

  @override
  void initState() {
    homepage = HomePage();
    sellproduct = PreSellPage(); // This represents the "Sell Product" section
    profile = Profile();
    chatScreen = ChatScreen();
    pages = [homepage, sellproduct, chatScreen, profile];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        margin: EdgeInsets.only(bottom: 10.0), // Margin to create floating effect
        padding: EdgeInsets.symmetric(vertical: 2.0), // Added padding for floating look
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 5,
              blurRadius: 10,
              offset: Offset(0, -1), // Shadow position
            ),
          ],
          borderRadius: BorderRadius.circular(20.0), // Rounded corners
        ),
        child: BottomNavigationBar(
          currentIndex: currentTabIndex,
          onTap: (int index) {
            setState(() {
              currentTabIndex = index;
            });
          },
          selectedItemColor: AppColors.darkNavy, // Active color
          unselectedItemColor: AppColors.darkGray.withOpacity(0.7), // Darker inactive color
          showSelectedLabels: true,
          showUnselectedLabels: true,
          type: BottomNavigationBarType.shifting,
          backgroundColor: Colors.transparent, // Make background transparent for custom container
          elevation: 0, // Remove default elevation
          items: [
            _buildNavItem(
              index: 0,
              icon: Icons.home_outlined,
              activeIcon: Icons.home_rounded,
              label: 'Home',
            ),
            _buildNavItem(
              index: 1, // Change to 1
              icon: Icons.storefront_outlined,
              activeIcon: Icons.storefront_rounded,
              label: 'Sell',
            ),
            _buildNavItem(
              index: 2, // Change to 2
              icon: Icons.chat_bubble_outline,
              activeIcon: Icons.chat_bubble_rounded,
              label: 'Chat',
            ),
            _buildNavItem(
              index: 3, // Change to 3
              icon: Icons.person_outline,
              activeIcon: Icons.person_rounded,
              label: 'Profile',
            ),
          ],

        ),
      ),
      body: pages[currentTabIndex],
    );
  }

  BottomNavigationBarItem _buildNavItem({
    required int index,
    required IconData icon,
    required IconData activeIcon,
    required String label,
  }) {
    bool isActive = currentTabIndex == index;
    return BottomNavigationBarItem(
      icon: Container(
        padding: EdgeInsets.all(6.0),
        decoration: isActive
            ? BoxDecoration(
          color: AppColors.lightBlue.withOpacity(0.4), // Active state background
          shape: BoxShape.circle,
        )
            : null,
        child: Icon(
          isActive ? activeIcon : icon,
          size: 28.0,
        ),
      ),
      label: label,
    );
  }
}
