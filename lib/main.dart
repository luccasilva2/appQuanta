import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:provider/provider.dart';
import 'package:page_transition/page_transition.dart';
import 'package:lottie/lottie.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/main_navigation_screen.dart';
import 'screens/create_app_screen.dart';
import 'screens/my_apps_screen.dart';
import 'screens/settings_screen.dart';
import 'theme/app_theme.dart';
import 'providers/app_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicialização do Supabase
  await Supabase.initialize(
    url: 'https://wxawdhztczfjizcsrkoj.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Ind4YXdkaHp0Y3pmaml6Y3Nya29qIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjIzMjU3ODYsImV4cCI6MjA3NzkwMTc4Nn0.i7ZfWI74en5eNEQK_6VMDBui3KjavnypxH55_-T5YUw',
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => AppProvider())],
      child: Consumer<AppProvider>(
        builder: (context, appProvider, child) {
          return ColorFiltered(
            colorFilter: appProvider.isGrayscaleMode
                ? const ColorFilter.matrix([
                    0.2126,
                    0.7152,
                    0.0722,
                    0,
                    0,
                    0.2126,
                    0.7152,
                    0.0722,
                    0,
                    0,
                    0.2126,
                    0.7152,
                    0.0722,
                    0,
                    0,
                    0,
                    0,
                    0,
                    1,
                    0,
                  ])
                : const ColorFilter.matrix([
                    1,
                    0,
                    0,
                    0,
                    0,
                    0,
                    1,
                    0,
                    0,
                    0,
                    0,
                    0,
                    1,
                    0,
                    0,
                    0,
                    0,
                    0,
                    1,
                    0,
                  ]),
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'AppQuanta',
              theme: AppTheme.lightTheme,
              darkTheme: AppTheme.darkTheme,
              themeMode: appProvider.themeMode,
              home: const SupabaseInitializer(),
              onGenerateRoute: (settings) {
                switch (settings.name) {
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
                  case '/main':
                    return PageTransition(
                      child: const MainNavigationScreen(),
                      type: PageTransitionType.fade,
                      duration: const Duration(milliseconds: 300),
                    );
                  case '/create':
                    return PageTransition(
                      child: const CreateAppScreen(),
                      type: PageTransitionType.rightToLeft,
                      duration: const Duration(milliseconds: 300),
                    );
                  case '/my-apps':
                    return PageTransition(
                      child: const MyAppsScreen(),
                      type: PageTransitionType.rightToLeft,
                      duration: const Duration(milliseconds: 300),
                    );
                  case '/settings':
                    return PageTransition(
                      child: const SettingsScreen(),
                      type: PageTransitionType.rightToLeft,
                      duration: const Duration(milliseconds: 300),
                    );
                  default:
                    return null;
                }
              },
            ),
          );
        },
      ),
    );
  }
}

class SupabaseInitializer extends StatefulWidget {
  const SupabaseInitializer({super.key});

  @override
  State<SupabaseInitializer> createState() => _SupabaseInitializerState();
}

class _SupabaseInitializerState extends State<SupabaseInitializer> {
  bool _isReady = false;

  @override
  void initState() {
    super.initState();
    _initSupabase();
  }

  Future<void> _initSupabase() async {
    try {
      // Testa a conexão com a tabela users
      final response = await Supabase.instance.client
          .from('users')
          .select('id')
          .limit(1);
      debugPrint(
        'Conexão com Supabase estabelecida: ${response.length} registros encontrados',
      );
    } catch (e) {
      debugPrint('Erro ao conectar Supabase: $e');
    } finally {
      setState(() => _isReady = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isReady) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return const LoginScreen();
  }
}
