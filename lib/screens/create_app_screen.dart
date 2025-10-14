import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class CreateAppScreen extends StatefulWidget {
  const CreateAppScreen({super.key});

  @override
  State<CreateAppScreen> createState() => _CreateAppScreenState();
}

class _CreateAppScreenState extends State<CreateAppScreen> {
  int _currentStep = 0;
  final int _totalSteps = 4;

  final TextEditingController _appNameController = TextEditingController();
  String _selectedIcon = 'app';
  Color _selectedColor = const Color(0xFF007BFF);
  List<String> _selectedScreens = ['Home', 'About'];

  final List<Map<String, dynamic>> _icons = [
    {'name': 'app', 'icon': PhosphorIcons.appWindow()},
    {'name': 'game', 'icon': PhosphorIcons.gameController()},
    {'name': 'shopping', 'icon': PhosphorIcons.shoppingBag()},
    {'name': 'chat', 'icon': PhosphorIcons.chat()},
  ];

  final List<Color> _colors = [
    const Color(0xFF007BFF), // Blue
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
  void dispose() {
    _appNameController.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_currentStep < _totalSteps - 1) {
      setState(() {
        _currentStep++;
      });
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
    }
  }

  Widget _buildStepContent() {
    switch (_currentStep) {
      case 0:
        return _buildNameAndIconStep();
      case 1:
        return _buildThemeAndColorsStep();
      case 2:
        return _buildScreensStep();
      case 3:
        return _buildFinalizationStep();
      default:
        return Container();
    }
  }

  Widget _buildNameAndIconStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Nome e Ícone do App',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: 24),
        TextField(
          controller: _appNameController,
          decoration: InputDecoration(
            labelText: 'Nome do App',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            filled: true,
            fillColor: Theme.of(context).cardColor,
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'Selecione um ícone:',
          style: Theme.of(context).textTheme.bodyLarge,
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
                      ? Theme.of(context).colorScheme.primary.withOpacity(0.2)
                      : Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: _selectedIcon == iconData['name']
                        ? Theme.of(context).colorScheme.primary
                        : Colors.transparent,
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
      ],
    );
  }

  Widget _buildThemeAndColorsStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Tema e Cores',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: 24),
        Text(
          'Selecione uma cor principal:',
          style: Theme.of(context).textTheme.bodyLarge,
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
                          )
                        ]
                      : null,
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 24),
        Container(
          height: 100,
          decoration: BoxDecoration(
            color: _selectedColor,
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Center(
            child: Text(
              'Pré-visualização',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildScreensStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Telas e Estrutura',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: 24),
        Text(
          'Selecione os modelos de tela:',
          style: Theme.of(context).textTheme.bodyLarge,
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
              backgroundColor: Theme.of(context).cardColor,
              selectedColor: Theme.of(context).colorScheme.primary.withOpacity(0.2),
              checkmarkColor: Theme.of(context).colorScheme.primary,
            );
          }).toList(),
        ),
        const SizedBox(height: 24),
        Text(
          'Pré-visualização das telas selecionadas:',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _selectedScreens.length,
            itemBuilder: (context, index) {
              return Container(
                width: 150,
                margin: const EdgeInsets.only(right: 16),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    _selectedScreens[index],
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildFinalizationStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Finalização',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: _selectedColor,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(
                      _icons.firstWhere((icon) => icon['name'] == _selectedIcon)['icon'],
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _appNameController.text.isEmpty ? 'Nome do App' : _appNameController.text,
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        Text(
                          '${_selectedScreens.length} telas selecionadas',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () {
                  // Save prototype logic here
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Protótipo salvo com sucesso!')),
                  );
                  Navigator.pop(context);
                },
                icon: Icon(PhosphorIcons.floppyDisk()),
                label: const Text('Salvar Protótipo'),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                ),
              ),
            ],
          ),
        ),
      ],
    );
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
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                // Stepper indicator
                Row(
                  children: List.generate(_totalSteps, (index) {
                    return Expanded(
                      child: Container(
                        height: 4,
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        decoration: BoxDecoration(
                          color: index <= _currentStep
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(context).colorScheme.surfaceVariant,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 24),
                // Step content
                Expanded(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    transitionBuilder: (child, animation) {
                      return FadeTransition(
                        opacity: animation,
                        child: SlideTransition(
                          position: Tween<Offset>(
                            begin: const Offset(0.1, 0),
                            end: Offset.zero,
                          ).animate(animation),
                          child: child,
                        ),
                      );
                    },
                    child: SingleChildScrollView(
                      key: ValueKey<int>(_currentStep),
                      child: _buildStepContent(),
                    ),
                  ),
                ),
                // Navigation buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (_currentStep > 0)
                      ElevatedButton(
                        onPressed: _previousStep,
                        child: const Text('Anterior'),
                      )
                    else
                      const SizedBox.shrink(),
                    ElevatedButton(
                      onPressed: _currentStep < _totalSteps - 1 ? _nextStep : null,
                      child: Text(_currentStep < _totalSteps - 1 ? 'Próximo' : 'Finalizar'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
