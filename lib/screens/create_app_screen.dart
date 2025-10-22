import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:ui';
import 'package:lottie/lottie.dart';

class CreateAppScreen extends StatefulWidget {
  const CreateAppScreen({super.key});

  @override
  State<CreateAppScreen> createState() => _CreateAppScreenState();
}

class _CreateAppScreenState extends State<CreateAppScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;

  final TextEditingController _appNameController = TextEditingController();
  final TextEditingController _appDescriptionController =
      TextEditingController();
  String _selectedIcon = 'app';
  Color _selectedColor = const Color(0xFF4E9FFF);
  final List<String> _selectedScreens = ['Home', 'About'];

  final SupabaseClient _supabase = Supabase.instance.client;

  bool _isGenerating = false;

  final List<Map<String, dynamic>> _icons = [
    {'name': 'app', 'icon': PhosphorIcons.appWindow()},
    {'name': 'game', 'icon': PhosphorIcons.gameController()},
    {'name': 'shopping', 'icon': PhosphorIcons.shoppingBag()},
    {'name': 'chat', 'icon': PhosphorIcons.chat()},
  ];

  final List<Color> _colors = [
    const Color(0xFF4E9FFF), // Electric Blue
    const Color(0xFF28A745), // Green
    const Color(0xFFDC3545), // Red
    const Color(0xFFFFC107), // Yellow
    const Color(0xFF6F42C1), // Purple
  ];

  final List<String> _availableScreens = [
    'Home',
    'About',
    'Contact',
    'Gallery',
    'Settings',
    'Profile',
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    _slideAnimation = Tween<double>(begin: 20.0, end: 0.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _appNameController.dispose();
    _appDescriptionController.dispose();
    super.dispose();
  }

  Future<void> _generateApp() async {
    if (_appNameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, insira um nome para o app')),
      );
      return;
    }

    setState(() {
      _isGenerating = true;
    });

    try {
      final user = _supabase.auth.currentUser;
      if (user == null) return;

      // Simulate generation delay
      await Future.delayed(const Duration(seconds: 2));

      // Save to Supabase
      await _supabase.from('apps').insert({
        'name': _appNameController.text.trim(),
        'description': _appDescriptionController.text.trim(),
        'icon': _selectedIcon,
        'color': _selectedColor.value,
        'screens': _selectedScreens,
        'user_id': user.id,
        'status': 'Em construção',
        'created_at': DateTime.now().toIso8601String(),
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('App criado com sucesso!')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Erro ao criar app: $e')));
      }
    } finally {
      if (mounted) {
        setState(() {
          _isGenerating = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Criar App'),
        leading: IconButton(
          icon: Icon(PhosphorIcons.arrowLeft()),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: AnimatedBuilder(
            animation: _slideAnimation,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(0, _slideAnimation.value),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      Text(
                        'Crie seu novo aplicativo',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 32),

                      // App Name
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: Theme.of(
                            context,
                          ).colorScheme.surface.withOpacity(0.8),
                          border: Border.all(
                            color: Theme.of(
                              context,
                            ).colorScheme.outline.withOpacity(0.2),
                            width: 1,
                          ),
                        ),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                          child: TextField(
                            controller: _appNameController,
                            decoration: InputDecoration(
                              labelText: 'Nome do App',
                              hintText: 'Ex: Meu App Incrível',
                              prefixIcon: Icon(PhosphorIcons.textAa()),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.all(16),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // App Description
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: Theme.of(
                            context,
                          ).colorScheme.surface.withOpacity(0.8),
                          border: Border.all(
                            color: Theme.of(
                              context,
                            ).colorScheme.outline.withOpacity(0.2),
                            width: 1,
                          ),
                        ),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                          child: TextField(
                            controller: _appDescriptionController,
                            maxLines: 3,
                            decoration: InputDecoration(
                              labelText: 'Descrição (opcional)',
                              hintText:
                                  'Descreva brevemente o propósito do seu app',
                              prefixIcon: Icon(PhosphorIcons.article()),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.all(16),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Icon Selection
                      Text(
                        'Ícone do App',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 16),
                      Wrap(
                        spacing: 16,
                        runSpacing: 16,
                        children: _icons.map((iconData) {
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedIcon = iconData['name'];
                              });
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                color: _selectedIcon == iconData['name']
                                    ? Theme.of(
                                        context,
                                      ).colorScheme.primary.withOpacity(0.1)
                                    : Theme.of(context).colorScheme.surface,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: _selectedIcon == iconData['name']
                                      ? Theme.of(context).colorScheme.primary
                                      : Theme.of(
                                          context,
                                        ).colorScheme.outline.withOpacity(0.3),
                                  width: 2,
                                ),
                              ),
                              child: Icon(
                                iconData['icon'],
                                size: 32,
                                color: _selectedIcon == iconData['name']
                                    ? Theme.of(context).colorScheme.primary
                                    : Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 32),

                      // Color Selection
                      Text(
                        'Cor Principal',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 16),
                      Wrap(
                        spacing: 16,
                        runSpacing: 16,
                        children: _colors.map((color) {
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedColor = color;
                              });
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                color: color,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: _selectedColor == color
                                      ? Colors.white
                                      : Colors.transparent,
                                  width: 3,
                                ),
                                boxShadow: _selectedColor == color
                                    ? [
                                        BoxShadow(
                                          color: color.withOpacity(0.4),
                                          blurRadius: 8,
                                          spreadRadius: 2,
                                        ),
                                      ]
                                    : null,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 32),

                      // Screens Selection
                      Text(
                        'Telas do App',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 16),
                      Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children: _availableScreens.map((screen) {
                          final isSelected = _selectedScreens.contains(screen);
                          return FilterChip(
                            label: Text(screen),
                            selected: isSelected,
                            onSelected: (selected) {
                              setState(() {
                                if (selected) {
                                  _selectedScreens.add(screen);
                                } else {
                                  _selectedScreens.remove(screen);
                                }
                              });
                            },
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 48),

                      // Generate Button
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        width: double.infinity,
                        height: 60,
                        child: InkWell(
                          onTap: _isGenerating ? null : _generateApp,
                          borderRadius: BorderRadius.circular(16),
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: _isGenerating
                                  ? null
                                  : const LinearGradient(
                                      colors: [
                                        Color(0xFF4E9FFF),
                                        Color(0xFF00D4FF),
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                              color: _isGenerating
                                  ? Theme.of(
                                      context,
                                    ).colorScheme.primary.withOpacity(0.7)
                                  : null,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: _isGenerating
                                  ? null
                                  : [
                                      BoxShadow(
                                        color: const Color(
                                          0xFF4E9FFF,
                                        ).withOpacity(0.3),
                                        blurRadius: 12,
                                        offset: const Offset(0, 6),
                                      ),
                                    ],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _isGenerating
                                    ? SizedBox(
                                        width: 24,
                                        height: 24,
                                        child: Lottie.asset(
                                          'assets/animations/loading.json',
                                          fit: BoxFit.contain,
                                        ),
                                      )
                                    : Icon(
                                        PhosphorIcons.sparkle(),
                                        color: Colors.white,
                                      ),
                                const SizedBox(width: 12),
                                Text(
                                  _isGenerating
                                      ? 'Criando estrutura...'
                                      : 'Gerar Estrutura',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Recent Projects Section
                      FutureBuilder<List<Map<String, dynamic>>>(
                        future: _supabase
                            .from('apps')
                            .select()
                            .eq('user_id', _supabase.auth.currentUser?.id ?? '')
                            .order('created_at', ascending: false)
                            .limit(3),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData || snapshot.data!.isEmpty) {
                            return const SizedBox.shrink();
                          }

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Meus Projetos Recentes',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              const SizedBox(height: 16),
                              SizedBox(
                                height: 120,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: snapshot.data!.length,
                                  itemBuilder: (context, index) {
                                    final app = snapshot.data![index];
                                    return AnimatedBuilder(
                                      animation: _animationController,
                                      builder: (context, child) {
                                        final delay = index * 0.1;
                                        final animation =
                                            Tween<double>(
                                              begin: 0.0,
                                              end: 1.0,
                                            ).animate(
                                              CurvedAnimation(
                                                parent: _animationController,
                                                curve: Interval(
                                                  delay,
                                                  delay + 0.3,
                                                  curve: Curves.easeOut,
                                                ),
                                              ),
                                            );
                                        return Transform.translate(
                                          offset: Offset(
                                            50 * (1 - animation.value),
                                            0,
                                          ),
                                          child: Opacity(
                                            opacity: animation.value,
                                            child: Container(
                                              width: 200,
                                              margin: const EdgeInsets.only(
                                                right: 16,
                                              ),
                                              padding: const EdgeInsets.all(16),
                                              decoration: BoxDecoration(
                                                color: Theme.of(
                                                  context,
                                                ).colorScheme.surface,
                                                borderRadius:
                                                    BorderRadius.circular(16),
                                                border: Border.all(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .outline
                                                      .withOpacity(0.3),
                                                ),
                                              ),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Container(
                                                        width: 32,
                                                        height: 32,
                                                        decoration: BoxDecoration(
                                                          color: Color(
                                                            app['color'] ??
                                                                0xFF4E9FFF,
                                                          ).withOpacity(0.1),
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                8,
                                                              ),
                                                        ),
                                                        child: Icon(
                                                          _icons.firstWhere(
                                                            (icon) =>
                                                                icon['name'] ==
                                                                app['icon'],
                                                            orElse: () =>
                                                                _icons.first,
                                                          )['icon'],
                                                          size: 16,
                                                          color: Color(
                                                            app['color'] ??
                                                                0xFF4E9FFF,
                                                          ),
                                                        ),
                                                      ),
                                                      const SizedBox(width: 8),
                                                      Expanded(
                                                        child: Text(
                                                          app['name'] ?? 'App',
                                                          style: Theme.of(context)
                                                              .textTheme
                                                              .bodyMedium
                                                              ?.copyWith(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                              ),
                                                          maxLines: 1,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(height: 8),
                                                  Text(
                                                    app['status'] ??
                                                        'Em construção',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodySmall
                                                        ?.copyWith(
                                                          color: Theme.of(
                                                            context,
                                                          ).colorScheme.primary,
                                                        ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
