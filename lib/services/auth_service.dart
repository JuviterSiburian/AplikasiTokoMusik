import 'package:flutter/material.dart';

// Model User
class User {
  final String id;
  final String email;
  final String name;
  final String password;

  User({
    required this.id,
    required this.email,
    required this.name,
    required this.password,
  });
}

class AuthService {
  // Menyimpan daftar user dalam aplikasi
  static final List<User> _users = [];

  // Menyimpan user yang sedang login
  static User? _currentUser;

  // Getter untuk mendapatkan current user
  static User? get currentUser => _currentUser;

  // Method untuk registrasi user baru
  static Future<bool> register(String email, String password, String name) async {
    // Simulasi delay network
    await Future.delayed(Duration(seconds: 1));

    // Validasi input
    if (email.isEmpty || password.isEmpty || name.isEmpty) {
      return false;
    }

    // Cek apakah email sudah terdaftar
    if (_users.any((user) => user.email == email)) {
      return false;
    }

    // Buat user baru
    final newUser = User(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      email: email,
      password: password,
    );

    // Tambahkan ke daftar users
    _users.add(newUser);

    // Set current user
    _currentUser = newUser;
    return true;
  }

  // Method untuk login
  static Future<bool> login(String email, String password) async {
    // Simulasi delay network
    await Future.delayed(Duration(seconds: 1));

    // Validasi input
    if (email.isEmpty || password.isEmpty) {
      return false;
    }

    try {
      // Cari user dengan email dan password yang sesuai
      final user = _users.firstWhere(
            (user) => user.email == email && user.password == password,
      );

      // Set current user jika ditemukan
      _currentUser = user;
      return true;
    } catch (e) {
      // Jika user tidak ditemukan dalam list
      // Untuk demo/testing, buat user baru jika list kosong
      if (_users.isEmpty) {
        _currentUser = User(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          email: email,
          name: email.split('@')[0], // Mengambil nama dari email
          password: password,
        );
        _users.add(_currentUser!);
        return true;
      }
      return false;
    }
  }

  // Method untuk logout
  static void logout() {
    _currentUser = null;
  }

  // Method untuk mengecek status login
  static bool isLoggedIn() {
    return _currentUser != null;
  }
}