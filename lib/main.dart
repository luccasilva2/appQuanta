import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'theme/app_theme.dart';
import 'widgets/bottom_nav_bar.dart';
import 'screens/home_screen.dart';
import 'screens/create_app_screen.dart';
import 'screens/my_apps_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AppQuanta',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: const LoginScreen(),
      routes: {
        '/main': (context) => const MainScreen(),
        '/create': (context) => const CreateAppScreen(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
      },
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/main':
            return PageTransition(
              child: const MainScreen(),
              type: PageTransitionType.fade,
              duration: const Duration(milliseconds: 300),
            );
          case '/create':
            return PageTransition(
              child: const CreateAppScreen(),
              type: PageTransitionType.fade,
              duration: const Duration(milliseconds: 300),
            );
          case '/login':
            return PageTransition(
              child: const LoginScreen(),
              type: PageTransitionType.fade,
              duration: const Duration(milliseconds: 300),
            );
          case '/register':
            return PageTransition(
              child: const RegisterScreen(),
              type: PageTransitionType.fade,
              duration: const Duration(milliseconds: 300),
            );
          default:
            return null;
        }
      },
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const MyAppsScreen(),
    const ProfileScreen(),
  ];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (child, animation) {
          return FadeTransition(opacity: animation, child: child);
        },
        child: _screens[_currentIndex],
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
      ),
    );
  }
}
