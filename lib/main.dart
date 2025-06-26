import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'pages/imovel_detalhe_page.dart';
import 'pages/busca_page.dart';
import 'pages/login_page.dart';
import 'pages/precificador_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.dark;
  String? _usuarioLogado; // Simulação de usuário logado

  void _toggleTheme() {
    setState(() {
      _themeMode = _themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    });
  }

  void _login(String nome) {
    setState(() => _usuarioLogado = nome);
  }

  void _logout() {
    setState(() => _usuarioLogado = null);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Precificador IA',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        fontFamily: 'Montserrat',
        scaffoldBackgroundColor: Colors.transparent,
        colorScheme: ColorScheme.light(
          primary: Colors.blue,
          background: Colors.white,
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        fontFamily: 'Montserrat',
        scaffoldBackgroundColor: Colors.transparent,
        colorScheme: ColorScheme.dark(
          primary: Colors.blue,
          background: Colors.black,
        ),
      ),
      themeMode: _themeMode,
      home: HomePage(
        onToggleTheme: _toggleTheme,
        usuarioLogado: _usuarioLogado,
        onLogin: _login,
        onLogout: _logout,
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  final VoidCallback onToggleTheme;
  final String? usuarioLogado;
  final void Function(String nome) onLogin;
  final VoidCallback onLogout;
  const HomePage({super.key, required this.onToggleTheme, required this.usuarioLogado, required this.onLogin, required this.onLogout});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int? _selectedIndex;
  bool _showDesc = false;

  void _onCardTap(int index) {
    setState(() {
      if (_selectedIndex == index && _showDesc) {
        // Abrir página de detalhe
        _abrirDetalhe(index);
      } else {
        _selectedIndex = index;
        _showDesc = !_showDesc;
      }
    });
  }

  void _abrirDetalhe(int index) {
    final imovel = imoveis[index];
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ImovelDetalhePage(tipo: imovel.title, titulo: imovel.title, dicas: imovel.desc),
      ),
    );
  }

  void _abrirBusca() {
    Navigator.push(context, MaterialPageRoute(builder: (_) => const BuscaPage()));
  }

  void _abrirLogin() async {
    final nome = await Navigator.push<String>(context, MaterialPageRoute(builder: (_) => const LoginPage()));
    if (nome != null) widget.onLogin(nome);
  }

  void _abrirPrecificador() {
    if (widget.usuarioLogado == null) {
      _abrirLogin();
    } else {
      Navigator.push(context, MaterialPageRoute(builder: (_) => const PrecificadorPage()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset(
            'assets/bg-image.png',
            fit: BoxFit.cover,
          ),
        ),
        Scaffold(
          backgroundColor: Theme.of(context).brightness == Brightness.dark
              ? Colors.black.withOpacity(0.6)
              : Colors.white.withOpacity(0.7),
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(60),
            child: _CustomAppBar(
              onToggleTheme: widget.onToggleTheme,
              usuarioLogado: widget.usuarioLogado,
              onLogin: _abrirLogin,
              onLogout: widget.onLogout,
              onBusca: _abrirBusca,
            ),
          ),
          body: LayoutBuilder(
            builder: (context, constraints) {
              final isMobile = constraints.maxWidth < 700;
              return Center(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal: isMobile ? 8 : 60,
                    vertical: isMobile ? 8 : 40,
                  ),
                  child: isMobile
                      ? _MobileContent(
                          onCardTap: _onCardTap,
                          selectedIndex: _selectedIndex,
                          showDesc: _showDesc,
                          onPrecificar: _abrirPrecificador,
                        )
                      : _DesktopContent(
                          onCardTap: _onCardTap,
                          selectedIndex: _selectedIndex,
                          showDesc: _showDesc,
                          onPrecificar: _abrirPrecificador,
                        ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _CustomAppBar extends StatelessWidget {
  final VoidCallback onToggleTheme;
  final String? usuarioLogado;
  final VoidCallback onLogin;
  final VoidCallback onLogout;
  final VoidCallback onBusca;
  const _CustomAppBar({required this.onToggleTheme, required this.usuarioLogado, required this.onLogin, required this.onLogout, required this.onBusca});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 700;
    final color = Theme.of(context).colorScheme.onBackground;
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      title: Row(
        children: [
          Icon(Icons.home, color: color),
          const SizedBox(width: 8),
          Text(
            'Precificador IA',
            style: TextStyle(fontWeight: FontWeight.bold, color: color),
          ),
          const Spacer(),
          IconButton(
            icon: Icon(
              Theme.of(context).brightness == Brightness.dark
                  ? Icons.wb_sunny
                  : Icons.nightlight_round,
              color: color,
            ),
            onPressed: onToggleTheme,
            tooltip: 'Alternar tema',
          ),
          IconButton(
            icon: Icon(Icons.search, color: color),
            onPressed: onBusca,
          ),
          if (usuarioLogado != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                children: [
                  CircleAvatar(child: Text(usuarioLogado![0].toUpperCase())),
                  const SizedBox(width: 8),
                  Text(usuarioLogado!, style: TextStyle(color: color)),
                  IconButton(
                    icon: Icon(Icons.logout, color: color),
                    onPressed: onLogout,
                    tooltip: 'Sair',
                  ),
                ],
              ),
            )
          else if (isMobile)
            IconButton(
              icon: Icon(Icons.person, color: color),
              onPressed: onLogin,
              tooltip: 'Login/Cadastro',
            )
          else
            ElevatedButton.icon(
              onPressed: onLogin,
              icon: Icon(Icons.person, color: Theme.of(context).colorScheme.onPrimary),
              label: Text('Login/Cadastro', style: TextStyle(color: Theme.of(context).colorScheme.onPrimary)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Theme.of(context).colorScheme.onPrimary,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                textStyle: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
        ],
      ),
      centerTitle: false,
    );
  }
}

class _DesktopContent extends StatelessWidget {
  final void Function(int) onCardTap;
  final int? selectedIndex;
  final bool showDesc;
  final VoidCallback onPrecificar;

  const _DesktopContent({
    Key? key,
    required this.onCardTap,
    required this.selectedIndex,
    required this.showDesc,
    required this.onPrecificar,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.onBackground;
    final subColor = Theme.of(context).colorScheme.onBackground.withOpacity(0.7);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Texto à esquerda
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Bem-vindo ao\nPrecificador de Imóveis IA',
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: color,
                  height: 1.1,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Utilize nossa inteligência artificial para obter o preço justo do seu imóvel em Jacareí, SP. Analisamos dados de casas, apartamentos e terrenos com precisão e rapidez.',
                style: TextStyle(fontSize: 18, color: subColor),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: onPrecificar,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Theme.of(context).colorScheme.onPrimary,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  'Começar a Precificar',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onPrimary),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 40),
        // Grid de imagens à direita
        Expanded(
          flex: 3,
          child: SizedBox(
            height: 500,
            child: _ImovelGrid(
              onCardTap: onCardTap,
              selectedIndex: selectedIndex,
              showDesc: showDesc,
              imoveis: imoveis,
            ),
          ),
        ),
      ],
    );
  }
}

class _MobileContent extends StatelessWidget {
  final void Function(int) onCardTap;
  final int? selectedIndex;
  final bool showDesc;
  final VoidCallback onPrecificar;

  const _MobileContent({
    Key? key,
    required this.onCardTap,
    required this.selectedIndex,
    required this.showDesc,
    required this.onPrecificar,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.onBackground;
    final subColor = Theme.of(context).colorScheme.onBackground.withOpacity(0.7);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Text(
          'Bem-vindo ao Precificador de Imóveis IA',
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: color,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Utilize nossa inteligência artificial para obter o preço justo do seu imóvel em Jacareí, SP. Analisamos dados de casas, apartamentos e terrenos com precisão e rapidez.',
          style: TextStyle(fontSize: 15, color: subColor),
        ),
        const SizedBox(height: 24),
        Center(
          child: ElevatedButton(
            onPressed: onPrecificar,
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Theme.of(context).colorScheme.onPrimary,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              'Começar a Precificar',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onPrimary),
            ),
          ),
        ),
        const SizedBox(height: 24),
        _ImovelGrid(
          onCardTap: onCardTap,
          selectedIndex: selectedIndex,
          showDesc: showDesc,
          imoveis: imoveis,
        ),
      ],
    );
  }
}

class _ImovelGrid extends StatefulWidget {
  final void Function(int) onCardTap;
  final int? selectedIndex;
  final bool showDesc;
  final List<_ImovelInfo> imoveis;

  const _ImovelGrid({
    Key? key,
    required this.onCardTap,
    required this.selectedIndex,
    required this.showDesc,
    required this.imoveis,
  }) : super(key: key);

  @override
  State<_ImovelGrid> createState() => _ImovelGridState();
}

class _ImovelGridState extends State<_ImovelGrid> {
  static List<_ImovelInfo> get imoveis => [];

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 700;
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: isMobile ? 12 : 20,
        mainAxisSpacing: isMobile ? 12 : 20,
        childAspectRatio: isMobile ? 1 : 1.1,
      ),
      itemCount: widget.imoveis.length,
      itemBuilder: (context, index) {
        final imovel = widget.imoveis[index];
        final isSelected = widget.selectedIndex == index && widget.showDesc;
        return GestureDetector(
          onTap: () => widget.onCardTap(index),
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(18.0),
                child: Image.asset(
                  imovel.image,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                ),
              ),
              AnimatedPositioned(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeInOut,
                left: 0,
                right: 0,
                bottom: isSelected ? 0 : -80,
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 250),
                  opacity: isSelected ? 1 : 0,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.7),
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(18),
                        bottomRight: Radius.circular(18),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          imovel.title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          imovel.desc,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ImovelInfo {
  final String image;
  final String title;
  final String desc;
  const _ImovelInfo({required this.image, required this.title, required this.desc});
}

final List<_ImovelInfo> imoveis = [
  _ImovelInfo(
    image: 'assets/house1.jpeg',
    title: 'Casa',
    desc: 'Casas residenciais com conforto e segurança para sua família.',
  ),
  _ImovelInfo(
    image: 'assets/terrain1.jpeg',
    title: 'Terreno',
    desc: 'Terrenos em localizações privilegiadas para construir ou investir.',
  ),
  _ImovelInfo(
    image: 'assets/apartment1.jpeg',
    title: 'Apartamento',
    desc: 'Apartamentos modernos e práticos, ideais para o dia a dia urbano.',
  ),
  _ImovelInfo(
    image: 'assets/condo1.jpeg',
    title: 'Comercial',
    desc: 'Ótimas oportunidades para seu negócio. Imóveis comerciais em localizações estratégicas com preços calculados pela nossa IA.',
  ),
];

// Uma tela de exemplo para a navegação
class PrecificarImovelPage extends StatelessWidget {
  const PrecificarImovelPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Precificar Imóvel'),
      ),
      body: const Center(
        child: Text(
          'Esta é a tela de precificação do imóvel!',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
    );
  }
}