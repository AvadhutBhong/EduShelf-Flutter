import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:edu_shelf/colors.dart';
import 'package:edu_shelf/screens/chat_screen.dart';
import 'package:edu_shelf/screens/home.dart';
import 'package:edu_shelf/screens/order.dart';
import 'package:edu_shelf/screens/profile.dart';
import 'package:flutter/material.dart';
class BottomNavbar extends StatefulWidget {
  const BottomNavbar({super.key});

  @override
  State<BottomNavbar> createState() => _BottomNavbarState();
}

class _BottomNavbarState extends State<BottomNavbar> {
  late List<Widget> pages;
  late HomePage homepage;
  late Order order;
  late Profile profile;
  late ChatScreen chatScreen;
  int currentTabIndex=0;
  @override
  void initState()  {
    // TODO: implement initState
    homepage = HomePage();
    order = Order();
    profile = Profile();
    chatScreen = ChatScreen();
    pages = [homepage, order, chatScreen, profile];
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        height: 65,
          backgroundColor: AppColors.white,
          color: AppColors.darkGray,
          animationDuration: Duration(milliseconds: 300),
          onTap: (int index){
          setState(() {
            currentTabIndex=index;
          });
          },
          items:const [
            Icon(Icons.home_outlined ,color: Colors.white,),
            Icon(Icons.shopping_bag_outlined ,color: Colors.white,),
            Icon(Icons.chat_outlined ,color: Colors.white,),
            Icon(Icons.person_2_outlined ,color: Colors.white,),
          ],

      ),
      body: pages[currentTabIndex],
    );
  }
}
