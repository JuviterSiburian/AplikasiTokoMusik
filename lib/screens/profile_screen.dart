import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with SingleTickerProviderStateMixin {
  // Definisi warna berdasarkan Pepper dan Gum
  static const Color pepperColor = Color(0xFF38261C); // Coklat gelap
  static const Color gumColor = Color(0xFF8F8C78);    // Abu-abu kecoklatan

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _avatarRotateAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1500),
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Interval(0.0, 0.6, curve: Curves.easeIn),
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.3,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Interval(0.0, 0.6, curve: Curves.elasticOut),
    ));

    _avatarRotateAnimation = Tween<double>(
      begin: 0,
      end: 2 * 3.14159,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Interval(0.0, 0.5, curve: Curves.easeInOutBack),
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleLogout(BuildContext context) {
    AuthService.logout();
    Navigator.pushReplacementNamed(context, '/login');
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Konfirmasi Keluar'),
          content: Text('Apakah Anda yakin ingin keluar?'),
          backgroundColor: Color(0xFFF5F5F0), // Warna latar yang lebih terang
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Batal', style: TextStyle(color: gumColor)),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _handleLogout(context);
              },
              child: Text('Keluar'),
              style: TextButton.styleFrom(
                foregroundColor: Colors.red,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildAnimatedListTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    required double delay,
  }) {
    return FadeTransition(
      opacity: CurvedAnimation(
        parent: _animationController,
        curve: Interval(delay, delay + 0.2, curve: Curves.easeIn),
      ),
      child: SlideTransition(
        position: Tween<Offset>(
          begin: Offset(0.3, 0),
          end: Offset.zero,
        ).animate(CurvedAnimation(
          parent: _animationController,
          curve: Interval(delay, delay + 0.2, curve: Curves.easeOut),
        )),
        child: ListTile(
          leading: Icon(icon, color: gumColor),
          title: Text(title, style: TextStyle(color: pepperColor)),
          trailing: Icon(Icons.chevron_right, color: gumColor),
          onTap: onTap,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = AuthService.currentUser;

    if (user == null) {
      return Scaffold(
        body: Center(
          child: Text('User tidak ditemukan'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: FadeTransition(
          opacity: _fadeAnimation,
          child: Text('Profil', style: TextStyle(color: Colors.white)),
        ),
        backgroundColor: pepperColor,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [pepperColor, gumColor],
            stops: const [0.0, 0.8],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(24.0),
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ScaleTransition(
                    scale: _scaleAnimation,
                    child: Hero(
                      tag: 'profile-avatar',
                      child: CircleAvatar(
                        radius: 60,
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.person,
                          size: 60,
                          color: gumColor,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),

                  SlideTransition(
                    position: Tween<Offset>(
                      begin: Offset(0, 0.5),
                      end: Offset.zero,
                    ).animate(CurvedAnimation(
                      parent: _animationController,
                      curve: Interval(0.3, 0.7, curve: Curves.easeOut),
                    )),
                    child: FadeTransition(
                      opacity: CurvedAnimation(
                        parent: _animationController,
                        curve: Interval(0.3, 0.7),
                      ),
                      child: Text(
                        user.name,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),

                  SlideTransition(
                    position: Tween<Offset>(
                      begin: Offset(0, 0.5),
                      end: Offset.zero,
                    ).animate(CurvedAnimation(
                      parent: _animationController,
                      curve: Interval(0.4, 0.8, curve: Curves.easeOut),
                    )),
                    child: FadeTransition(
                      opacity: CurvedAnimation(
                        parent: _animationController,
                        curve: Interval(0.4, 0.8),
                      ),
                      child: Text(
                        user.email,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white70,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 30),

                  ScaleTransition(
                    scale: CurvedAnimation(
                      parent: _animationController,
                      curve: Interval(0.5, 1.0, curve: Curves.easeOutBack),
                    ),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      color: Colors.white,
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: Column(
                          children: [
                            _buildAnimatedListTile(
                              icon: Icons.edit,
                              title: 'Edit Profil',
                              onTap: () {
                                Navigator.pushNamed(context, '/edit-profile');
                              },
                              delay: 0.6,
                            ),
                            Divider(color: gumColor.withOpacity(0.2)),
                            _buildAnimatedListTile(
                              icon: Icons.lock,
                              title: 'Ubah Kata Sandi',
                              onTap: () {
                                Navigator.pushNamed(context, '/change-password');
                              },
                              delay: 0.7,
                            ),
                            Divider(color: gumColor.withOpacity(0.2)),
                            _buildAnimatedListTile(
                              icon: Icons.exit_to_app,
                              title: 'Keluar',
                              onTap: () => _showLogoutDialog(context),
                              delay: 0.8,
                            ),
                          ],
                        ),
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