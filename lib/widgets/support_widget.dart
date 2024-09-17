import 'package:flutter/material.dart';
import 'package:edu_shelf/colors.dart';
class AppWidget{
    static TextStyle boldTextFieldStyle(){
      return TextStyle(
        color: AppColors.darkGray,
        fontWeight: FontWeight.bold,
        fontSize: 24,
      );
    }

    static TextStyle lightTextFieldStyle(){
      return TextStyle(
        color: Colors.black45,
        fontWeight: FontWeight.w600,
        fontSize: 18,
      );
    }
    static TextStyle semiboldTextFieldStyle(){
      return TextStyle(color: AppColors.darkGray, fontSize: 18, fontWeight: FontWeight.bold);
    }
}