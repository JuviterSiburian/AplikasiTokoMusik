import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.2, 1.0, curve: Curves.easeOutCubic),
    ));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleLogout(BuildContext context) async {
    await _controller.reverse();
    AuthService.logout();
    Navigator.pushReplacementNamed(context, '/login');
  }

  void _navigateToPage(BuildContext context, String route) {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0.0, 0.3),
              end: Offset.zero,
            ).animate(CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutCubic,
            )),
            child: _buildDestinationPage(route),
          ),
        ),
        transitionDuration: const Duration(milliseconds: 500),
      ),
    );
  }

  // Helper method untuk mengembalikan halaman yang sesuai
  Widget _buildDestinationPage(String route) {
    // Anda perlu mengganti ini dengan implementasi halaman yang sebenarnya
    switch (route) {
      case '/profile':
        return Container(); // Ganti dengan ProfileScreen()
      case '/settings':
        return Container(); // Ganti dengan SettingsScreen()
      case '/notifications':
        return Container(); // Ganti dengan NotificationsScreen()
      case '/help':
        return Container(); // Ganti dengan HelpScreen()
      default:
        return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = AuthService.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Beranda'),
        backgroundColor: const Color(0xFF6C63FF),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _handleLogout(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Selamat Datang!',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Informasi Pengguna Card
                  _buildAnimatedCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Informasi Pengguna',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        ListTile(
                          leading: const Icon(Icons.person, color: Color(0xFF6C63FF)),
                          title: const Text('Nama Pengguna'),
                          subtitle: Text(user?.name ?? 'John Doe'),
                        ),
                        ListTile(
                          leading: const Icon(Icons.email, color: Color(0xFF6C63FF)),
                          title: const Text('Email'),
                          subtitle: Text(user?.email ?? 'john@example.com'),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  const Text(
                    'Menu Utama',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Grid Menu dengan Animasi
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    crossAxisSpacing: 16.0,
                    mainAxisSpacing: 16.0,
                    children: [
                      _buildAnimatedMenuCard(
                        context,
                        'Profil',
                        Icons.person_outline,
                            () => _navigateToPage(context, '/profile'),
                        delay: 0,
                      ),
                      _buildAnimatedMenuCard(
                        context,
                        'Pengaturan',
                        Icons.settings_outlined,
                            () => _navigateToPage(context, '/settings'),
                        delay: 100,
                      ),
                      _buildAnimatedMenuCard(
                        context,
                        'Notifikasi',
                        Icons.notifications_outlined,
                            () => _navigateToPage(context, '/notifications'),
                        delay: 200,
                      ),
                      _buildAnimatedMenuCard(
                        context,
                        'Bantuan',
                        Icons.help_outline,
                            () => _navigateToPage(context, '/help'),
                        delay: 300,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedCard({required Widget child}) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: Curves.easeOutBack.transform(_controller.value),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: child,
            ),
          ),
        );
      },
      child: child,
    );
  }

  Widget _buildAnimatedMenuCard(
      BuildContext context,
      String title,
      IconData icon,
      VoidCallback onTap, {
        required int delay,
      }) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 500 + delay),
      curve: Curves.easeOutBack,
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: InkWell(
                onTap: onTap,
                borderRadius: BorderRadius.circular(15),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFF6C63FF), Color(0xFF5A52CC)],
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        icon,
                        size: 40,
                        color: Colors.white,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}