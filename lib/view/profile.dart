import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  final String username;

  ProfileScreen({super.key, required this.username});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? _loggedInUserName;

  // Asynchronous function to fetch the username
  Future<void> _getLoggedInUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? username = prefs.getString('loggedInUserName');
    setState(() {
      _loggedInUserName = username ??widget.username; // Default to "Guest" if null
    });
  }

  @override
  void initState() {
    super.initState();
    _getLoggedInUserName(); // Fetch username on initialization
  }

  @override
  Widget build(BuildContext context) {
     return Scaffold(
        body: Stack(children: [
      // Background Image
      Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
                'assets/images/image 1 (1).png'), // Your background image path
            fit: BoxFit.cover,
          ),
        ),
      ),
      // Gradient Overlay
      Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0x99000000), // Transparent Black
              Color(0x66000000), // More Transparent Black
            ],
          ),
        ),
      ),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  const SizedBox(height: 80),
                  Center(
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.grey[300],
                      child: Icon(
                        Icons.person,
                        size: 60,
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: Text(
                      _loggedInUserName ?? 'Loading...', // Display username or loading state
                      style: const TextStyle(
                        fontStyle: FontStyle.italic,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 50),
                  ProfileItem(
                    icon: Icons.info,
                    text: 'About Us',
                    onPressed: () {
                      // Handle About Us action
                    },
                  ),
                  ProfileItem(
                    icon: Icons.privacy_tip,
                    text: 'Privacy Policy',
                    onPressed: () {
                      // Handle Privacy Policy action
                    },
                  ),
                  ProfileItem(
                    icon: Icons.contact_mail,
                    text: 'Contact Us',
                    onPressed: () {
                      // Handle Contact Us action
                    },
                  ),
                  ProfileItem(
                    icon: Icons.share,
                    text: 'Share with a Friend',
                    onPressed: () {
                      // Handle Share action
                    },
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ProfileItem extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onPressed;

  const ProfileItem({
    super.key,
    required this.icon,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1), // Subtle background highlight
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                color: Colors.white,
                size: 24,
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Text(
                  text,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios,
                color: Colors.white,
                size: 16,
              ), // Optional arrow icon for better UX
            ],
          ),
        ),
      ),
    );
  }
}