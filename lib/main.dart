import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

// Import screens
import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/catalog_screen.dart';
import 'screens/cart_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/calculator_screen.dart' as calc;
import 'screens/statistics_screen.dart' as stats;
import 'screens/bmi_screen.dart';
import 'screens/currency_conversion_screen.dart';
import 'screens/temperature_conversion_screen.dart';

// Custom Colors
class CustomColors {
  static const Color pepper = Color(0xFF38261C);
  static const Color gum = Color(0xFF8F8C78);
  static const Color cream = Color(0xFFF5F5DC);
  static const Color lightGum = Color(0xFFBBB8A1);
}

// User model
class User {
  final String id;
  final String nama;
  final String email;
  final String token;

  const User({
    required this.id,
    required this.nama,
    required this.email,
    required this.token,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? '',
      nama: json['nama'] ?? '',
      email: json['email'] ?? '',
      token: json['token'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama': nama,
      'email': email,
      'token': token,
    };
  }
}

// Cart Item Model
class CartItem {
  final String id;
  final String name;
  final double price;
  final String imageUrl;
  int quantity;

  CartItem({
    required this.id,
    required this.name,
    required this.price,
    required this.imageUrl,
    this.quantity = 1,
  });
}

// Cart Provider
class CartProvider extends ChangeNotifier {
  List<CartItem> _items = [];

  List<CartItem> get items => _items;

  double get total => _items.fold(0, (sum, item) => sum + (item.price * item.quantity));

  int get itemCount => _items.fold(0, (sum, item) => sum + item.quantity);

  void addItem(CartItem item) {
    final existingIndex = _items.indexWhere((i) => i.id == item.id);
    if (existingIndex >= 0) {
      _items[existingIndex].quantity += 1;
    } else {
      _items.add(item);
    }
    notifyListeners();
  }

  void removeItem(String id) {
    _items.removeWhere((item) => item.id == id);
    notifyListeners();
  }

  void updateQuantity(String id, int quantity) {
    final index = _items.indexWhere((item) => item.id == id);
    if (index >= 0) {
      _items[index].quantity = quantity;
      if (quantity <= 0) {
        _items.removeAt(index);
      }
      notifyListeners();
    }
  }

  void clear() {
    _items = [];
    notifyListeners();
  }
}

// User Provider
class UserProvider extends ChangeNotifier {
  User? _user;
  final SharedPreferences prefs;

  UserProvider(this.prefs) {
    _loadUserFromPrefs();
  }

  User? get user => _user;

  Future<void> _loadUserFromPrefs() async {
    final userJson = prefs.getString('user');
    if (userJson != null) {
      try {
        final userData = jsonDecode(userJson);
        _user = User.fromJson(userData);
        notifyListeners();
      } catch (e) {
        print('Error loading user data: $e');
      }
    }
  }

  Future<void> setUser(User user) async {
    _user = user;
    await prefs.setString('user', jsonEncode(user.toJson()));
    notifyListeners();
  }

  Future<void> clearUser() async {
    _user = null;
    await prefs.remove('user');
    notifyListeners();
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserProvider(prefs)),
        ChangeNotifierProvider(create: (context) => CartProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aplikasi Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: CustomColors.pepper,
        scaffoldBackgroundColor: CustomColors.cream,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        appBarTheme: const AppBarTheme(
          backgroundColor: CustomColors.pepper,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.white),
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: CustomColors.pepper,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ),
      home: Consumer<UserProvider>(
        builder: (context, userProvider, child) {
          return userProvider.user == null ? SplashScreen() : MainScreen();
        },
      ),
      routes: {
        '/login': (context) => LoginScreen(),
        '/register': (context) => RegisterScreen(),
        '/dashboard': (context) => MainScreen(),
        '/settings': (context) => SettingsScreen(),
        '/calculator': (context) => calc.CalculatorScreen(),
        '/statistics': (context) => stats.StatisticsScreen(),
        '/bmi': (context) => BmiScreen(),
        '/currency': (context) => CurrencyConverterScreen(),
        '/temperature': (context) => TemperatureConverterScreen(),
      },
    );
  }
}

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    DashboardScreen(),
    CatalogScreen(),
    CartScreen(),
    ProfileScreen(),
  ];

  final List<String> _titles = [
    'Dashboard',
    'Katalog',
    'Keranjang',
    'Profil'
  ];

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final cartProvider = Provider.of<CartProvider>(context);

    return WillPopScope(
      onWillPop: () async {
        if (_currentIndex != 0) {
          setState(() {
            _currentIndex = 0;
          });
          return false;
        }
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(_titles[_currentIndex]),
          actions: [
            if (_currentIndex == 1) // Only show on Catalog screen
              Stack(
                alignment: Alignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.shopping_cart),
                    onPressed: () {
                      setState(() {
                        _currentIndex = 2; // Switch to cart screen
                      });
                    },
                  ),
                  if (cartProvider.itemCount > 0)
                    Positioned(
                      right: 8,
                      top: 8,
                      child: Container(
                        padding: EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        constraints: BoxConstraints(
                          minWidth: 16,
                          minHeight: 16,
                        ),
                        child: Text(
                          '${cartProvider.itemCount}',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              ),
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () => Navigator.pushNamed(context, '/settings'),
            ),
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () async {
                await userProvider.clearUser();
                Navigator.pushReplacementNamed(context, '/login');
              },
            ),
          ],
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              UserAccountsDrawerHeader(
                accountName: Text(userProvider.user?.nama ?? ''),
                accountEmail: Text(userProvider.user?.email ?? ''),
                currentAccountPicture: CircleAvatar(
                  backgroundImage: AssetImage('assets/images/igs_logo.jpeg'),
                  backgroundColor: Colors.transparent,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [CustomColors.pepper, CustomColors.gum],
                  ),
                ),
              ),
              ListTile(
                leading: Icon(Icons.home),
                title: Text('Dashboard'),
                onTap: () {
                  Navigator.pop(context);
                  setState(() {
                    _currentIndex = 0;
                  });
                },
              ),
              ListTile(
                leading: Icon(Icons.shop),
                title: Text('Katalog'),
                onTap: () {
                  Navigator.pop(context);
                  setState(() {
                    _currentIndex = 1;
                  });
                },
              ),
              ListTile(
                leading: Icon(Icons.shopping_cart),
                title: Text('Keranjang'),
                onTap: () {
                  Navigator.pop(context);
                  setState(() {
                    _currentIndex = 2;
                  });
                },
              ),
              ListTile(
                leading: Icon(Icons.person),
                title: Text('Profil'),
                onTap: () {
                  Navigator.pop(context);
                  setState(() {
                    _currentIndex = 3;
                  });
                },
              ),
              Divider(),
              ListTile(
                leading: Icon(Icons.calculate),
                title: Text('Kalkulator'),
                onTap: () {
                  Navigator.pushNamed(context, '/calculator');
                },
              ),
              ListTile(
                leading: Icon(Icons.analytics),
                title: Text('Statistik'),
                onTap: () {
                  Navigator.pushNamed(context, '/statistics');
                },
              ),
              ListTile(
                leading: Icon(Icons.health_and_safety),
                title: Text('BMI'),
                onTap: () {
                  Navigator.pushNamed(context, '/bmi');
                },
              ),
              ListTile(
                leading: Icon(Icons.attach_money),
                title: Text('Konversi Mata Uang'),
                onTap: () {
                  Navigator.pushNamed(context, '/currency');
                },
              ),
              ListTile(
                leading: Icon(Icons.thermostat),
                title: Text('Konversi Suhu'),
                onTap: () {
                  Navigator.pushNamed(context, '/temperature');
                },
              ),
            ],
          ),
        ),
        body: _screens[_currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Dashboard',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shop),
              label: 'Katalog',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart),
              label: 'Keranjang',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profil',
            ),
          ],
          currentIndex: _currentIndex,
          selectedItemColor: CustomColors.pepper,
          unselectedItemColor: Colors.grey,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  @override
  _CalculatorScreenState createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  final TextEditingController _controller1 = TextEditingController();
  final TextEditingController _controller2 = TextEditingController();
  double _result = 0;
  String _selectedOperation = '+';

  void _calculate() {
    final double num1 = double.tryParse(_controller1.text) ?? 0;
    final double num2 = double.tryParse(_controller2.text) ?? 0;

    setState(() {
      switch (_selectedOperation) {
        case '+':
          _result = num1 + num2;
          break;
        case '-':
          _result = num1 - num2;
          break;
        case '*':
          _result = num1 * num2;
          break;
        case '/':
          _result = num2 != 0 ? num1 / num2 : 0;
          break;
        default:
          _result = 0;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Kalkulator')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller1,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Angka pertama'),
            ),
            DropdownButton<String>(
              value: _selectedOperation,
              items: ['+', '-', '*', '/']
                  .map((op) => DropdownMenuItem(
                value: op,
                child: Text(op),
              ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedOperation = value ?? '+';
                });
              },
            ),
            TextField(
              controller: _controller2,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Angka kedua'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _calculate,
              child: Text('Hitung'),
            ),
            SizedBox(height: 16),
            Text(
              'Hasil: $_result',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
