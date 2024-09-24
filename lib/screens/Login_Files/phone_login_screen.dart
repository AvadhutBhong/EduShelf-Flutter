import 'package:edu_shelf/widgets/support_widget.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PhoneLoginScreen extends StatefulWidget {
  @override
  _PhoneLoginScreenState createState() => _PhoneLoginScreenState();
}

class _PhoneLoginScreenState extends State<PhoneLoginScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  TextEditingController phoneController = TextEditingController();
  TextEditingController otpController = TextEditingController();
  String? verificationId;
  bool showOtpField = false; // State to track if OTP field should be displayed

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        margin: EdgeInsets.symmetric(vertical: 60, horizontal: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Avatar image
            Image.asset(
              "images/phone_login_image.jpg",
              fit: BoxFit.cover,
              height: MediaQuery.of(context).size.width / 1.7,
              width: MediaQuery.of(context).size.width / 1.7,
            ),
            SizedBox(height: 40),
            Column(
              children: [
                SizedBox(height: 20),
                // Phone number input field with +91 prefix
                Row(
                  children: [
                    Container(
                      height: 55,
                      width: 55,
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Center(child: Text('+91')),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: phoneController,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          hintText: 'Enter phone number',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                // Generate OTP button
                ElevatedButton(
                  onPressed: () => generateOtp(),
                  child: Text(
                    showOtpField ? 'Verify OTP' : 'Generate OTP',
                    style: AppWidget.semiboldTextFieldStyle().copyWith(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black87, // Button color
                  ),
                ),
                if (showOtpField) ...[
                  SizedBox(height: 20),
                  // OTP input field
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(6, (index) {
                      return SizedBox(
                        width: 40,
                        child: TextField(
                          controller: otpController,
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          maxLength: 1,
                          decoration: InputDecoration(
                            counterText: "",
                            border: OutlineInputBorder(),
                          ),
                        ),
                      );
                    }),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Generate OTP method
  void generateOtp() async {
    if (showOtpField) {
      // If OTP field is already visible, verify OTP
      verifyOtp();
    } else {
      // Generate OTP
      String phoneNumber = '+91' + phoneController.text; // Ensure correct format
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await _auth.signInWithCredential(credential);
          // Handle successful verification
        },
        verificationFailed: (FirebaseAuthException e) {
          // Handle error
        },
        codeSent: (String verificationId, int? resendToken) {
          setState(() {
            this.verificationId = verificationId;
            showOtpField = true; // Show OTP field after code is sent
          });
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    }
  }

  // Verify OTP method
  void verifyOtp() async {
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId!, smsCode: otpController.text);
    await _auth.signInWithCredential(credential);
    // Handle successful login
  }
}
