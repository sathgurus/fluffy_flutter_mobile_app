
import 'package:fluffy/modules/auth/login.dart';
import 'package:fluffy/modules/dashoboard/home.dart';
import 'package:fluffy/modules/layout/more_menu.dart';
import 'package:fluffy/modules/layout/widgets/splash_screen.dart';
import 'package:fluffy/modules/orders/orders.dart';
import 'package:fluffy/modules/service/services.dart';
import 'package:flutter/material.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final arg = settings.arguments;
    print('arg ,$arg');
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (context) => const SplashScreen());

      case 'login':
        return MaterialPageRoute(builder: (context) => const LoginScreen());

      case 'home':
        return MaterialPageRoute(builder: (context) => const HomeScreen());

      case 'service':
        return MaterialPageRoute(builder: (context) => const ServicesScreen());

      case 'order':
        return MaterialPageRoute(builder: (context) => const OrdersScreen());
      case 'more':
        return MaterialPageRoute(builder: (context) => const MoreScreen());
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(
      builder: (context) {
        return Scaffold(
          appBar: AppBar(title: Text("Error"), centerTitle: true),
          body: Center(child: Text("Page not found")),
        );
      },
    );
  }
}
