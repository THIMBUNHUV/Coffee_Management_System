import 'package:coffee_shop_app/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:coffee_shop_app/providers/product_provider.dart';
import 'package:coffee_shop_app/config/routes.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'All';

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
      body: SafeArea(
        child: Column(
          children: [
            // Header with back button
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back_ios_rounded, size: 20),
                      color: const Color(0xFF2C3E50),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    'Coffee Menu',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF2C3E50),
                      fontFamily: 'Poppins',
                    ),
                  ),
                ],
              ),
            ),

            // Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
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
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
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
            ),

            const SizedBox(height: 20),

            // Category Chips
            SizedBox(
              height: 50,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 24),
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

            const SizedBox(height: 20),

            // Products Grid
            Expanded(
              child: Consumer<ProductProvider>(
                builder: (context, productProvider, child) {
                  if (productProvider.isLoading) {
                    return const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
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
                          SizedBox(height: 16),
                          Text(
                            'Loading coffees...',
                            style: TextStyle(
                              color: Color(0xFF7F8C8D),
                              fontFamily: 'Inter',
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  if (productProvider.filteredProducts.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.coffee_outlined,
                            size: 64,
                            color: const Color(0xFF7F8C8D).withOpacity(0.5),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No coffees found',
                            style: TextStyle(
                              fontSize: 18,
                              color: const Color(0xFF7F8C8D),
                              fontFamily: 'Inter',
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Try a different search or category',
                            style: TextStyle(
                              color: const Color(0xFF7F8C8D),
                              fontFamily: 'Inter',
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final isTablet = constraints.maxWidth > 600;
                        final crossAxisCount = isTablet ? 3 : 2;
                        final childAspectRatio = isTablet ? 0.7 : 0.75;

                        return GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: crossAxisCount,
                                childAspectRatio: childAspectRatio,
                                crossAxisSpacing: 20,
                                mainAxisSpacing: 20,
                              ),
                          itemCount: productProvider.filteredProducts.length,
                          itemBuilder: (context, index) {
                            final product =
                                productProvider.filteredProducts[index];

                            return _buildAnimatedCoffeeCard(
                              product: product,
                              index: index,
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  AppRoutes.coffeeDetail,
                                  arguments: product,
                                );
                              },
                            );
                          },
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Widget _buildAnimatedCoffeeCard({
    required Product product,
    required int index,
    required VoidCallback onTap,
  }) {
    return TweenAnimationBuilder(
      duration: Duration(milliseconds: 300 + (index * 100)),
      tween: Tween<double>(begin: 0.0, end: 1.0),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0.0, (1 - value) * 50),
          child: Opacity(opacity: value, child: child),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 15,
              offset: const Offset(0, 5),
              spreadRadius: 0,
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(20),
            splashColor: const Color(0xFF4A90E2).withOpacity(0.2),
            highlightColor: const Color(0xFF4A90E2).withOpacity(0.1),
            child: Stack(
              children: [
                // Background pattern
                Positioned(
                  top: -20,
                  right: -20,
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: const Color(0xFF4A90E2).withOpacity(0.05),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Product Image with gradient overlay
                    Container(
                      height: 120,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                        image: product.imagePath != null
                            ? DecorationImage(
                                image: NetworkImage(product.imagePath!),
                                fit: BoxFit.cover,
                              )
                            : null,
                        color: product.imagePath == null
                            ? const Color(0xFF4A90E2).withOpacity(0.1)
                            : null,
                      ),
                      child: Stack(
                        children: [
                          // Gradient overlay
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20),
                              ),
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.black.withOpacity(0.3),
                                  Colors.transparent,
                                ],
                              ),
                            ),
                          ),

                          // Favorite button
                          Positioned(
                            top: 8,
                            right: 8,
                            child: Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.9),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.favorite_border,
                                size: 18,
                                color: const Color(0xFF4A90E2),
                              ),
                            ),
                          ),

                          // Category badge
                          if (product.category != null)
                            Positioned(
                              top: 8,
                              left: 8,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF4A90E2),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  product.category!,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Inter',
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),

                    // Product Info
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Product Name
                            Text(
                              product.name,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF2C3E50),
                                fontFamily: 'Inter',
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),

                            // Description
                            Text(
                              product.description ?? '',
                              style: TextStyle(
                                fontSize: 11,
                                color: const Color(0xFF7F8C8D),
                                fontFamily: 'Inter',
                                height: 1.3,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),

                            // Price and Rating row
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

                            
                              ],
                            ),

                            // Add to cart button
                            Container(
                              width: double.infinity,
                              height: 32,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFF4A90E2),
                                    Color(0xFF50E3C2),
                                  ],
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: () {
                                    // Add to cart functionality
                                  },
                                  borderRadius: BorderRadius.circular(10),
                                  child: const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.add_shopping_cart,
                                        size: 14,
                                        color: Colors.white,
                                      ),
                                      SizedBox(width: 4),
                                      Text(
                                        'Add to Cart',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 11,
                                          fontWeight: FontWeight.w600,
                                          fontFamily: 'Inter',
                                        ),
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
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
