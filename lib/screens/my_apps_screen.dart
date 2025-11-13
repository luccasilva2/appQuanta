import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/api_service.dart';
import 'app_preview_screen.dart';

class MyAppsScreen extends StatefulWidget {
  const MyAppsScreen({super.key});

  @override
  State<MyAppsScreen> createState() => _MyAppsScreenState();
}

class _MyAppsScreenState extends State<MyAppsScreen> {
  final ApiService _apiService = ApiService();

  Future<List<Map<String, dynamic>>> _fetchApps() async {
    return await _apiService.getUserApps();
  }

  // Example apps data
  final List<Map<String, dynamic>> exampleApps = [
    {
      'name': 'Calculadora Simples',
      'type': 'Utilitário',
      'status': 'Completo',
      'createdAt': DateTime.now().subtract(const Duration(days: 30)),
    },
    {
      'name': 'Lista de Tarefas',
      'type': 'Produtividade',
      'status': 'Completo',
      'createdAt': DateTime.now().subtract(const Duration(days: 20)),
    },
    {
      'name': 'Galeria de Fotos',
      'type': 'Mídia',
      'status': 'Em desenvolvimento',
      'createdAt': DateTime.now().subtract(const Duration(days: 10)),
    },
    {
      'name': 'Clima Atual',
      'type': 'Informação',
      'status': 'Completo',
      'createdAt': DateTime.now().subtract(const Duration(days: 5)),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset(
              'assets/logo1.png',
              width: 30,
              height: 30,
              fit: BoxFit.contain,
            ),
            const SizedBox(width: 8),
            const Text('Meus Apps'),
          ],
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).colorScheme.surface,
              Theme.of(context).colorScheme.surface.withOpacity(0.8),
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: _fetchApps(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Erro ao carregar apps',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  );
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final apps = snapshot.data ?? [];

                if (apps.isEmpty) {
                  return GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: 0.8,
                        ),
                    itemCount: exampleApps.length,
                    itemBuilder: (context, index) {
                      final exampleApp = exampleApps[index];
                      return _AppCard(
                        app: null,
                        isExample: true,
                        exampleData: exampleApp,
                      );
                    },
                  );
                }

                return GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.8,
                  ),
                  itemCount: apps.length,
                  itemBuilder: (context, index) {
                    final app = apps[index] as Map<String, dynamic>;
                    return _AppCard(app: app);
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _AppCard extends StatelessWidget {
  final Map<String, dynamic>? app;
  final bool isExample;
  final Map<String, dynamic>? exampleData;

  const _AppCard({this.app, this.isExample = false, this.exampleData});

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> appData;
    if (isExample && exampleData != null) {
      appData = exampleData!;
    } else if (app != null) {
      appData = app!;
    } else {
      return const SizedBox.shrink();
    }

    final createdAt = isExample
        ? appData['createdAt'] as DateTime?
        : DateTime.tryParse(appData['created_at'] as String? ?? '');
    final formattedDate = createdAt != null
        ? '${createdAt.day}/${createdAt.month}/${createdAt.year}'
        : 'Data desconhecida';

    final appType = isExample
        ? appData['type'] as String? ?? 'App'
        : (appData['screens'] as List<dynamic>? ?? []).isNotEmpty
        ? appData['screens'][0]
        : 'App';

    // Generate a consistent color based on app name for visual distinction
    final int colorSeed = appData['name'].hashCode;
    final Color appColor = HSLColor.fromAHSL(
      1.0,
      (colorSeed % 360).toDouble(),
      0.7,
      0.6,
    ).toColor();

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: InkWell(
        onTap: isExample
            ? () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Este é um aplicativo de exemplo. Crie seu próprio app!',
                    ),
                    duration: Duration(seconds: 2),
                  ),
                );
              }
            : () {
                // Navigate to preview screen for real apps
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AppPreviewScreen(appData: appData),
                  ),
                );
              },
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [appColor.withOpacity(0.1), appColor.withOpacity(0.05)],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: appColor,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: appColor.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(
                  PhosphorIcons.appWindow(), // Generic icon for now
                  color: Colors.white,
                  size: 32,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                appData['name'] ?? 'App sem nome',
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Text(
                '$appType - $formattedDate',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withOpacity(0.6),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              if (isExample)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Exemplo',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                )
              else
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: appColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    appData['status'] ?? 'Em construção',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: appColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
