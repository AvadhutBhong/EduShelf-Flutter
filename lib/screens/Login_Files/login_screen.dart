import 'package:edu_shelf/colors.dart';
import 'package:edu_shelf/widgets/support_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sign_in_button/sign_in_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String  email="", password="";
  bool isPasswordVisible = false;
  TextEditingController emailcontroller = new TextEditingController();
  TextEditingController passwordcontroller = new TextEditingController();

  final _formkey = GlobalKey<FormState>();

  userLogin() async {
    try{
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
      Navigator.pushNamed(context, '/bottomnav');
    }on FirebaseAuthException catch (e){
      if(e.code == "wrong-password"){
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                backgroundColor: Colors.redAccent,
                content: Text('Wrong password buddy !!',style: AppWidget.semiboldTextFieldStyle(), ))
        );
      }else if(e.code =='user-not-found'){
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),

                backgroundColor: Colors.redAccent,
                content: Text('No user found for provided email !!',style: AppWidget.semiboldTextFieldStyle(), ))
        );
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
                  'Sign In',
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
                        hintText: "Enter your Email ",
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
                  height: 15,
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      "Forgot Password",
                      style: TextStyle(
                          color: Colors.blue,
                          fontSize: 14,
                          fontWeight: FontWeight.w700),
                    )
                  ],
                ),
                SizedBox(
                  height: 15,
                ),

                GestureDetector(
                  onTap: (){
                    if(_formkey.currentState!.validate()){
                      email=emailcontroller.text;
                      password=passwordcontroller.text;
                    }
                    userLogin();
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
                        'Login',
                        style: TextStyle(
                            color: AppColors.offWhite,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 7,
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
                      'Don\'t have an account? ',
                      style:
                          AppWidget.lightTextFieldStyle().copyWith(fontSize: 15),
                    ),
                    GestureDetector(
                      onTap: (){
                        Navigator.pushNamed(context,'/signin');
                      },
                      child: Text(
                        'Sign Up',
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
