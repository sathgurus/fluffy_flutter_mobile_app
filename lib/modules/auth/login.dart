import 'package:fluffy/core/NavigationService.dart';
import 'package:fluffy/modules/auth/register_business_screens/business_login.dart';
import 'package:fluffy/modules/auth/register_customer_screens/customer_login.dart';
import 'package:fluffy/modules/layout/widgets/bottom_nav.dart';
import 'package:fluffy/modules/shared/app_theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginTabsScreen extends StatefulWidget {
  const LoginTabsScreen({super.key});

  @override
  State<LoginTabsScreen> createState() => _LoginTabsScreenState();
}

class _LoginTabsScreenState extends State<LoginTabsScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() => setState(() {}));
   // _checkUser();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // String firstRouts = '';
  // Future<void> _checkUser() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   String? token = prefs.getString('token');

  //   print("token $token");
  //   final nav = NavigationService();

  //   if (token != null) {
  //     nav.pushReplacementPage(const BottomNav());
  //   } else {
  //     if (dotenv.env['BUILD'] == 'admin') {
  //       nav.pushReplacementNamed('/adminLogin');
  //     } else {
  //       nav.pushReplacementNamed('/login');
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          const SizedBox(height: 50),
          Container(
            padding: const EdgeInsets.all(8),
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  color: Colors.white,
                  child: TabBar(
                    controller: _tabController,
                    isScrollable: false, // ✅ Make tabs expand
                    tabAlignment:
                        TabAlignment.fill, // ✅ Fill full width equally
                    labelColor: AppColors.primary,
                    indicator: const BoxDecoration(),
                    indicatorColor: Colors.transparent,

                    // ✅ No divider / bottom border
                    dividerColor: Colors.transparent,

                    unselectedLabelColor: Colors.black,
                    tabs: [
                      Tab(
                        child: Text(
                          "Business Login",
                          style: TextStyle(
                            color:
                                _tabController.index == 0
                                    ? AppColors.primary
                                    : Colors.black,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Tab(
                        child: Text(
                          "Customer Login",
                          style: TextStyle(
                            color:
                                _tabController.index == 1
                                    ? AppColors.primary
                                    : Colors.black,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: const [
                BusinessLoginScreen(businessOwnerLogin: "owner"),
                CustomerLoginScreen(customerLogin: "customer"),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
