import 'dart:io';

import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:coffee_shop_app/config/routes.dart';
import 'package:coffee_shop_app/config/database_helper.dart';

import 'package:coffee_shop_app/widgets/app_drawer.dart';
import 'package:provider/provider.dart';
import 'package:coffee_shop_app/providers/product_provider.dart';
import 'package:coffee_shop_app/models/product_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _carouselIndex = 0;
  int _currentIndex = 0;
  String _selectedCategory = 'All';
  final TextEditingController _searchController = TextEditingController();

  // Sample banner images for carousel
  final List<String> bannerImages = [
    'https://images.unsplash.com/photo-1495474472287-4d71bcdd2085?w=800',
    'https://images.unsplash.com/photo-1511537190424-bbbab87ac5eb?w=800',
    'https://images.unsplash.com/photo-1447933601403-0c6688de566e?w=800',
  ];

  // Bottom navigation items
  final List<BottomNavigationItem> _navItems = [
    BottomNavigationItem(
      title: 'Home',
      icon: Icons.home_outlined,
      activeIcon: Icons.home_rounded,
      route: AppRoutes.home,
      color: Color(0xFF8B4513),
    ),
    BottomNavigationItem(
      title: 'Cart',
      icon: Icons.shopping_cart_outlined,
      activeIcon: Icons.shopping_cart_rounded,
      route: AppRoutes.cart,
      color: Color(0xFF3498DB),
    ),
    BottomNavigationItem(
      title: 'Order',
      icon: Icons.shopping_bag_outlined,
      activeIcon: Icons.shopping_bag_rounded,
      route: AppRoutes.orderTracking,
      color: Color(0xFF27AE60),
    ),
    BottomNavigationItem(
      title: 'Profile',
      icon: Icons.person_outline,
      activeIcon: Icons.person,
      route: AppRoutes.profile,
      color: Color(0xFF9C27B0),
    ),
  ];

  @override
  void initState() {
    super.initState();
    final productProvider = Provider.of<ProductProvider>(
      context,
      listen: false,
    );
    productProvider.fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      drawer: const AppDrawer(),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // Enhanced App Bar with Vee Zee Coffee text
          SliverAppBar(
            // backgroundColor: const Color(0xFF4A90E2),
            expandedHeight: 60,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),

                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF4A90E2), Color(0xFF5D9CEC)],
                  ),
                ),
              ),
            ),
            leading: Builder(
              builder: (context) => Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: IconButton(
                  icon: const Icon(
                    Icons.menu_rounded,
                    color: Colors.white,
                    size: 24,
                  ),
                  onPressed: () {
                    Feedback.forTap(context);
                    Scaffold.of(context).openDrawer();
                  },
                  splashColor: Colors.white.withOpacity(0.2),
                  highlightColor: Colors.white.withOpacity(0.1),
                  tooltip: 'Open Menu',
                ),
              ),
            ),
            title: AnimatedOpacity(
              duration: const Duration(milliseconds: 300),
              opacity: 1.0,
              child: const Text(
                'Vee Zee Coffee',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Poppins',
                  letterSpacing: 0.5,
                ),
              ),
            ),
            centerTitle: true,
            actions: [
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                child: IconButton(
                  icon: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.white.withOpacity(0.3)),
                    ),
                    child: const Icon(
                      Icons.delete,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                  onPressed: () async {
                    final shouldDelete = await showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text(
                          'Clear Database?',
                          style: TextStyle(fontFamily: 'Poppins'),
                        ),
                        content: const Text(
                          'This will delete all data. This action cannot be undone.',
                          style: TextStyle(fontFamily: 'Inter'),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: const Text(
                              'Cancel',
                              style: TextStyle(fontFamily: 'Inter'),
                            ),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context, true),
                            child: const Text(
                              'Clear',
                              style: TextStyle(
                                color: Colors.red,
                                fontFamily: 'Inter',
                              ),
                            ),
                          ),
                        ],
                      ),
                    );

                    if (shouldDelete == true) {
                      final dbHelper = DatabaseHelper();
                      await dbHelper.clearDatabase();
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text(
                              'Database cleared successfully!',
                            ),
                            backgroundColor: const Color(0xFF27AE60),
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        );
                      }
                    }
                  },
                  tooltip: 'Clear Database',
                ),
              ),
            ],
          ),

          // Main content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ✅ Auto Image Carousel
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 20),
                    child: Column(
                      children: [
                        CarouselSlider(
                          options: CarouselOptions(
                            height: 170,
                            autoPlay: true,
                            enlargeCenterPage: true,
                            viewportFraction: 0.95,
                            autoPlayInterval: const Duration(seconds: 3),
                            onPageChanged: (index, reason) {
                              setState(() {
                                _carouselIndex = index;
                              });
                            },
                          ),
                          items: bannerImages.map((imageUrl) {
                            return Container(
                              margin: const EdgeInsets.symmetric(horizontal: 5),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                image: DecorationImage(
                                  image: NetworkImage(imageUrl),
                                  fit: BoxFit.cover,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 10,
                                    offset: const Offset(0, 5),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: bannerImages.asMap().entries.map((entry) {
                            return Container(
                              width: 8,
                              height: 8,
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: _carouselIndex == entry.key
                                    ? const Color(0xFF4A90E2)
                                    : Colors.grey.withOpacity(0.4),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Search Bar
                  Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: _searchController,
                      style: const TextStyle(
                        fontSize: 16,
                        fontFamily: 'Inter',
                        color: Color(0xFF2C3E50),
                      ),
                      decoration: InputDecoration(
                        hintText: 'Search coffee...',
                        hintStyle: const TextStyle(color: Color(0xFF7F8C8D)),
                        prefixIcon: const Icon(
                          Icons.search,
                          color: Color(0xFF4A90E2),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 16,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Color(0xFFE0E0E0),
                            width: 1.5,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Color.fromARGB(255, 169, 210, 255),
                            width: 1.8,
                          ),
                        ),
                      ),
                      onChanged: (value) {
                        final productProvider = Provider.of<ProductProvider>(
                          context,
                          listen: false,
                        );
                        productProvider.filterProducts(value);
                      },
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Category Chips
                  SizedBox(
                    height: 50,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children:
                          [
                            'All',
                            'Espresso',
                            'Cappuccino',
                            'Latte',
                            'Americano',
                            'Mocha',
                            'Macchiato',
                            'Specialty',
                          ].map((category) {
                            return Container(
                              margin: const EdgeInsets.only(right: 8),
                              child: ChoiceChip(
                                label: Text(
                                  category,
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w500,
                                    color: _selectedCategory == category
                                        ? Colors.white
                                        : const Color(0xFF2C3E50),
                                  ),
                                ),
                                selected: _selectedCategory == category,
                                onSelected: (selected) {
                                  setState(() {
                                    _selectedCategory = category;
                                  });
                                  final productProvider =
                                      Provider.of<ProductProvider>(
                                        context,
                                        listen: false,
                                      );
                                  productProvider.filterByCategory(category);
                                },
                                selectedColor: const Color(0xFF4A90E2),
                                backgroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  side: BorderSide(
                                    color: _selectedCategory == category
                                        ? const Color(0xFF4A90E2)
                                        : const Color(0xFFE0E0E0),
                                  ),
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

          // Products Grid
          Consumer<ProductProvider>(
            builder: (context, productProvider, child) {
              if (productProvider.isLoading) {
                return SliverToBoxAdapter(
                  child: Container(
                    height: 300,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: const Color(0xFF4A90E2).withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: const Stack(
                              alignment: Alignment.center,
                              children: [
                                SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 3,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Color(0xFF4A90E2),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            'Brewing Your Coffees...',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF2C3E50),
                              fontFamily: 'Poppins',
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Getting the finest selections ready',
                            style: TextStyle(
                              color: const Color(0xFF7F8C8D),
                              fontFamily: 'Inter',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }

              if (productProvider.filteredProducts.isEmpty) {
                return SliverToBoxAdapter(
                  child: Container(
                    height: 300,
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                color: const Color(
                                  0xFF4A90E2,
                                ).withOpacity(0.05),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.coffee_maker_outlined,
                                size: 48,
                                color: const Color(0xFF7F8C8D).withOpacity(0.5),
                              ),
                            ),
                            const SizedBox(height: 24),
                            Text(
                              _searchController.text.isEmpty
                                  ? 'No Coffees Available'
                                  : 'No Matching Coffees',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF2C3E50),
                                fontFamily: 'Poppins',
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              _searchController.text.isEmpty
                                  ? 'Check back later for new additions'
                                  : 'Try searching with different keywords',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14,
                                color: const Color(0xFF7F8C8D),
                                fontFamily: 'Inter',
                              ),
                            ),
                            const SizedBox(height: 20),
                            if (_searchController.text.isNotEmpty)
                              ElevatedButton(
                                onPressed: () {
                                  _searchController.clear();
                                  final productProvider =
                                      Provider.of<ProductProvider>(
                                        context,
                                        listen: false,
                                      );
                                  productProvider.filterProducts('');
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF4A90E2),
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 24,
                                    vertical: 12,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  elevation: 0,
                                ),
                                child: Text(
                                  'Clear Search',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'Inter',
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

              return SliverPadding(
                padding: const EdgeInsets.fromLTRB(20.0, 0, 20.0, 20.0),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.72,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final product = productProvider.filteredProducts[index];
                    return _buildAnimatedProductCard(product, index);
                  }, childCount: productProvider.filteredProducts.length),
                ),
              );
            },
          ),
        ],
      ),

      // Bottom Navigation Bar
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
            Navigator.pushNamed(context, _navItems[index].route);
          },
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: const Color(0xFF4A90E2),
          unselectedItemColor: const Color(0xFF7F8C8D),
          selectedLabelStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            fontFamily: 'Inter',
          ),
          unselectedLabelStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            fontFamily: 'Inter',
          ),
          items: _navItems.map((item) {
            return BottomNavigationBarItem(
              icon: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: _currentIndex == _navItems.indexOf(item)
                      ? item.color.withOpacity(0.1)
                      : Colors.transparent,
                ),
                child: Icon(
                  _currentIndex == _navItems.indexOf(item)
                      ? item.activeIcon
                      : item.icon,
                  size: 24,
                ),
              ),
              label: item.title,
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildAnimatedProductCard(Product product, int index) {
    return TweenAnimationBuilder(
      duration: Duration(milliseconds: 400 + (index * 100)),
      tween: Tween<double>(begin: 0.0, end: 1.0),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0.0, (1 - value) * 30),
          child: Opacity(
            opacity: value.clamp(0.0, 1.0),
            child: Transform.scale(scale: 0.95 + (value * 0.05), child: child),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
              spreadRadius: 0,
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              Navigator.pushNamed(
                context,
                AppRoutes.coffeeDetail,
                arguments: product,
              );
            },
            borderRadius: BorderRadius.circular(20),
            splashColor: const Color(0xFF4A90E2).withOpacity(0.1),
            highlightColor: const Color(0xFF4A90E2).withOpacity(0.05),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                 
                  // Product Image Container
                  Container(
                    height: 100,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      image: _getProductImageDecoration(product),
                      color: product.imagePath == null && product.image == null
                          ? const Color(0xFF4A90E2).withOpacity(0.1)
                          : null,
                    ),
                    child: Stack(
                      children: [
                        // Gradient overlay
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.black.withOpacity(0.2),
                                Colors.transparent,
                                Colors.transparent,
                              ],
                            ),
                          ),
                        ),

                        // Category badge
                        if (product.category != null)
                          Positioned(
                            top: 6,
                            left: 6,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFF4A90E2),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                product.category!,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 9,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Inter',
                                ),
                              ),
                            ),
                          ),

                        // Fallback icon when no image is available
                        if (product.imagePath == null && product.image == null)
                          Center(
                            child: Icon(
                              Icons.coffee_rounded,
                              size: 40,
                              color: const Color(0xFF4A90E2).withOpacity(0.5),
                            ),
                          ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Product Name
                  Text(
                    product.name,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2C3E50),
                      fontFamily: 'Inter',
                      height: 1.2,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 4),

                  // Description
                  Expanded(
                    child: Text(
                      product.description ?? 'A delicious coffee experience',
                      style: TextStyle(
                        fontSize: 11,
                        color: const Color(0xFF7F8C8D),
                        fontFamily: 'Inter',
                        height: 1.3,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Price and Add to Cart Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Price
                      Text(
                        '\$${product.price.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF4A90E2),
                          fontFamily: 'Poppins',
                        ),
                      ),

                      // Add to Cart Button
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF4A90E2), Color(0xFF5D9CEC)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF4A90E2).withOpacity(0.3),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                AppRoutes.coffeeDetail,
                                arguments: product,
                              );
                            },
                            borderRadius: BorderRadius.circular(8),
                            child: const Icon(
                              Icons.add,
                              size: 18,
                              color: Colors.white,
                            ),
                          ),
                        ),
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

  DecorationImage? _getProductImageDecoration(Product product) {
    // Priority 1: Local image file (uploaded image)
    if (product.imagePath != null && product.imagePath!.isNotEmpty) {
      return DecorationImage(
        image: FileImage(File(product.imagePath!)),
        fit: BoxFit.cover,
      );
    }

    // Priority 2: Network image (from URL)
    if (product.image != null && product.image!.isNotEmpty) {
      return DecorationImage(
        image: NetworkImage(product.image!),
        fit: BoxFit.cover,
      );
    }

    // No image available
    return null;
  }
}

class BottomNavigationItem {
  final String title;
  final IconData icon;
  final IconData activeIcon;
  final String route;
  final Color color;

  BottomNavigationItem({
    required this.title,
    required this.icon,
    required this.activeIcon,
    required this.route,
    required this.color,
  });
}



