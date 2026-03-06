import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:rizesterapp/screens/dashboard_screen.dart';
import 'package:rizesterapp/screens/Profile/login_screen.dart';
import 'package:rizesterapp/screens/main_screen.dart';
import 'package:rizesterapp/screens/splash_screen.dart';
import 'package:rizesterapp/utils/auth_helper.dart';
import 'package:rizesterapp/controllers/global_profile_controller.dart';
import 'package:rizesterapp/services/api_cache_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Set preferred orientations for better performance
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  
  // Initialize AuthHelper
  Get.put(AuthHelper());
  
  // Initialize GlobalProfileController
  Get.put(GlobalProfileController());
  
  // Initialize MainScreenController for dashboard access
  Get.put(MainScreenController());
  
  // Clear old cache on app start
  await ApiCacheService.clearCache();
  
  runApp(
    const MyApp(),
  );
}

class NoTransitionsBuilder extends PageTransitionsBuilder {
  @override
  Widget buildTransitions<T>(
      PageRoute<T> route,
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child,
      ) {
    return child;
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'RizesterApp',
      useInheritedMediaQuery: true,
      debugShowCheckedModeBanner: false,
      defaultTransition: Transition.noTransition,

      theme: ThemeData(
        primarySwatch: Colors.grey,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
        ),
        pageTransitionsTheme: PageTransitionsTheme(
          builders: {
            TargetPlatform.android: NoTransitionsBuilder(),
            TargetPlatform.iOS:  NoTransitionsBuilder(),
          },
        ),
        // Performance optimizations
        textTheme: const TextTheme(
          bodyMedium: TextStyle(fontFamily: 'Roboto'),
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      
      home: const SplashScreen(),
      
      getPages: [
        GetPage(
          name: '/login', 
          page: () => const LoginScreen(),
          transition: Transition.fadeIn,
          transitionDuration: const Duration(milliseconds: 200),
        ),
        GetPage(
          name: '/main', 
          page: () => const MainScreen(),
          transition: Transition.fadeIn,
          transitionDuration: const Duration(milliseconds: 200),
        ),
        GetPage(
          name: '/dashboard', 
          page: () => const DashboardScreen(showAppBar: true),
          transition: Transition.fadeIn,
          transitionDuration: const Duration(milliseconds: 200),
        ),
      ],
      
      // Performance optimizations
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
          child: child!,
        );
      },
    );
  }
}
