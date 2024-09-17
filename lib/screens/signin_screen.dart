import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edu_shelf/colors.dart';
import 'package:edu_shelf/services/database.dart';
import 'package:edu_shelf/services/shared_pref.dart';
import 'package:edu_shelf/widgets/support_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:random_string/random_string.dart';


class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<SignUpScreen> {
  String ? name, email, password;
  bool isPasswordVisible=true;
  TextEditingController namecontroller = new TextEditingController();
  TextEditingController emailcontroller = new TextEditingController();
  TextEditingController passwordcontroller = new TextEditingController();

  final _formkey = GlobalKey<FormState>();

  registration () async {
    if(name != null && password != null && email != null){
      try{
        UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email! ,password: password!);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              backgroundColor: Colors.green,
              content: Text('Registered Successfully',style: AppWidget.semiboldTextFieldStyle(), ))
        );
        String Id = randomAlphaNumeric(10);
        await SharedPreferenceHelper().saveUserId(Id);
        await SharedPreferenceHelper().saveUserName(namecontroller.text);
        await SharedPreferenceHelper().saveUserEmail(emailcontroller.text);
        await SharedPreferenceHelper().saveUserImage("https://w7.pngwing.com/pngs/340/946/png-transparent-avatar-user-computer-icons-software-developer-avatar-child-face-heroes.png");
        Map<String , dynamic> userInfoMap= {
          "Name": namecontroller.text,
          "Email":emailcontroller.text,
          "id":Id,
          "Image": "https://w7.pngwing.com/pngs/340/946/png-transparent-avatar-user-computer-icons-software-developer-avatar-child-face-heroes.png"
        };
        await DatabaseMethods().addUserDetails(userInfoMap, Id);
        Navigator.pushNamed(context, '/bottomnav');

      }on FirebaseException catch(e){
          if(e.code =="weak-password"){
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    backgroundColor: Colors.redAccent,
                    content: Text('Password provided is too weak',style: AppWidget.semiboldTextFieldStyle(), ))
            );
          }else if(e.code == "email-already-in-use"){
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    backgroundColor: Colors.redAccent,
                    content: Text('Email already in use',style: AppWidget.semiboldTextFieldStyle(), ))
            );
          }
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        margin: EdgeInsets.only(top: 20),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Form(
            key: _formkey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(
                  "images/login_img.jpg",
                  fit: BoxFit.cover,
                ),
                Center(
                    child: Text(
                      'Create Account',
                      style:
                      AppWidget.semiboldTextFieldStyle().copyWith(fontSize: 22),
                    )),
                SizedBox(
                  height: 5,
                ),
            
                Center(
                    child: Text(
                      'Please enter the details below to\n                    continue. ',
                      style: AppWidget.lightTextFieldStyle(),
                    )),
                SizedBox(
                  height: 30,
                ),
            
                Text(
                  'Name',
                  style: AppWidget.semiboldTextFieldStyle().copyWith(
                    fontSize: 20,
                  ),
                ),
                SizedBox(height: 10),
            
                Container(
                    padding: EdgeInsets.only(left: 20),
                    decoration: BoxDecoration(
                      color: Color(0xfff4f5f9),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextFormField(
                      controller: namecontroller,
                      validator: (value){
                        if(value==null || value.isEmpty){
                          return "Please enter your name";
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Name",
                        hintStyle: AppWidget.lightTextFieldStyle()
                            .copyWith(fontSize: 17),
                      ),
                    )),
                SizedBox(
                  height: 10,
                ),
            
                Text(
                  'Email',
                  style: AppWidget.semiboldTextFieldStyle().copyWith(
                    fontSize: 20,
                  ),
                ),
                SizedBox(height: 10),
            
                Container(
                    padding: EdgeInsets.only(left: 20),
                    decoration: BoxDecoration(
                      color: Color(0xfff4f5f9),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextFormField(
                      controller: emailcontroller,
                      validator: (value){
                        if(value==null || value.isEmpty){
                          return "Please enter your email";
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Email",
                        hintStyle: AppWidget.lightTextFieldStyle()
                            .copyWith(fontSize: 17),
                      ),
                    )),
                SizedBox(
                  height: 10,
                ),
            
                Text(
                  'Password',
                  style: AppWidget.semiboldTextFieldStyle().copyWith(
                    fontSize: 20,
                  ),
                ),
                SizedBox(height: 10),

                Container(
                  padding: EdgeInsets.only(left: 20),
                  decoration: BoxDecoration(
                    color: Color(0xfff4f5f9),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextFormField(
                    obscureText: !isPasswordVisible,
                    controller: passwordcontroller,
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            isPasswordVisible = !isPasswordVisible;

                          });
                        },
                        icon: Icon(isPasswordVisible ? Icons.visibility : Icons.visibility_off),

                      ),
                      border: InputBorder.none,
                      hintText: "Password",
                      hintStyle: AppWidget.lightTextFieldStyle()
                          .copyWith(fontSize: 17),
                    ),
                  ),
                ),
                SizedBox(
                  height: 25,
                ),
            
                GestureDetector(
                  onTap: (){
                    if(_formkey.currentState!.validate()){
                      name = namecontroller.text;
                      email= emailcontroller.text;
                      password=passwordcontroller.text;
                    }
                    registration();
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 10.0),
                    decoration: BoxDecoration(
                      color: Colors.blueAccent,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    width: MediaQuery.of(context).size.width,
                    child: Center(
                      child: Text(
                        'Sign Up',
                        style: TextStyle(
                            color: AppColors.offWhite,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
            
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Expanded(
                      child: Divider(
                        indent: 20.0,
                        endIndent: 10.0,
                        thickness: 1,
                      ),
                    ),
                    Text(
                      "OR",
                      style: TextStyle(color: Colors.blueGrey),
                    ),
                    Expanded(
                      child: Divider(
                        indent: 10.0,
                        endIndent: 20.0,
                        thickness: 1,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
            
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
            
                        style: ElevatedButton.styleFrom(
            
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: BorderSide(color: Colors.grey.shade200, width: 1.0),
                          ),
                          minimumSize: const Size(48, 48),
                        ),
                        onPressed: () {
                          // Implement Google sign-in logic here
                        },
                        child: Image.asset("images/google.png", height: 25,width: 25,),
                      ),
                      SizedBox(width: 30,),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: BorderSide(color: Colors.grey.shade200, width: 1.0),
                          ),
                          minimumSize: const Size(30, 30),
            
                        ),
                        onPressed: () {
                          // Implement Google sign-in logic here
                        },
                        child: Icon(Icons.phone),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 25,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already have an account? ',
                      style:
                      AppWidget.lightTextFieldStyle().copyWith(fontSize: 15),
                    ),
                    GestureDetector(
                      onTap: (){
                        Navigator.pushNamed(context, '/login');
                      },
                      child: Text(
                        'Sign In',
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: Colors.blueAccent),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
