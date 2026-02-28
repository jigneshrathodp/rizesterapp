import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rizesterapp/screens/Profile/login_screen.dart';
import 'package:rizesterapp/widgets/widgets.dart';
import 'package:device_preview/device_preview.dart';

void main() {
  runApp(
    // DevicePreview(
    //   enabled: true,
    //   builder: (context) => const MyApp(),
    // ),
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

      //DevicePreview
      // builder: DevicePreview.appBuilder,
      // locale: DevicePreview.locale(context),

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
            TargetPlatform.iOS: NoTransitionsBuilder(),
          },
        ),
      ),
      home: LayoutBuilder(
        builder: (context, constraints) {
          return ResponsiveLayout(
            mobile: LoginScreen(),
            tablet: LoginScreen(),
            desktop: LoginScreen(),
          );
        },
      ),
      debugShowCheckedModeBanner: false,
      defaultTransition: Transition.noTransition,
    );
  }
}

