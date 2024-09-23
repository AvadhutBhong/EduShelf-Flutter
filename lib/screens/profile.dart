import 'package:edu_shelf/services/shared_pref.dart';
import 'package:flutter/material.dart';
import 'Profile/edit_profile_screen.dart';
import 'Profile/my_products_page.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  bool isDarkMode = false;
  String? username;
  String? useremail;
  String? userImage;
  String? userphone;
  String? userid;

  getSharedPref() async {
    username = await SharedPreferenceHelper().getUserName();
    useremail = await SharedPreferenceHelper().getUserEmail();
    userImage = await SharedPreferenceHelper().getUserImage();
    userid = await SharedPreferenceHelper().getUserId();
    userphone = await SharedPreferenceHelper().getUserPhone(userid!);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getSharedPref();
  }

  void toggleTheme(bool value) {
    setState(() {
      isDarkMode = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return username == null
        ? const Center(child: CircularProgressIndicator())
        : Scaffold(
      backgroundColor: isDarkMode ? Colors.black : Colors.white,
      appBar: AppBar(
        backgroundColor: isDarkMode ? Colors.black : Colors.white,
        title: Text(
          'Profile',
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: isDarkMode ? Colors.white : Colors.black,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              isDarkMode ? Icons.light_mode : Icons.dark_mode,
              color: isDarkMode ? Colors.white : Colors.black,
            ),
            onPressed: () => toggleTheme(!isDarkMode),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(userImage!),
            ),
            const SizedBox(height: 20),
            Text(
              username!,
              style: TextStyle(
                color: isDarkMode ? Colors.white : Colors.black,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              userphone ?? 'Add phone number',
              style: TextStyle(
                color: isDarkMode ? Colors.grey : Colors.black54,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              useremail!,
              style: TextStyle(
                color: isDarkMode ? Colors.grey : Colors.black54,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: isDarkMode ? Colors.white54 : Colors.black87,
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              icon: Icon(Icons.edit, color: isDarkMode ? Colors.black : Colors.white),
              label: Text(
                'Edit Profile',
                style: TextStyle(color: isDarkMode ? Colors.black : Colors.white),
              ),
              onPressed: () async {
                final updatedData = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditProfilePage(
                      username: username,
                      useremail: useremail,
                      userImage: userImage,
                      userphone: userphone,
                      userid: userid,
                    ),
                  ),
                );
                if (updatedData != null) {
                  setState(() {
                    username = updatedData['name'];
                    useremail = updatedData['email'];
                    userphone = updatedData['phone'];
                    userImage = updatedData['image'];
                  });
                  // Refresh shared preferences to get the updated image URL
                  await getSharedPref();
                }
              },
            ),
            const SizedBox(height: 40),
            const Divider(height: 1, color: Colors.grey),
            // My Products Section
            ListTile(
              leading: Icon(Icons.list_alt, color: isDarkMode ? Colors.white : Colors.black),
              title: Text(
                'My Products',
                style: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.black,
                  fontSize: 18,
                ),
              ),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_)=> MyProductsPage()));
              },
            ),
            // Help & Support Section
            ListTile(
              leading: Icon(Icons.help, color: isDarkMode ? Colors.white : Colors.black),
              title: Text(
                'Help & Support',
                style: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.black,
                  fontSize: 18,
                ),
              ),
              onTap: () {
                // Navigate to Help & Support screen
              },
            ),
            // Log Out Section
            ListTile(
              leading: Icon(Icons.logout, color: isDarkMode ? Colors.white : Colors.black),
              title: Text(
                'Log Out',
                style: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.black,
                  fontSize: 18,
                ),
              ),
              onTap: () {
                // Log out functionality
              },
            ),
          ],
        ),
      ),
    );
  }
}
