import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> with SingleTickerProviderStateMixin {
  bool _notificationsEnabled = true;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 800),
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pengaturan'),
        backgroundColor: Color(0xFF6C63FF),
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF6C63FF), Color(0xFF3F3D56)],
            stops: [0.0, 0.8],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(24.0),
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AnimatedBuilder(
                      animation: _animationController,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: Curves.easeOutBack.transform(_animationController.value),
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(20),
                              child: Column(
                                children: [
                                  _buildAnimatedListTile(
                                    icon: Icons.language,
                                    title: 'Bahasa',
                                    trailing: Text('Bahasa Indonesia'),
                                    onTap: () {
                                      print('Pengaturan bahasa diklik');
                                    },
                                    delay: 0.2,
                                  ),
                                  _buildAnimatedSwitchListTile(
                                    delay: 0.4,
                                  ),
                                  _buildAnimatedListTile(
                                    icon: Icons.info,
                                    title: 'Tentang Aplikasi',
                                    trailing: Icon(Icons.chevron_right),
                                    onTap: () {
                                      print('Tentang Aplikasi diklik');
                                    },
                                    delay: 0.6,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 20),
                    SlideTransition(
                      position: Tween<Offset>(
                        begin: Offset(0, 1),
                        end: Offset.zero,
                      ).animate(CurvedAnimation(
                        parent: _animationController,
                        curve: Interval(0.6, 1, curve: Curves.easeOutCubic),
                      )),
                      child: FadeTransition(
                        opacity: Tween<double>(begin: 0, end: 1).animate(
                          CurvedAnimation(
                            parent: _animationController,
                            curve: Interval(0.6, 1),
                          ),
                        ),
                        child: SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pushReplacementNamed(context, '/login');
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding: EdgeInsets.symmetric(vertical: 15),
                            ),
                            child: Text(
                              'Keluar',
                              style: TextStyle(fontSize: 16),
                            ),
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
      ),
    );
  }

  Widget _buildAnimatedListTile({
    required IconData icon,
    required String title,
    required Widget trailing,
    required VoidCallback onTap,
    required double delay,
  }) {
    return FadeTransition(
      opacity: Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(
          parent: _animationController,
          curve: Interval(delay, delay + 0.2, curve: Curves.easeIn),
        ),
      ),
      child: SlideTransition(
        position: Tween<Offset>(
          begin: Offset(0.5, 0),
          end: Offset.zero,
        ).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Interval(delay, delay + 0.2, curve: Curves.easeOut),
          ),
        ),
        child: ListTile(
          leading: Icon(icon, color: Color(0xFF6C63FF)),
          title: Text(title),
          trailing: trailing,
          onTap: onTap,
        ),
      ),
    );
  }

  Widget _buildAnimatedSwitchListTile({required double delay}) {
    return FadeTransition(
      opacity: Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(
          parent: _animationController,
          curve: Interval(delay, delay + 0.2, curve: Curves.easeIn),
        ),
      ),
      child: SlideTransition(
        position: Tween<Offset>(
          begin: Offset(0.5, 0),
          end: Offset.zero,
        ).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Interval(delay, delay + 0.2, curve: Curves.easeOut),
          ),
        ),
        child: SwitchListTile(
          secondary: Icon(Icons.notifications, color: Color(0xFF6C63FF)),
          title: Text('Notifikasi'),
          value: _notificationsEnabled,
          onChanged: (bool value) {
            setState(() {
              _notificationsEnabled = value;
              print('Notifikasi diubah: $_notificationsEnabled');
            });
          },
        ),
      ),
    );
  }
}