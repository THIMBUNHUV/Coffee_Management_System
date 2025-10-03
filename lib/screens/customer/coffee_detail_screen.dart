import 'dart:io';

import 'package:coffee_shop_app/config/routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:coffee_shop_app/models/product_model.dart';
import 'package:coffee_shop_app/models/cart_model.dart';
import 'package:coffee_shop_app/providers/cart_provider.dart';
import 'package:coffee_shop_app/providers/auth_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

class CoffeeDetailScreen extends StatefulWidget {
  final Product product;

  const CoffeeDetailScreen({super.key, required this.product});

  @override
  State<CoffeeDetailScreen> createState() => _CoffeeDetailScreenState();
}

class _CoffeeDetailScreenState extends State<CoffeeDetailScreen> {
  int _quantity = 1;
  String _selectedSize = 'Medium';
  String _selectedMilk = 'Whole';
  int _sugarLevel = 1;
  List<String> _toppings = [];
  final PageController _imageController = PageController();

  @override
  void dispose() {
    _imageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final cartProvider = Provider.of<CartProvider>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: Stack(
        children: [
          // Background Pattern
          Positioned(
            top: -100,
            right: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                color: const Color(0xFF4A90E2).withOpacity(0.05),
                shape: BoxShape.circle,
              ),
            ),
          ),

          Positioned(
            bottom: -150,
            left: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                color: const Color(0xFF50E3C2).withOpacity(0.05),
                shape: BoxShape.circle,
              ),
            ),
          ),

          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // Header with Image
              SliverAppBar(
                expandedHeight: 350,
                floating: false,
                pinned: true,
                backgroundColor: Colors.transparent,
                elevation: 0,
                leading: Padding(
                  padding: const EdgeInsets.only(left: 16, top: 8),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back_ios_rounded, size: 20),
                      color: const Color(0xFF2C3E50),
                    ),
                  ),
                ),

                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    children: [
                      // Product Image
                      // Container(
                      //   decoration: const BoxDecoration(
                      //     gradient: LinearGradient(
                      //       begin: Alignment.topCenter,
                      //       end: Alignment.bottomCenter,
                      //       colors: [Color(0xFF2C3E50), Color(0xFF4A90E2)],
                      //     ),
                      //   ),
                      //   child: widget.product.imagePath != null
                      //       ? CachedNetworkImage(
                      //           imageUrl: widget.product.imagePath!,
                      //           fit: BoxFit.cover,
                      //           width: double.infinity,
                      //           height: double.infinity,
                      //           placeholder: (context, url) => Container(
                      //             color: const Color(
                      //               0xFF4A90E2,
                      //             ).withOpacity(0.1),
                      //             child: const Center(
                      //               child: CircularProgressIndicator(
                      //                 valueColor: AlwaysStoppedAnimation<Color>(
                      //                   Color(0xFF4A90E2),
                      //                 ),
                      //               ),
                      //             ),
                      //           ),
                      //           errorWidget: (context, url, error) => Container(
                      //             color: const Color(
                      //               0xFF4A90E2,
                      //             ).withOpacity(0.1),
                      //             child: const Column(
                      //               mainAxisAlignment: MainAxisAlignment.center,
                      //               children: [
                      //                 Icon(
                      //                   Icons.coffee_maker_outlined,
                      //                   size: 80,
                      //                   color: Colors.white,
                      //                 ),
                      //                 SizedBox(height: 8),
                      //                 Text(
                      //                   'Coffee Image',
                      //                   style: TextStyle(
                      //                     color: Colors.white,
                      //                     fontWeight: FontWeight.w500,
                      //                   ),
                      //                 ),
                      //               ],
                      //             ),
                      //           ),
                      //         )
                      //       : Container(
                      //           color: const Color(0xFF4A90E2).withOpacity(0.1),
                      //           child: const Column(
                      //             mainAxisAlignment: MainAxisAlignment.center,
                      //             children: [
                      //               Icon(
                      //                 Icons.coffee_maker_outlined,
                      //                 size: 80,
                      //                 color: Colors.white,
                      //               ),
                      //               SizedBox(height: 8),
                      //               Text(
                      //                 'Coffee Image',
                      //                 style: TextStyle(
                      //                   color: Colors.white,
                      //                   fontWeight: FontWeight.w500,
                      //                 ),
                      //               ),
                      //             ],
                      //           ),
                      //         ),
                      // ),
                      Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Color(0xFF2C3E50), Color(0xFF4A90E2)],
                          ),
                        ),
                        child:
                            widget.product.imagePath != null &&
                                widget.product.imagePath!.isNotEmpty
                            ? Image.file(
                                File(widget.product.imagePath!),
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: double.infinity,
                                errorBuilder: (context, error, stackTrace) {
                                  return _buildFallbackImage();
                                },
                              )
                            : widget.product.image != null &&
                                  widget.product.image!.isNotEmpty
                            ? CachedNetworkImage(
                                imageUrl: widget.product.image!,
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: double.infinity,
                                placeholder: (context, url) => Container(
                                  color: const Color(
                                    0xFF4A90E2,
                                  ).withOpacity(0.1),
                                  child: const Center(
                                    child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Color(0xFF4A90E2),
                                      ),
                                    ),
                                  ),
                                ),
                                errorWidget: (context, url, error) =>
                                    _buildFallbackImage(),
                              )
                            : _buildFallbackImage(),
                      ),

                      // Don't forget to add this helper method

                      // Gradient Overlay
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(0.3),
                              const Color(0xFFF8F9FA),
                            ],
                            stops: const [0.0, 0.5, 1.0],
                          ),
                        ),
                      ),

                      // Product Info Overlay
                      Positioned(
                        bottom: 60,
                        left: 24,
                        right: 24,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.9),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                widget.product.category,
                                style: const TextStyle(
                                  color: Color(0xFF4A90E2),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Inter',
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              widget.product.name,
                              style: const TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontFamily: 'Poppins',
                                shadows: [
                                  Shadow(blurRadius: 10, color: Colors.black),
                                ],
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '\$${widget.product.price.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontFamily: 'Poppins',
                                shadows: [
                                  Shadow(blurRadius: 8, color: Colors.black),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Content
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Description Card
                      _buildGlassCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.description,
                                  color: Color(0xFF4A90E2),
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Description',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFF2C3E50),
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Text(
                              widget.product.description ??
                                  'A premium coffee experience crafted with the finest beans and expert brewing techniques.',
                              style: TextStyle(
                                fontSize: 14,
                                color: const Color(0xFF7F8C8D),
                                fontFamily: 'Inter',
                                height: 1.6,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Quantity Selector
                      _buildGlassCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.format_list_numbered,
                                  color: Color(0xFF4A90E2),
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Quantity',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFF2C3E50),
                                    fontFamily: 'Inter',
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _buildQuantityButton(
                                  icon: Icons.remove,
                                  onPressed: () {
                                    if (_quantity > 1) {
                                      setState(() {
                                        _quantity--;
                                      });
                                    }
                                  },
                                ),
                                Text(
                                  _quantity.toString(),
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF4A90E2),
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                                _buildQuantityButton(
                                  icon: Icons.add,
                                  onPressed: () {
                                    setState(() {
                                      _quantity++;
                                    });
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Customization Sections in a Row
                      Row(
                        children: [
                          Expanded(
                            child: _buildGlassCard(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.straighten,
                                        color: Color(0xFF4A90E2),
                                        size: 16,
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        'Size',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: const Color(0xFF2C3E50),
                                          fontFamily: 'Inter',
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  ...['Small', 'Medium', 'Large'].map((size) {
                                    return _buildOptionItem(
                                      title: size,
                                      isSelected: _selectedSize == size,
                                      onTap: () {
                                        setState(() {
                                          _selectedSize = size;
                                        });
                                      },
                                    );
                                  }).toList(),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildGlassCard(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.local_drink,
                                        color: Color(0xFF4A90E2),
                                        size: 16,
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        'Milk',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: const Color(0xFF2C3E50),
                                          fontFamily: 'Inter',
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  ...['Whole', 'Skim', 'Almond', 'Soy'].map((
                                    milk,
                                  ) {
                                    return _buildOptionItem(
                                      title: milk,
                                      isSelected: _selectedMilk == milk,
                                      onTap: () {
                                        setState(() {
                                          _selectedMilk = milk;
                                        });
                                      },
                                    );
                                  }).toList(),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // Sugar Level
                      _buildGlassCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.emoji_food_beverage,
                                  color: Color(0xFF4A90E2),
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Sugar Level',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFF2C3E50),
                                    fontFamily: 'Inter',
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(
                                  child: Slider(
                                    value: _sugarLevel.toDouble(),
                                    min: 0,
                                    max: 5,
                                    divisions: 5,
                                    activeColor: const Color(0xFF4A90E2),
                                    inactiveColor: const Color(
                                      0xFF4A90E2,
                                    ).withOpacity(0.3),
                                    label: _sugarLevel.toString(),
                                    onChanged: (value) {
                                      setState(() {
                                        _sugarLevel = value.toInt();
                                      });
                                    },
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF4A90E2),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    _sugarLevel.toString(),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Toppings
                      _buildGlassCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.icecream,
                                  color: Color(0xFF4A90E2),
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Toppings',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFF2C3E50),
                                    fontFamily: 'Inter',
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Wrap(
                              spacing: 12,
                              runSpacing: 12,
                              children:
                                  [
                                    'Whipped Cream',
                                    'Caramel',
                                    'Chocolate',
                                    'Cinnamon',
                                  ].map((topping) {
                                    return _buildToppingChip(topping);
                                  }).toList(),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 100), // Space for button
                    ],
                  ),
                ),
              ),
            ],
          ),

          // Add to Cart Button (Fixed at bottom)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 100,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    const Color(0xFFF8F9FA).withOpacity(0.0),
                    const Color(0xFFF8F9FA).withOpacity(0.8),
                    const Color(0xFFF8F9FA),
                  ],
                ),
              ),
              child: Center(
                child: Container(
                  margin: const EdgeInsets.all(24),
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (authProvider.customer != null) {
                        final customization =
                            'Size: $_selectedSize, Milk: $_selectedMilk, Sugar: $_sugarLevel, Toppings: ${_toppings.join(", ")}';
                        final cartItem = CartItem(
                          customerId: authProvider.customer!.id!,
                          productId: widget.product.id!,
                          quantity: _quantity,
                          customization: customization,
                          dateAdded: DateTime.now().toIso8601String(),
                          price: widget.product.price,
                        );
                        await cartProvider.addToCart(cartItem);

                        Navigator.pushNamed(context, AppRoutes.cart);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4A90E2),
                      foregroundColor: Colors.white,
                      elevation: 8,
                      shadowColor: const Color(0xFF4A90E2).withOpacity(0.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.shopping_bag_outlined, size: 20),
                        SizedBox(width: 8),
                        Text(
                          'Add to Cart',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Inter',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGlassCard({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.white.withOpacity(0.5)),
      ),
      child: child,
    );
  }

  Widget _buildQuantityButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: const Color(0xFF4A90E2).withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(icon, size: 20, color: const Color(0xFF4A90E2)),
        padding: EdgeInsets.zero,
      ),
    );
  }

  Widget _buildOptionItem({
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF4A90E2) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF4A90E2)
                : const Color(0xFFE0E0E0),
          ),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: isSelected ? Colors.white : const Color(0xFF2C3E50),
            fontSize: 12,
            fontWeight: FontWeight.w500,
            fontFamily: 'Inter',
          ),
        ),
      ),
    );
  }

  Widget _buildToppingChip(String topping) {
    final isSelected = _toppings.contains(topping);
    return GestureDetector(
      onTap: () {
        setState(() {
          if (isSelected) {
            _toppings.remove(topping);
          } else {
            _toppings.add(topping);
          }
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF4A90E2) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF4A90E2)
                : const Color(0xFFE0E0E0),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isSelected)
              const Icon(Icons.check, size: 14, color: Colors.white)
            else
              const Icon(Icons.add, size: 14, color: Color(0xFF4A90E2)),
            const SizedBox(width: 4),
            Text(
              topping,
              style: TextStyle(
                color: isSelected ? Colors.white : const Color(0xFF2C3E50),
                fontSize: 12,
                fontWeight: FontWeight.w500,
                fontFamily: 'Inter',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _buildFallbackImage() {
  return Container(
    color: const Color(0xFF4A90E2).withOpacity(0.1),
    child: const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.coffee_maker_outlined, size: 80, color: Colors.white),
        SizedBox(height: 8),
        Text(
          'Coffee Image',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
        ),
      ],
    ),
  );
}
