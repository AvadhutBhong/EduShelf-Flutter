import 'package:edu_shelf/admin/add_product.dart';
import 'package:edu_shelf/admin/admin_home.dart';
import 'package:edu_shelf/admin/admin_login.dart';
import 'package:edu_shelf/app_routes.dart';
import 'package:edu_shelf/screens/chat_screen.dart';
import 'package:edu_shelf/screens/home.dart';
import 'package:edu_shelf/screens/login_screen.dart';
import 'package:edu_shelf/screens/phone_login_screen.dart';
import 'package:edu_shelf/screens/pre_sell_screen.dart';
import 'package:edu_shelf/screens/product_details.dart';
import 'package:edu_shelf/screens/signin_screen.dart';
import 'package:edu_shelf/widgets/botton_navbar.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'edu_shelf',
      theme: ThemeData(
        fontFamily: 'Quicksand',
        primaryColor: AppColors.darkGray,
        scaffoldBackgroundColor: AppColors.white,
        colorScheme: ColorScheme(
          primary: AppColors.darkGray,
          secondary: AppColors.lightGray,
          surface: AppColors.white,
          background: AppColors.white,
          error: Colors.red,
          onPrimary: AppColors.white,
          onSecondary: AppColors.darkGray,
          onSurface: AppColors.darkGray,
          onBackground: AppColors.darkGray,
          onError: AppColors.white,
          brightness: Brightness.light,
        ),
        textTheme: const TextTheme(
          headlineLarge: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.darkGray,
          ),
          bodyLarge: TextStyle(
            fontSize: 16,
            color: AppColors.darkGray,
          ),
          labelLarge: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: AppColors.white,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.lightGray,
            foregroundColor: AppColors.darkGray,
            padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: AppColors.darkGray,
          ),
        ),
      ),
      onGenerateRoute: AppRoutes.generateRoute,
      home: BottomNavbar(),
    );
  }
}
