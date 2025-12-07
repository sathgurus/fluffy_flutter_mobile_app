import 'package:fluffy/modules/auth/helper/category_initilizer.dart';
import 'package:fluffy/modules/auth/provider/auth_provider.dart';
import 'package:fluffy/modules/auth/register_business_screens/add_location.dart';
import 'package:fluffy/modules/auth/register_business_screens/business_hours.dart';
import 'package:fluffy/modules/auth/register_business_screens/business_verification.dart';
import 'package:fluffy/modules/auth/register_business_screens/add_service.dart';
import 'package:fluffy/modules/auth/register_business_screens/provider/Add_service_provider.dart';
import 'package:fluffy/modules/auth/register_business_screens/provider/business_hours_provider.dart';
import 'package:fluffy/modules/auth/register_business_screens/provider/business_verification_provider.dart';
import 'package:fluffy/modules/auth/register_business_screens/provider/location_provider.dart';
import 'package:fluffy/modules/service/provider/service_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

import 'package:fluffy/modules/shared/app_theme/app_colors.dart';
import 'package:fluffy/modules/auth/provider/register_provider.dart';
import 'package:fluffy/modules/layout/widgets/route_generator.dart';
import 'package:fluffy/modules/layout/widgets/splash_screen.dart';

import 'adminPannel/adminLogin/admin_login.dart';
import 'core/NavigationService.dart';
import 'modules/auth/login.dart';
import 'modules/layout/widgets/bottom_nav.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ✅ Load your environment variables
  await dotenv.load(fileName: ".env");

  final authProvider = LoginProvider();
  await authProvider.loadUserData();

  print("user details ${authProvider.userDetails}");
  await CategoryInitializer.initDefaultCategories();
  runApp(const FluffyApp());
}

class FluffyApp extends StatefulWidget {
  const FluffyApp({super.key});

  @override
  State<FluffyApp> createState() => _FluffyAppState();
}

class _FluffyAppState extends State<FluffyApp> with WidgetsBindingObserver {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  BuildContext get globalContext => navigatorKey.currentContext!;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => RegisterProvider()),
        ChangeNotifierProvider(create: (_) => LoginProvider()),
        ChangeNotifierProvider(create: (_) => ServiceProvider()),
        ChangeNotifierProvider(create: (_) => LocationProvider()),
        ChangeNotifierProvider(create: (_) => AddServiceProvider()),
        ChangeNotifierProvider(create: (_) => BusinessVerificationProvider()),
        ChangeNotifierProvider(create: (_) => BusinessHoursProvider()),
        // 👇 Add other providers here if needed later
      ],
      child: FutureBuilder(
        future: initializeAppColors(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const MaterialApp(
              home: Scaffold(body: Center(child: CircularProgressIndicator())),
            );
          }

          // Once initialization completes
          return MaterialApp(
            title: "Fluffy",
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              primaryColor: AppColors.primary,
              scaffoldBackgroundColor: AppColors.background,
              colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
            ),
            navigatorKey: NavigationService().navigatorKey,
            routes: {
              '/': (context) => const SplashScreen(),
              '/login': (context) => const AddServices(),
              '/home': (context) => const BottomNav(),
              '/adminLogin': (context) => const AdminLogin(),
              // 👇 Add other Routers here if needed later
            },
            onGenerateRoute: RouteGenerator.generateRoute,
          );
        },
      ),
    );
  }
}
