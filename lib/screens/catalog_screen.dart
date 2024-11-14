import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../main.dart';

class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imageAsset;
  final String category;
  final Map<String, String> specifications;
  final List<String> additionalImages;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageAsset,
    required this.category,
    required this.specifications,
    required this.additionalImages,
  });
}

class CatalogScreen extends StatefulWidget {
  const CatalogScreen({Key? key}) : super(key: key);

  @override
  _CatalogScreenState createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> with SingleTickerProviderStateMixin {
  String _selectedCategory = 'All';
  final _searchController = TextEditingController();

  // Tambahkan controller animasi
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  // Demo products data
  final List<Product> _products = [
    Product(
      id: '1',
      name: 'Yamaha F310 Acoustic Guitar',
      description: 'Perfect for beginners, the Yamaha F310 delivers exceptional sound quality and playability at an affordable price. Features a spruce top and meranti back and sides.',
      price: 1999999.99,
      imageAsset: 'assets/images/yamaha_f310.jpeg',
      category: 'Acoustic',
      specifications: {
        'Body': 'Spruce top, Meranti back & sides',
        'Neck': 'Nato',
        'Fingerboard': 'Rosewood',
        'Bridge': 'Rosewood',
        'Scale Length': '634mm',
        'Finish': 'Natural Gloss',
      },
      additionalImages: [
        'assets/images/yamaha_f310_detail1.jpeg',
        'assets/images/yamaha_f310_detail2.jpeg',
        'assets/images/yamaha_f310_detail3.jpeg',
      ],
    ),
    Product(
      id: '2',
      name: 'Fender Stratocaster Electric',
      description: 'The iconic Fender Stratocaster that defined the sound of rock and roll. Features a maple neck, alder body, and three single-coil pickups.',
      price: 12499999.99,
      imageAsset: 'assets/images/fender_strat.jpeg',
      category: 'Electric',
      specifications: {
        'Body': 'Alder',
        'Neck': 'Maple',
        'Fingerboard': 'Rosewood',
        'Pickups': '3 Single-coil',
        'Bridge': 'Tremolo',
        'Finish': 'Sunburst',
      },
      additionalImages: [
        'assets/images/fender_strat_detail1.jpeg',
        'assets/images/fender_strat_detail2.jpeg',
        'assets/images/fender_strat_detail3.jpeg',
      ],
    ),
    Product(
      id: '3',
      name: 'Yamaha F310 Acoustic Guitar',
      description: 'Perfect for beginners, the Yamaha F310 delivers exceptional sound quality and playability at an affordable price. Features a spruce top and meranti back and sides.',
      price: 1999999.99,
      imageAsset: 'assets/images/yamaha_f310.jpeg',
      category: 'Acoustic',
      specifications: {
        'Body': 'Spruce top, Meranti back & sides',
        'Neck': 'Nato',
        'Fingerboard': 'Rosewood',
        'Bridge': 'Rosewood',
        'Scale Length': '634mm',
        'Finish': 'Natural Gloss',
      },
      additionalImages: [
        'assets/images/yamaha_f310_detail1.jpeg',
        'assets/images/yamaha_f310_detail2.jpeg',
        'assets/images/yamaha_f310_detail3.jpeg',
      ],
    ),
    Product(
      id: '4',
      name: 'Yamaha F310 Acoustic Guitar',
      description: 'Perfect for beginners, the Yamaha F310 delivers exceptional sound quality and playability at an affordable price. Features a spruce top and meranti back and sides.',
      price: 1999999.99,
      imageAsset: 'assets/images/yamaha_f310.jpeg',
      category: 'Acoustic',
      specifications: {
        'Body': 'Spruce top, Meranti back & sides',
        'Neck': 'Nato',
        'Fingerboard': 'Rosewood',
        'Bridge': 'Rosewood',
        'Scale Length': '634mm',
        'Finish': 'Natural Gloss',
      },
      additionalImages: [
        'assets/images/yamaha_f310_detail1.jpeg',
        'assets/images/yamaha_f310_detail2.jpeg',
        'assets/images/yamaha_f310_detail3.jpeg',
      ],
    ),
  ];

  @override
  void initState() {
    super.initState();
    // Inisialisasi controller animasi
    _animationController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );

    // Buat animasi fade
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    // Buat animasi slide
    _slideAnimation = Tween<Offset>(
      begin: Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));

    // Mulai animasi
    _animationController.forward();
  }

  List<String> get categories {
    final cats = _products.map((p) => p.category).toSet().toList();
    cats.insert(0, 'All');
    return cats;
  }

  List<Product> get filteredProducts {
    return _products.where((product) {
      final matchesCategory = _selectedCategory == 'All' ||
          product.category == _selectedCategory;
      final matchesSearch = product.name.toLowerCase()
          .contains(_searchController.text.toLowerCase()) ||
          product.description.toLowerCase()
              .contains(_searchController.text.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();
  }

  void _showProductDetails(BuildContext context, Product product) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.9,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        builder: (context, scrollController) => AnimatedContainer(
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: SingleChildScrollView(
            controller: scrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image carousel dengan animasi PageView
                SizedBox(
                  height: 300,
                  child: PageView(
                    children: [
                      Hero(
                        tag: 'product-${product.id}',
                        child: Image.asset(product.imageAsset, fit: BoxFit.cover),
                      ),
                      ...product.additionalImages.map(
                            (img) => TweenAnimationBuilder(
                          duration: Duration(milliseconds: 500),
                          tween: Tween<double>(begin: 0.8, end: 1.0),
                          builder: (context, double value, child) {
                            return Transform.scale(
                              scale: value,
                              child: Image.asset(img, fit: BoxFit.cover),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                // Detail produk dengan animasi fade
                TweenAnimationBuilder(
                  duration: Duration(milliseconds: 500),
                  tween: Tween<double>(begin: 0.0, end: 1.0),
                  builder: (context, double value, child) {
                    return Opacity(
                      opacity: value,
                      child: child,
                    );
                  },
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                product.name,
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Text(
                              'Rp ${product.price.toStringAsFixed(2)}',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: CustomColors.pepper,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Text(
                          product.category,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Description',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          product.description,
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Specifications',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        ...product.specifications.entries.map(
                              (spec) => TweenAnimationBuilder(
                            duration: Duration(milliseconds: 300),
                            tween: Tween<Offset>(
                              begin: Offset(1, 0),
                              end: Offset.zero,
                            ),
                            builder: (context, Offset offset, child) {
                              return Transform.translate(
                                offset: offset * 20,
                                child: child,
                              );
                            },
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 4),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: Text(
                                      '${spec.key}:',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Expanded(
                                    flex: 3,
                                    child: Text(
                                      spec.value,
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 24),
                        // Tombol dengan animasi scale
                        TweenAnimationBuilder(
                          duration: Duration(milliseconds: 300),
                          tween: Tween<double>(begin: 0.8, end: 1.0),
                          builder: (context, double value, child) {
                            return Transform.scale(
                              scale: value,
                              child: child,
                            );
                          },
                          child: SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: () {
                                final cartProvider = Provider.of<CartProvider>(
                                  context,
                                  listen: false,
                                );
                                cartProvider.addItem(
                                  CartItem(
                                    id: product.id,
                                    name: product.name,
                                    price: product.price,
                                    imageUrl: product.imageAsset,
                                  ),
                                );
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('${product.name} added to cart'),
                                    action: SnackBarAction(
                                      label: 'VIEW CART',
                                      onPressed: () {
                                        // Navigate to cart
                                      },
                                    ),
                                  ),
                                );
                              },
                              icon: Icon(Icons.shopping_cart),
                              label: Text('Add to Cart'),
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
        children: [
        // Header dengan animasi fade
        FadeTransition(
        opacity: _fadeAnimation,
        child: Container(
        padding: EdgeInsets.all(16),
    decoration: BoxDecoration(
    color: Colors.white,
    boxShadow: [
    BoxShadow(
    color: Colors.black.withOpacity(0.05),
    blurRadius: 10,
    offset: Offset(0, 5),
    ),
    ],
    ),
    child: SafeArea(
    child: Column(
    children: [
    TextField(
    controller: _searchController,
    decoration: InputDecoration(
    hintText: 'Search guitars...',
    prefixIcon: Icon(Icons.search),
    suffixIcon: _searchController.text.isNotEmpty
    ? IconButton(
    icon: Icon(Icons.clear),
    onPressed: () {
    setState(() {
    _searchController.clear();
    });
    },
    )
        : null,
    border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: BorderSide(color: CustomColors.gum),
    ),
    focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: BorderSide(color: CustomColors.pepper, width: 2),
    ),
    filled: true,
    fillColor: Colors.grey[50],
    ),
    onChanged: (value) {
    setState(() {});
    },
    ),
    SizedBox(height: 16),
    SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: Row(
    children: categories.map((category) {
    final isSelected = category == _selectedCategory;
    return Padding(
    padding: EdgeInsets.only(right: 8),
    child: FilterChip(
    label: Text(category),
    selected: isSelected,
    onSelected: (selected) {
    setState(() {
    _selectedCategory = category;
    });
    },
    backgroundColor: Colors.grey[50],
    selectedColor: CustomColors.pepper,
    labelStyle: TextStyle(
    color: isSelected ? Colors.white : CustomColors.pepper,
    fontWeight: FontWeight.w500,
    ),
    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(20),
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
    ),
    // Grid produk dengan animasi slide dan fade
    Expanded(
    child: SlideTransition(
    position: _slideAnimation,
    child: FadeTransition(
    opacity: _fadeAnimation,
    child: GridView.builder(
    padding: EdgeInsets.all(16),
    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 2,
      childAspectRatio: 0.7,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
    ),
      itemCount: filteredProducts.length,
      itemBuilder: (context, index) {
        final product = filteredProducts[index];
        // Tambahkan animasi untuk setiap item dengan delay berdasarkan index
        return AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            final delay = index * 0.2;
            final slideAnimation = Tween<Offset>(
              begin: Offset(0, 0.5),
              end: Offset.zero,
            ).animate(CurvedAnimation(
              parent: _animationController,
              curve: Interval(
                delay.clamp(0.0, 1.0),
                (delay + 0.4).clamp(0.0, 1.0),
                curve: Curves.easeOutCubic,
              ),
            ));

            return SlideTransition(
              position: slideAnimation,
              child: FadeTransition(
                opacity: CurvedAnimation(
                  parent: _animationController,
                  curve: Interval(
                    delay.clamp(0.0, 1.0),
                    (delay + 0.4).clamp(0.0, 1.0),
                    curve: Curves.easeIn,
                  ),
                ),
                child: child,
              ),
            );
          },
          child: GestureDetector(
            onTap: () => _showProductDetails(context, product),
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 3,
                    child: Hero(
                      tag: 'product-${product.id}',
                      child: ClipRRect(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(12),
                        ),
                        child: Image.asset(
                          product.imageAsset,
                          fit: BoxFit.cover,
                          width: double.infinity,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: EdgeInsets.all(8),
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product.name,
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 2),
                              Text(
                                product.category,
                                style: TextStyle(
                                  fontSize: 11,
                                  color: CustomColors.pepper,
                                ),
                              ),
                              Spacer(),
                              Text(
                                'Rp ${product.price.toStringAsFixed(2)}',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: CustomColors.pepper,
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    ),
    ),
    ),
    ),
        ],
        ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _animationController.dispose(); // Jangan lupa dispose animationController
    super.dispose();
  }
}