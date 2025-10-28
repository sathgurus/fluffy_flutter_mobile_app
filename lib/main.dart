import 'package:fluffy/modules/auth/provider/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

import 'package:fluffy/modules/app_theme/app_colors.dart';
import 'package:fluffy/modules/auth/provider/register_provider.dart';
import 'package:fluffy/modules/layout/widgets/route_generator.dart';
import 'package:fluffy/modules/layout/widgets/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ✅ Load your environment variables
  await dotenv.load(fileName: ".env");

  final authProvider = LoginProvider();
  await authProvider.loadUserData();

  print("user details ${authProvider.userDetails}");

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
        // 👇 Add other providers here if needed later
      ],
      child: FutureBuilder(
        future: initializeAppColors(),
        builder: (context, snapshot) {
          // While waiting for initialization
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
            navigatorKey: navigatorKey,
            onGenerateRoute: RouteGenerator.generateRoute,
            home: const SplashScreen(),
          );
        },
      ),
    );
  }
}
