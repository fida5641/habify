
import 'package:flutter/material.dart';
import 'package:habit_tracker/view/login.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();

}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToLogin();
  }

  _navigateToLogin() async {
    await Future.delayed(const Duration(seconds: 3));
    Navigator.pushReplacement(  
     context,
      MaterialPageRoute(builder: (context) => const LogScreen()), 
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  Padding(padding: const EdgeInsets.all(20.0),
      child: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(image: AssetImage("assets/images/image 1 (1).png"),
              fit: BoxFit.cover,

           )
            ),
          ),
           Center(
              child: Container(
                width: 350,
                height: 350,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/splash.png'),
                  ),
                ),
              
              ),
              
            ),
            const Center(child: CircularProgressIndicator(color: Colors.white,))

        ],
      ),),
    );
  }
}
