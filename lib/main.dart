import 'package:edu_shelf/admin/add_product.dart';
import 'package:edu_shelf/admin/admin_login.dart';
import 'package:edu_shelf/app_routes.dart';
import 'package:edu_shelf/screens/home.dart';
import 'package:edu_shelf/screens/login_screen.dart';
import 'package:edu_shelf/screens/product_details.dart';
import 'package:edu_shelf/screens/signin_screen.dart';
import 'package:edu_shelf/widgets/botton_navbar.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
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
        primaryColor: AppColors.darkGray, // Updated color to darkGray
        scaffoldBackgroundColor: AppColors.white, // Updated scaffold background color to white
        colorScheme:const ColorScheme(
          primary: AppColors.darkGray, // Dark Gray as primary
          secondary: AppColors.lightGray, // Light Gray as secondary
          surface: AppColors.offWhite, // Off White as surface color
          background: AppColors.white, // Background color
          error: Colors.red,
          onPrimary: AppColors.white, // Text color on dark surfaces
          onSecondary: AppColors.darkGray, // Text color on light surfaces
          onSurface: AppColors.darkGray, // Text on surface
          onBackground: AppColors.darkGray, // Text on background
          onError: AppColors.white, // Text on error surfaces
          brightness: Brightness.light,
        ),
        textTheme: const TextTheme(
          headlineLarge: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.darkGray, // Dark Gray text
          ),
          bodyLarge: TextStyle(
            fontSize: 16,
            color: AppColors.darkGray, // Dark Gray text
          ),
          labelLarge: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: AppColors.white, // White text
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.lightGray, // Button color as Light Gray
            foregroundColor: AppColors.darkGray, // Text color as Dark Gray
            padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: AppColors.darkGray, // Text button color
          ),
        ),

      ),
      onGenerateRoute: AppRoutes.generateRoute,
      // initialRoute: AppRoutes.splash,
      home:AddProduct(),
    );
  }
}
