import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isDarkMode = false;
  bool _isAboutExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xFF212529), // Matte black
              const Color(0xFF007BFF), // Metallic blue
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // User Info Section
                Center(
                  child: Column(
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: const LinearGradient(
                            colors: [Color(0xFF007BFF), Color(0xFF6C757D)],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 15,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                      child: Icon(
                        PhosphorIcons.user(),
                        color: Colors.white,
                        size: 50,
                      ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Usuário AppQuanta',
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              color: Colors.white,
                            ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'usuario@appquanta.com',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: Colors.white.withOpacity(0.8),
                            ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),

                // Settings Section
                Text(
                  'Configurações',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: Colors.white,
                      ),
                ),
                const SizedBox(height: 16),

                // Dark Mode Toggle
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                        Row(
                          children: [
                            Icon(
                              _isDarkMode ? PhosphorIcons.moon() : PhosphorIcons.sun(),
                              color: Colors.white,
                            ),
                          const SizedBox(width: 12),
                          Text(
                            'Tema ${_isDarkMode ? 'Escuro' : 'Claro'}',
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                  color: Colors.white,
                                ),
                          ),
                        ],
                      ),
                      Switch(
                        value: _isDarkMode,
                        onChanged: (value) {
                          setState(() {
                            _isDarkMode = value;
                          });
                          // Here you would typically change the theme
                          // For now, we'll just update the state
                        },
                        activeColor: const Color(0xFF007BFF),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Edit Profile Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // Edit profile logic
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Editar perfil - Em breve!')),
                      );
                    },
                    icon: Icon(PhosphorIcons.pencil()),
                    label: const Text('Editar Perfil'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white.withOpacity(0.2),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),

                const SizedBox(height: 40),

                // About Section
                Text(
                  'Sobre o AppQuanta',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: Colors.white,
                      ),
                ),
                const SizedBox(height: 16),

                GestureDetector(
                  onTap: () {
                    setState(() {
                      _isAboutExpanded = !_isAboutExpanded;
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.2),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'O que é o AppQuanta?',
                              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                            Icon(
                              _isAboutExpanded
                                  ? PhosphorIcons.caretUp()
                                  : PhosphorIcons.caretDown(),
                              color: Colors.white,
                            ),
                          ],
                        ),
                        if (_isAboutExpanded) ...[
                          const SizedBox(height: 16),
                          Text(
                            'AppQuanta é uma plataforma inovadora que permite criar, personalizar e visualizar aplicativos de forma intuitiva e elegante. Com foco na experiência do usuário, oferecemos ferramentas poderosas para transformar suas ideias em realidade digital.',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: Colors.white.withOpacity(0.8),
                                ),
                            textAlign: TextAlign.justify,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Características principais:\n'
                            '• Interface moderna e fluida\n'
                            '• Personalização avançada\n'
                            '• Pré-visualização em tempo real\n'
                            '• Suporte multiplataforma',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: Colors.white.withOpacity(0.8),
                                ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 40),

                // Version Info
                Center(
                  child: Text(
                    'Versão 1.0.0',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.white.withOpacity(0.6),
                        ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
