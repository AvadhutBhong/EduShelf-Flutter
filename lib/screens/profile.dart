import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  bool isDarkMode = false;

  void toggleTheme(bool value) {
    setState(() {
      isDarkMode = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isDarkMode ? Colors.black : Colors.white,
      appBar: AppBar(
        backgroundColor: isDarkMode ? Colors.black : Colors.white,
        title: Text(
          'Profile',
          style: TextStyle(
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(
                "https://w7.pngwing.com/pngs/340/946/png-transparent-avatar-user-computer-icons-software-developer-avatar-child-face-heroes.png",
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'User Name',
              style: TextStyle(
                color: isDarkMode ? Colors.white : Colors.black,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              'user@example.com',
              style: TextStyle(
                color: isDarkMode ? Colors.grey : Colors.black54,
                fontSize: 16,
              ),
            ),
            const Divider(height: 40, color: Colors.grey),
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
                // Navigate to My Products screen
              },
            ),
            ListTile(
              leading: Icon(Icons.settings, color: isDarkMode ? Colors.white : Colors.black),
              title: Text(
                'Settings',
                style: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.black,
                  fontSize: 18,
                ),
              ),
              onTap: () {
                // Navigate to Settings screen
              },
            ),
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
