import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/home_screen.dart';
import 'screens/create_app_screen.dart';
import 'screens/my_apps_screen.dart';
import 'screens/settings_screen.dart';

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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AppQuanta',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const SupabaseInitializer(),
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/login':
            return MaterialPageRoute(builder: (context) => const LoginScreen());
          case '/register':
            return MaterialPageRoute(
              builder: (context) => const RegisterScreen(),
            );
          case '/main':
            return MaterialPageRoute(builder: (context) => const HomeScreen());
          case '/create':
            return MaterialPageRoute(
              builder: (context) => const CreateAppScreen(),
            );
          case '/my-apps':
            return MaterialPageRoute(
              builder: (context) => const MyAppsScreen(),
            );
          case '/settings':
            return MaterialPageRoute(
              builder: (context) => const SettingsScreen(),
            );
          default:
            return null;
        }
      },
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
