import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:lottie/lottie.dart';
import '../services/api_service.dart';
import 'app_preview_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService _apiService = ApiService();
  late Future<List<Map<String, dynamic>>> _appsFuture;

  @override
  void initState() {
    super.initState();
    _appsFuture = _loadApps();
  }

  Future<List<Map<String, dynamic>>> _loadApps() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return [];

    final apps = await _apiService.getUserApps();

    // Add example app if empty
    if (apps.isEmpty) {
      await _apiService.createApp(
        name: 'Meu Primeiro App',
        description: 'App de exemplo criado automaticamente',
        status: 'active',
      );
      // Reload apps after creating example
      return await _apiService.getUserApps();
    }

    return apps;
  }

  @override
  Widget build(BuildContext context) {
    final user = Supabase.instance.client.auth.currentUser;
    final userName = user?.userMetadata?['display_name'] ?? 'Usuário';
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDarkMode
                ? [
                    Theme.of(context).colorScheme.surface,
                    Theme.of(context).colorScheme.surface.withOpacity(0.8),
                  ]
                : [const Color(0xFFF5F5F5), Colors.white],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Personalized greeting with animation
                AnimatedOpacity(
                  opacity: 1.0,
                  duration: const Duration(milliseconds: 500),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Image.asset(
                            'assets/logo1.png',
                            width: 40,
                            height: 40,
                            fit: BoxFit.contain,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Bem-vindo de volta, $userName',
                              style: Theme.of(context).textTheme.headlineMedium
                                  ?.copyWith(fontWeight: FontWeight.w600),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Pronto para criar algo incrível hoje?',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurface.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // Quick Actions Section
                Text(
                  'Ações Rápidas',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 16),
                GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    _QuickActionCard(
                      icon: PhosphorIcons.plus(),
                      title: 'Novo App',
                      subtitle: 'Criar aplicativo',
                      onTap: () {
                        Navigator.pushNamed(context, '/create');
                      },
                    ),
                    _QuickActionCard(
                      icon: PhosphorIcons.palette(),
                      title: 'Templates',
                      subtitle: 'Usar modelo',
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Templates em breve!')),
                        );
                      },
                    ),
                    _QuickActionCard(
                      icon: PhosphorIcons.appWindow(),
                      title: 'Meus Apps',
                      subtitle: 'Ver todos os apps',
                      onTap: () {
                        Navigator.pushNamed(context, '/my-apps');
                      },
                    ),
                    _QuickActionCard(
                      icon: PhosphorIcons.gear(),
                      title: 'Configurações',
                      subtitle: 'Ajustes do app',
                      onTap: () {
                        Navigator.pushNamed(context, '/settings');
                      },
                    ),
                    _QuickActionCard(
                      icon: PhosphorIcons.question(),
                      title: 'Ajuda',
                      subtitle: 'Tutoriais e suporte',
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Central de ajuda em breve!'),
                          ),
                        );
                      },
                    ),
                    _QuickActionCard(
                      icon: PhosphorIcons.chartBar(),
                      title: 'Estatísticas',
                      subtitle: 'Análise de uso',
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Estatísticas em breve!'),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 32),

                // Apps section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Seus Apps',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/my-apps');
                      },
                      child: const Text('Ver todos'),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Apps list from server
                user == null
                    ? const Center(child: Text('Usuário não autenticado'))
                    : FutureBuilder<List<Map<String, dynamic>>>(
                        future: _appsFuture,
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return Center(
                              child: Text(
                                'Erro ao carregar apps: ${snapshot.error}',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            );
                          }

                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                          final apps = snapshot.data ?? [];

                          if (apps.isEmpty) {
                            return _buildEmptyState();
                          }

                          return ListView.builder(
                            itemCount: apps.length,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              final app = apps[index];
                              return _AppCard(app: app);
                            },
                          );
                        },
                      ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Builder(
        builder: (BuildContext innerContext) {
          final theme = Theme.of(innerContext);
          final colorScheme = theme.colorScheme;
          final textTheme = theme.textTheme;

          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                PhosphorIcons.puzzlePiece(),
                size: 64,
                color: colorScheme.onSurface.withOpacity(0.5),
              ),
              const SizedBox(height: 16),
              Text('Nenhum app criado ainda', style: textTheme.headlineSmall),
              const SizedBox(height: 8),
              Text(
                'Comece criando seu primeiro app!',
                style: textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ],
          );
        },
      ),
    );
  }
}

class _QuickActionCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _QuickActionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  State<_QuickActionCard> createState() => _QuickActionCardState();
}

class _QuickActionCardState extends State<_QuickActionCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    _animationController.forward();
  }

  void _onTapUp(TapUpDetails details) {
    _animationController.reverse();
  }

  void _onTapCancel() {
    _animationController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Theme.of(context).colorScheme.outline.withOpacity(0.1),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(
                      context,
                    ).colorScheme.shadow.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: Theme.of(
                        context,
                      ).colorScheme.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      widget.icon,
                      color: Theme.of(context).colorScheme.primary,
                      size: 24,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.title,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.subtitle,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _AppCard extends StatelessWidget {
  final Map<String, dynamic> app;

  const _AppCard({required this.app});

  String _formatDate(String? createdAt) {
    if (createdAt == null) return 'Data desconhecida';
    try {
      return DateTime.parse(
        createdAt,
      ).toLocal().toString().split(' ')[0].split('-').reversed.join('/');
    } catch (e) {
      return 'Data inválida';
    }
  }

  String _getAppType(List<dynamic> screens) {
    if (screens.isEmpty) return 'App';
    final firstScreen = screens.first;
    return firstScreen is String ? firstScreen : 'App';
  }

  @override
  Widget build(BuildContext context) {
    final createdAt = app['created_at'] as String?;
    final formattedDate = _formatDate(createdAt);

    // Determine app type based on screens or default
    final screens = app['screens'] as List<dynamic>? ?? [];
    final appType = _getAppType(screens);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.1),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.shadow.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Builder(
        builder: (BuildContext innerContext) {
          final theme = Theme.of(innerContext);
          final colorScheme = theme.colorScheme;
          final textTheme = theme.textTheme;

          return InkWell(
            onTap: () {
              // Navigate to preview screen
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AppPreviewScreen(appData: app),
                ),
              );
            },
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: colorScheme.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      PhosphorIcons.appWindow(),
                      color: colorScheme.primary,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          app['name'] ?? 'App sem nome',
                          style: textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Text(
                              appType,
                              style: textTheme.bodySmall?.copyWith(
                                color: colorScheme.onSurface.withOpacity(0.6),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              width: 4,
                              height: 4,
                              decoration: BoxDecoration(
                                color: colorScheme.onSurface.withOpacity(0.3),
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              formattedDate,
                              style: textTheme.bodySmall?.copyWith(
                                color: colorScheme.onSurface.withOpacity(0.6),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: colorScheme.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            app['status'] ?? 'Em construção',
                            style: textTheme.bodySmall?.copyWith(
                              color: colorScheme.primary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    PhosphorIcons.caretRight(),
                    color: colorScheme.onSurface.withOpacity(0.5),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
