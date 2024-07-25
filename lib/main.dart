import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vma_frontend/src/about.dart';
import 'package:vma_frontend/src/providers/user_provider.dart';
import 'package:vma_frontend/src/providers/visitor_provider.dart';
import 'package:vma_frontend/src/screens/admin/admin_dashboard.dart';
import 'package:vma_frontend/src/screens/admin/create_users_page.dart';
import 'package:vma_frontend/src/screens/approvalDivision/approval_div_screen.dart';
import 'package:vma_frontend/src/screens/depHead/dep_head_home.dart';
import 'package:vma_frontend/src/screens/depHead/manage_visitors_screen.dart';
import 'package:vma_frontend/src/screens/login.dart';

import 'package:vma_frontend/src/screens/securityDivision/security_screen.dart';
import 'package:vma_frontend/src/services/auth_services.dart';
import 'package:vma_frontend/src/settings_page.dart';
import 'package:vma_frontend/src/services/socket_service.dart';
import 'package:vma_frontend/src/screens/admin/plate_numbers.dart';
import 'package:vma_frontend/src/screens/admin/possessions.dart';
import 'package:vma_frontend/src/screens/admin/user_count.dart';
import 'package:vma_frontend/src/screens/admin/visitors_info.dart';
void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => UserProvider()),
      ChangeNotifierProvider(
          create: (_) => VisitorProvider()), 
      Provider<SocketService>(
        create: (_) => SocketService()..initializeSocket(),
      ),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final AuthService authService = AuthService();
  final String visitorId = '';

  @override
  void initState() {
    super.initState();
    authService.getUserData(context);
  }

  void _onNavigate(BuildContext context, String route) {
    Navigator.of(context).pushNamed(route);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Secure Gate',
      initialRoute: '/',
      debugShowCheckedModeBanner: false,
      routes: {
        '/': (context) =>const SignInApp(),             
        '/about': (context) => AboutPage(),
        '/settings': (context) => const SettingsPage(),
        '/admin': (context) => AdminDashboard(),
        '/approval_div': (context) => ApprovalDivision(),
        '/dep_head': (context) => DepartmentHeadsPage(),
        '/manage_visitors': (context) => const ManageVisitorsScreen(),
        '/create_users': (context) => const CreateUserScreen(),
        '/security': (context) => SecurityScreen(),
                     
      '/allowedPlateNumbers': (context) => AllowedPlateNumbersPage(),
      '/allowedPossessions': (context) => AllowedPossessionsPage(),
      '/visitorsInfo': (context) => VisitorsInfo(),
      '/userCount': (context) =>  UserCount(),
      },
      
    );
  }
}
