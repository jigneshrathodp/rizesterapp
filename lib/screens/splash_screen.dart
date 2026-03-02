import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/auth_service.dart';
import '../utils/responsive_config.dart';
import '../widgets/widgets.dart';
import 'Profile/login_screen.dart';
import 'main_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    // Wait for splash screen animation
    await Future.delayed(const Duration(seconds: 2));
    
    try {
      bool isLoggedIn = await AuthService.isLoggedIn();
      
      if (isLoggedIn) {
        // User is logged in, navigate to main screen
        Get.offAll(() => const MainScreen());
      } else {
        // User is not logged in, navigate to login screen
        Get.offAll(() => const LoginScreen());
      }
    } catch (e) {
      // If there's any error, navigate to login screen
      Get.offAll(() => const LoginScreen());
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    
    return Scaffold(
      body: CustomStack(
        children: [
          // Background image
          Positioned.fill(
            child: Image.asset(
              "assets/download.jpg",
              fit: BoxFit.cover,
            ),
          ),

          // Dark gradient overlay
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black54,
                    Colors.black87,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),

          // Main content
          CustomSafeArea(
            child: Center(
              child: CustomColumn(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo
                  Image.asset(
                    "assets/logo2.png",
                    height: ResponsiveConfig.responsiveHeight(context, size.height * 0.15),
                  ),
                  
                  CustomSpacer(height: size.height * 0.03),
                  
                  // App name or welcome text
                  Text(
                    "Welcome to Rizester",
                    style: AppTextStyles.getSubheading(context).copyWith(
                      fontSize: ResponsiveConfig.responsiveFont(context, 24),
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  
                  CustomSpacer(height: size.height * 0.02),
                  
                  // Loading indicator
                  const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    strokeWidth: 3,
                  ),
                  
                  CustomSpacer(height: size.height * 0.02),
                  
                  Text(
                    "Checking authentication...",
                    style: AppTextStyles.getBody(context).copyWith(
                      fontSize: ResponsiveConfig.responsiveFont(context, 14),
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
