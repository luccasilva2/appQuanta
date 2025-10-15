# AppQuanta

AppQuanta é um aplicativo Flutter inovador para criação e gerenciamento de aplicativos móveis. Com uma interface intuitiva e moderna, permite aos usuários criar, visualizar e gerenciar seus projetos de forma eficiente.

## 📥 Download APK

[![Download APK](https://img.shields.io/badge/Download-APK-blue?style=for-the-badge&logo=android)](build/app/outputs/flutter-apk/app-release.apk)

**Clique no botão acima para baixar o APK diretamente no seu dispositivo Android.**

## 🚀 Funcionalidades

- **Tela de Login e Registro**: Autenticação segura com animações suaves
- **Navegação por Abas**: Interface com bottom navigation bar
- **Criação de Apps**: Ferramentas para criar novos projetos
- **Gerenciamento de Apps**: Visualize e gerencie seus aplicativos criados
- **Perfil do Usuário**: Configurações pessoais e informações do usuário
- **Design Responsivo**: Interface adaptável a diferentes tamanhos de tela
- **Tema Dinâmico**: Suporte a temas claro e escuro

## 🛠️ Tecnologias Utilizadas

- **Flutter**: Framework principal para desenvolvimento cross-platform
- **Dart**: Linguagem de programação
- **Phosphor Icons**: Biblioteca de ícones moderna e consistente
- **Page Transition**: Animações suaves entre telas
- **Material Design**: Design system do Google

## 📱 Como Executar

### Pré-requisitos

- Flutter SDK (versão 3.0 ou superior)
- Dart SDK
- Android Studio ou VS Code com extensões Flutter
- Dispositivo Android ou emulador

### Instalação

1. Clone o repositório:
```bash
git clone https://github.com/seu-usuario/appquanta.git
cd appquanta
```

2. Instale as dependências:
```bash
flutter pub get
```

3. Execute o aplicativo:
```bash
flutter run
```

### Build para Produção

Para gerar o APK de produção:

```bash
flutter build apk --release
```

O APK será gerado em `build/app/outputs/flutter-apk/app-release.apk`

## 📂 Estrutura do Projeto

```
lib/
├── main.dart                 # Ponto de entrada da aplicação
├── theme/
│   └── app_theme.dart        # Definições de tema
├── widgets/
│   └── bottom_nav_bar.dart   # Barra de navegação inferior
└── screens/
    ├── login_screen.dart     # Tela de login
    ├── register_screen.dart  # Tela de registro
    ├── home_screen.dart      # Tela inicial
    ├── create_app_screen.dart # Tela de criação de app
    ├── my_apps_screen.dart   # Tela de meus apps
    └── profile_screen.dart   # Tela de perfil
```

## 🎨 Design

O aplicativo utiliza um design moderno com:
- Gradientes azul metálico
- Animações de fade e scale
- Ícones do Phosphor
- Tipografia consistente
- Sombras e efeitos visuais

## 📄 Licença

Este projeto está sob a licença MIT. Veja o arquivo [LICENSE](LICENSE) para mais detalhes.

## 🤝 Contribuição

Contribuições são bem-vindas! Sinta-se à vontade para abrir issues e pull requests.

## 📞 Contato

Para dúvidas ou sugestões, entre em contato através das issues do GitHub.

---

**Desenvolvido com ❤️ usando Flutter**
