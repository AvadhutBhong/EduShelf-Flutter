import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../colors.dart';
import '../widgets/support_widget.dart';

class AdminLogin extends StatefulWidget {
  const AdminLogin({super.key});

  @override
  State<AdminLogin> createState() => _AdminLoginState();
}

class _AdminLoginState extends State<AdminLogin> {
  TextEditingController usernameController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  bool isPasswordVisible=false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        margin: EdgeInsets.only(top: 20),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  color: Colors.white, // Or any desired background color
                  child: Image.asset('images/admin_panel.png'),
                ),
                Center(
                    child: Text(
                      'Admin Panel',
                      style:
                      AppWidget.semiboldTextFieldStyle().copyWith(fontSize: 25),
                    )),
                SizedBox(
                  height: 15,
                ),

                // Center(
                //     child: Text(
                //       'Please enter the details below to\n                    continue. ',
                //       style: AppWidget.lightTextFieldStyle(),
                //     )),
                // SizedBox(
                //   height: 30,
                // ),

                Text(
                  'Username',
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
                      controller: usernameController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Username",
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
              controller: passwordController,
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
                      loginAdmin();
                  },
                  child: Center(
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 10.0),
                      decoration: BoxDecoration(
                        color: Colors.blueAccent,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      width: MediaQuery.of(context).size.width/1.65,
                      child: Center(
                        child: Text(
                          'LOGIN',
                          style: TextStyle(
                              color: AppColors.offWhite,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),


              ],
            ),
          ),
        ),
    );

  }
  loginAdmin(){
    FirebaseFirestore.instance.collection("Admin").get().then((snapshot){
      snapshot.docs.forEach((result){
        if(result.data()['username']!= usernameController.text.trim()){
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  backgroundColor: Colors.redAccent,
                  content: Text('Your id is not correct !!',style: AppWidget.semiboldTextFieldStyle(), ))
          );
        }else if(result.data()['password']!=passwordController.text.trim()){
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  backgroundColor: Colors.redAccent,
                  content: Text('Incorrect Password',style: AppWidget.semiboldTextFieldStyle(), ))
          );
        }else{
          Navigator.pushNamed(context, '/adminhome');
        }
      });
    });
  }


}
