import 'package:aquiles/widgets/status_tab.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _showSplash = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);

    // Mostrar animación de splash por 2.5 segundos
    Future.delayed(const Duration(milliseconds: 2500), () {
      if (mounted) {
        setState(() {
          _showSplash = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_showSplash) {
      return Scaffold(
        backgroundColor: const Color(0xFF0A1128),
        body: Center(
          child: AnimatedOpacity(
            opacity: 1.0,
            duration: const Duration(milliseconds: 500),
            child: Image.asset(
              'assets/images/logo.png',
              width: 160,
              height: 160,
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFF0A1128),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A1128).withOpacity(0.8),
        elevation: 0,
        toolbarHeight: 50, // Header más pequeño
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
        ),
        title: Row(
          children: [
            Image.asset(
              'assets/images/logo.png',
              width: 28,
              height: 28,
            ),
            const SizedBox(width: 8),
            ShaderMask(
              shaderCallback: (bounds) => const LinearGradient(
                colors: [Color(0xFF8CCBD5), Color(0xFF5E9F9F)],
              ).createShader(bounds),
              child: const Text(
                'AQUILES',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined,
                color: Color(0xFF8CCBD5)),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.person_outline, color: Color(0xFF8CCBD5)),
            onPressed: () {},
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: const Color(0xFF3F797A),
          indicatorWeight: 3,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white.withOpacity(0.7),
          labelStyle:
              const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          tabs: const [
            Tab(text: 'Estado'),
            Tab(text: 'Rendimiento'),
            Tab(text: 'Ajustes'),
            Tab(text: 'Tutoriales'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          StatusTab(),
          Center(child: Text('Rendimiento')),
          Center(child: Text('Ajustes')),
          Center(child: Text('Tutoriales')),
        ],
      ),
    );
  }
}
