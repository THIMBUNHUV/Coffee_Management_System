import 'package:coffee_shop_app/models/cart_model.dart';
import 'package:coffee_shop_app/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:coffee_shop_app/providers/cart_provider.dart';
import 'package:coffee_shop_app/providers/auth_provider.dart';
import 'package:coffee_shop_app/providers/product_provider.dart';
import 'package:coffee_shop_app/config/routes.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  void initState() {
    super.initState();
    _loadCartItems();
  }

  Future<void> _loadCartItems() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final cartProvider = Provider.of<CartProvider>(context, listen: false);

    if (authProvider.customer != null) {
      await cartProvider.fetchCartItems(authProvider.customer!.id!);
    }
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
                      color: const Color(0xFF4A90E2).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: IconButton(
                      onPressed: () {
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          AppRoutes.home,
                          (Route<dynamic> route) =>
                              false, // remove all previous routes
                        );
                      },
                      icon: const Icon(Icons.arrow_back_ios_rounded, size: 20),
                      color: const Color(0xFF4A90E2),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Center(
                      child: const Text(
                        'My Cart',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2C3E50),
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ),
                  ),
                  // Text(
                  //   'My Cart',
                  //   style: TextStyle(
                  //     fontSize: 28,
                  //     fontWeight: FontWeight.bold,
                  //     color: const Color(0xFF2C3E50),
                  //     fontFamily: 'Poppins',
                  //   ),
                  // ),
                  // const Spacer(),
                  Consumer<CartProvider>(
                    builder: (context, cartProvider, child) {
                      if (cartProvider.cartItems.isNotEmpty) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF4A90E2),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            '${cartProvider.cartItems.length}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        );
                      }
                      return const SizedBox();
                    },
                  ),
                ],
              ),
            ),

            // Cart Content
            Expanded(
              child: Consumer<CartProvider>(
                builder: (context, cartProvider, child) {
                  if (cartProvider.isLoading) {
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
                            'Loading your cart...',
                            style: TextStyle(
                              color: Color(0xFF7F8C8D),
                              fontFamily: 'Inter',
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  if (cartProvider.cartItems.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              color: const Color(0xFF4A90E2).withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.shopping_cart_outlined,
                              size: 50,
                              color: Color(0xFF4A90E2),
                            ),
                          ),
                          const SizedBox(height: 24),
                          Text(
                            'Your cart is empty',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF2C3E50),
                              fontFamily: 'Poppins',
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Add some delicious coffees to your cart',
                            style: TextStyle(
                              color: const Color(0xFF7F8C8D),
                              fontFamily: 'Inter',
                            ),
                          ),
                          const SizedBox(height: 24),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF4A90E2),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 32,
                                vertical: 12,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              'Browse Menu',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Inter',
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return RefreshIndicator(
                    onRefresh: _loadCartItems,
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      itemCount: cartProvider.cartItems.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final item = cartProvider.cartItems[index];
                        return _buildCartItem(item, context);
                      },
                    ),
                  );
                },
              ),
            ),

            // Checkout Section
            Consumer<CartProvider>(
              builder: (context, cartProvider, child) {
                if (cartProvider.cartItems.isEmpty) return const SizedBox();

                return Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 20,
                        offset: const Offset(0, -5),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Order Summary
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Items (${cartProvider.cartItems.length})',
                            style: TextStyle(
                              color: const Color(0xFF7F8C8D),
                              fontFamily: 'Inter',
                            ),
                          ),
                          Text(
                            '\$${cartProvider.totalAmount.toStringAsFixed(2)}',
                            style: TextStyle(
                              color: const Color(0xFF2C3E50),
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Delivery',
                            style: TextStyle(
                              color: const Color(0xFF7F8C8D),
                              fontFamily: 'Inter',
                            ),
                          ),
                          const Text(
                            'Free',
                            style: TextStyle(
                              color: Color(0xFF27AE60),
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      const Divider(),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total Amount',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF2C3E50),
                              fontFamily: 'Poppins',
                            ),
                          ),
                          Text(
                            '\$${cartProvider.totalAmount.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF4A90E2),
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: cartProvider.isLoading
                              ? null
                              : () {
                                  Navigator.pushNamed(
                                    context,
                                    AppRoutes.checkout,
                                  );
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF4A90E2),
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: cartProvider.isLoading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white,
                                    ),
                                  ),
                                )
                              : const Text(
                                  'Proceed to Checkout',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'Inter',
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCartItem(CartItem item, BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(
      context,
      listen: false,
    );
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final cartProvider = Provider.of<CartProvider>(context, listen: false);

    return FutureBuilder<Product?>(
      future: productProvider.getProductById(item.productId),
      builder: (context, snapshot) {
        final product = snapshot.data;

        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product Image
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: const Color(0xFF4A90E2).withOpacity(0.1),
                    image: product?.imagePath != null
                        ? DecorationImage(
                            image: NetworkImage(product!.imagePath!),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: product?.imagePath == null
                      ? const Icon(
                          Icons.coffee,
                          color: Color(0xFF4A90E2),
                          size: 30,
                        )
                      : null,
                ),

                const SizedBox(width: 16),

                // Product Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product?.name ?? 'Product ${item.productId}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF2C3E50),
                          fontFamily: 'Inter',
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),

                      const SizedBox(height: 4),

                      Text(
                        '\$${(item.price ?? 0).toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF4A90E2),
                          fontFamily: 'Inter',
                        ),
                      ),

                      if (item.customization != null &&
                          item.customization!.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            item.customization!,
                            style: TextStyle(
                              color: const Color(0xFF7F8C8D),
                              fontSize: 12,
                              fontFamily: 'Inter',
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),

                      const SizedBox(height: 8),

                      // Quantity Controls
                      Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFF4A90E2).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.remove, size: 18),
                                  onPressed: () async {
                                    if (item.quantity > 1) {
                                      await cartProvider.updateQuantity(
                                        item.id!,
                                        authProvider.customer!.id!,
                                        item.quantity - 1,
                                      );
                                    }
                                  },
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(
                                    minWidth: 32,
                                    minHeight: 32,
                                  ),
                                ),
                                Text(
                                  item.quantity.toString(),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'Inter',
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.add, size: 18),
                                  onPressed: () async {
                                    await cartProvider.updateQuantity(
                                      item.id!,
                                      authProvider.customer!.id!,
                                      item.quantity + 1,
                                    );
                                  },
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(
                                    minWidth: 32,
                                    minHeight: 32,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const Spacer(),

                          // Delete Button
                          IconButton(
                            onPressed: () async {
                              await _showDeleteDialog(
                                item,
                                authProvider.customer!.id!,
                              );
                            },
                            icon: const Icon(Icons.delete_outline),
                            color: const Color(0xFFE74C3C),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _showDeleteDialog(CartItem item, int customerId) async {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);

    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove Item'),
        content: const Text(
          'Are you sure you want to remove this item from your cart?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await cartProvider.removeFromCart(item.id!, customerId);
            },
            child: const Text(
              'Remove',
              style: TextStyle(color: Color(0xFFE74C3C)),
            ),
          ),
        ],
      ),
    );
  }
}
