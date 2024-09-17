import 'package:edu_shelf/admin/admin_home.dart';
import 'package:edu_shelf/screens/home.dart';
import 'package:edu_shelf/screens/login_screen.dart';
import 'package:edu_shelf/screens/signin_screen.dart';
import 'package:edu_shelf/screens/splash_screen.dart';
import 'package:edu_shelf/widgets/botton_navbar.dart';
import 'package:flutter/material.dart';

class AppRoutes {
  // Define the route names as static constants
  static const String login = '/login';
  static const String signin = '/signin';
  static const String splash = '/splash';
  static const String home = '/home';
  static const String bottomnav = '/bottomnav';
  static const String adminhome = '/adminhome';

  // Generate the route based on the name
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return MaterialPageRoute(builder: (_) => LoginScreen());
      case splash:
        return MaterialPageRoute(builder: (_)=> SplashScreen());
        case signin:
        return MaterialPageRoute(builder: (_)=> SignUpScreen());
      case home:
        return MaterialPageRoute(builder: (_)=> HomePage());
      case bottomnav:
        return MaterialPageRoute(builder: (_)=> BottomNavbar());
        case adminhome:
        return MaterialPageRoute(builder: (_)=> AdminHome());
      default:
      // Return a default route or error page
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            appBar: AppBar(title: Text('Error')),
            body: Center(child: Text('Page not found')),
          ),
        );
    }
  }
}
