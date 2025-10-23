import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EmailConfirmationScreen extends StatefulWidget {
  const EmailConfirmationScreen({super.key});

  @override
  State<EmailConfirmationScreen> createState() =>
      _EmailConfirmationScreenState();
}

class _EmailConfirmationScreenState extends State<EmailConfirmationScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _checkConfirmation() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return;

    // Buscar o status de confirmação do usuário na tabela 'users'
    final response = await Supabase.instance.client
        .from('users')
        .select('confirmed')
        .eq('id', user.id)
        .single();

    if (response['confirmed'] == true) {
      // Se confirmado, navegar para a tela principal
      Navigator.pushReplacementNamed(context, '/main');
    } else {
      // Ainda não confirmado, mostrar mensagem
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Email ainda não confirmado. Verifique sua caixa de entrada.',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Ícone de email
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Theme.of(
                        context,
                      ).colorScheme.primary.withOpacity(0.1),
                    ),
                    child: Icon(
                      PhosphorIcons.envelope(),
                      color: Theme.of(context).colorScheme.primary,
                      size: 60,
                    ),
                  ),
                  const SizedBox(height: 40),
                  // Título
                  Text(
                    'Confirme seu email',
                    style: Theme.of(context).textTheme.headlineLarge,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  // Subtítulo
                  Text(
                    'Enviamos um link de confirmação para o seu email. Clique no link para ativar sua conta e continuar.',
                    style: Theme.of(context).textTheme.bodyLarge,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 40),
                  // Botão para verificar
                  ElevatedButton.icon(
                    onPressed: _checkConfirmation,
                    icon: Icon(PhosphorIcons.check()),
                    label: const Text('Já confirmei meu email'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        vertical: 16,
                        horizontal: 24,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Botão para reenviar
                  TextButton(
                    onPressed: () async {
                      final user = Supabase.instance.client.auth.currentUser;
                      if (user != null) {
                        await Supabase.instance.client.auth.resend(
                          type: OtpType.signup,
                          email: user.email,
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Email de confirmação reenviado!'),
                          ),
                        );
                      }
                    },
                    child: Text(
                      'Reenviar email de confirmação',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Botão para voltar ao login
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/login');
                    },
                    child: Text(
                      'Voltar ao login',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withOpacity(0.7),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
