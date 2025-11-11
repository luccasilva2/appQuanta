import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../services/api_service.dart';

class AppPreviewScreen extends StatefulWidget {
  final Map<String, dynamic> appData;

  const AppPreviewScreen({super.key, required this.appData});

  @override
  State<AppPreviewScreen> createState() => _AppPreviewScreenState();
}

class _AppPreviewScreenState extends State<AppPreviewScreen> {
  final ApiService _apiService = ApiService();
  bool _isLoading = true;
  String? _previewUrl;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadPreview();
  }

  Future<void> _loadPreview() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      final appId = widget.appData['id']?.toString();
      if (appId == null) {
        throw Exception('App ID não encontrado');
      }

      _previewUrl = await _apiService.getPreviewUrl(appId);

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _error = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.appData['name'] ?? 'App'} - Preview'),
        actions: [
          IconButton(
            icon: Icon(PhosphorIcons.share()),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Compartilhar - Em breve!')),
              );
            },
          ),
          IconButton(
            icon: Icon(PhosphorIcons.download()),
            onPressed: () async {
              try {
                final appId = widget.appData['id']?.toString();
                if (appId != null) {
                  await _apiService.generateApk(appId);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('APK sendo gerado...')),
                  );
                }
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Erro ao gerar APK: $e')),
                );
              }
            },
          ),
        ],
      ),
      body: _buildBody(),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          border: Border(
            top: BorderSide(
              color: Theme.of(context).colorScheme.outline.withOpacity(0.1),
            ),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(PhosphorIcons.arrowLeft()),
                label: const Text('Voltar'),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Editar app - Em breve!')),
                  );
                },
                icon: Icon(PhosphorIcons.pencil()),
                label: const Text('Editar'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return Container(
        color: Colors.white,
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Carregando preview...'),
            ],
          ),
        ),
      );
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(PhosphorIcons.warning(), size: 64, color: Colors.orange),
            const SizedBox(height: 16),
            Text(
              'Erro ao carregar preview',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              _error!,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadPreview,
              child: const Text('Tentar novamente'),
            ),
          ],
        ),
      );
    }

    if (_previewUrl != null) {
      // For now, show a placeholder since we don't have webview
      return _buildPreviewPlaceholder();
    }

    return const Center(child: Text('Preview não disponível'));
  }

  Widget _buildPreviewPlaceholder() {
    final appName = widget.appData['name'] ?? 'Meu App';
    final color = widget.appData['color'] ?? '#4E9FFF';
    final screens = widget.appData['screens'] as List<dynamic>? ?? ['Home'];

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(int.parse(color.replaceAll('#', '0xFF'))),
            Color(int.parse(color.replaceAll('#', '0xFF'))).withOpacity(0.8),
          ],
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Icon(
                        PhosphorIcons.appWindow(),
                        color: Colors.white,
                        size: 40,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      appName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Preview gerado pelo AppQuanta',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w300,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Screens list
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Telas do App:',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ...screens.map(
                      (screen) => Container(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        decoration: const BoxDecoration(
                          border: Border(
                            bottom: BorderSide(color: Colors.white24, width: 1),
                          ),
                        ),
                        child: Text(
                          screen.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Preview note
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'Nota: Esta é uma prévia básica do seu app.\nA versão completa estará disponível em breve!',
                  style: TextStyle(color: Colors.white, fontSize: 14),
                  textAlign: TextAlign.center,
                ),
              ),

              const Spacer(),

              // Navigation bar simulation
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: screens.take(4).map((screen) {
                    final isActive = screen == screens.first;
                    return Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: isActive
                            ? Colors.white.withOpacity(0.2)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        screen.toString(),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: isActive
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
