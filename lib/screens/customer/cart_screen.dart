// import 'package:vee_zee_coffee/models/cart_model.dart';
// import 'package:vee_zee_coffee/models/product_model.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:vee_zee_coffee/providers/cart_provider.dart';
// import 'package:vee_zee_coffee/providers/auth_provider.dart';
// import 'package:vee_zee_coffee/config/routes.dart';

// class CartScreen extends StatefulWidget {
//   const CartScreen({super.key});

//   @override
//   State<CartScreen> createState() => _CartScreenState();
// }

// class _CartScreenState extends State<CartScreen> {
//   @override
//   void initState() {
//     super.initState();
//     _loadCartItems();
//   }

//   Future<void> _loadCartItems() async {
//     final authProvider = Provider.of<AuthProvider>(context, listen: false);
//     final cartProvider = Provider.of<CartProvider>(context, listen: false);

//     if (authProvider.customer != null) {
//       await cartProvider.fetchCartItems(authProvider.customer!.id!);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF8F9FA),
//       body: SafeArea(
//         child: Column(
//           children: [
//             // Header with back button
//             Padding(
//               padding: const EdgeInsets.all(24.0),
//               child: Row(
//                 children: [
//                   Container(
//                     decoration: BoxDecoration(
//                       color: const Color(0xFF4A90E2).withOpacity(0.1),
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     child: IconButton(
//                       onPressed: () {
//                         Navigator.pushNamedAndRemoveUntil(
//                           context,
//                           AppRoutes.home,
//                           (Route<dynamic> route) => false,
//                         );
//                       },
//                       icon: const Icon(Icons.arrow_back_ios_rounded, size: 20),
//                       color: const Color(0xFF4A90E2),
//                     ),
//                   ),
//                   const SizedBox(width: 16),
//                   const Expanded(
//                     child: Center(
//                       child: Text(
//                         'My Cart',
//                         style: TextStyle(
//                           fontSize: 28,
//                           fontWeight: FontWeight.bold,
//                           color: Color(0xFF2C3E50),
//                           fontFamily: 'Poppins',
//                         ),
//                       ),
//                     ),
//                   ),
//                   Consumer<CartProvider>(
//                     builder: (context, cartProvider, child) {
//                       if (cartProvider.cartItems.isNotEmpty) {
//                         return Container(
//                           padding: const EdgeInsets.symmetric(
//                             horizontal: 12,
//                             vertical: 6,
//                           ),
//                           decoration: BoxDecoration(
//                             color: const Color(0xFF4A90E2),
//                             borderRadius: BorderRadius.circular(16),
//                           ),
//                           child: Text(
//                             '${cartProvider.itemCount}',
//                             style: const TextStyle(
//                               color: Colors.white,
//                               fontWeight: FontWeight.bold,
//                               fontSize: 12,
//                             ),
//                           ),
//                         );
//                       }
//                       return const SizedBox();
//                     },
//                   ),
//                 ],
//               ),
//             ),

//             // Cart Content
//             Expanded(
//               child: Consumer<CartProvider>(
//                 builder: (context, cartProvider, child) {
//                   // Show loading only on initial load
//                   if (cartProvider.isInitialLoad && cartProvider.isLoading) {
//                     return const Center(
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           SizedBox(
//                             width: 24,
//                             height: 24,
//                             child: CircularProgressIndicator(
//                               strokeWidth: 3,
//                               valueColor: AlwaysStoppedAnimation<Color>(
//                                 Color(0xFF4A90E2),
//                               ),
//                             ),
//                           ),
//                           SizedBox(height: 16),
//                           Text(
//                             'Loading your cart...',
//                             style: TextStyle(
//                               color: Color(0xFF7F8C8D),
//                               fontFamily: 'Inter',
//                             ),
//                           ),
//                         ],
//                       ),
//                     );
//                   }

//                   if (cartProvider.cartItems.isEmpty) {
//                     return Center(
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Container(
//                             width: 120,
//                             height: 120,
//                             decoration: BoxDecoration(
//                               color: const Color(0xFF4A90E2).withOpacity(0.1),
//                               shape: BoxShape.circle,
//                             ),
//                             child: const Icon(
//                               Icons.shopping_cart_outlined,
//                               size: 50,
//                               color: Color(0xFF4A90E2),
//                             ),
//                           ),
//                           const SizedBox(height: 24),
//                           const Text(
//                             'Your cart is empty',
//                             style: TextStyle(
//                               fontSize: 20,
//                               fontWeight: FontWeight.bold,
//                               color: Color(0xFF2C3E50),
//                               fontFamily: 'Poppins',
//                             ),
//                           ),
//                           const SizedBox(height: 8),
//                           const Text(
//                             'Add some delicious coffees to your cart',
//                             style: TextStyle(
//                               color: Color(0xFF7F8C8D),
//                               fontFamily: 'Inter',
//                             ),
//                           ),
//                           const SizedBox(height: 24),
//                           ElevatedButton(
//                             onPressed: () {
//                               Navigator.pop(context);
//                             },
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: const Color(0xFF4A90E2),
//                               foregroundColor: Colors.white,
//                               padding: const EdgeInsets.symmetric(
//                                 horizontal: 32,
//                                 vertical: 12,
//                               ),
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(12),
//                               ),
//                             ),
//                             child: const Text(
//                               'Browse Menu',
//                               style: TextStyle(
//                                 fontWeight: FontWeight.w600,
//                                 fontFamily: 'Inter',
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     );
//                   }

//                   return RefreshIndicator(
//                     onRefresh: _loadCartItems,
//                     child: ListView.separated(
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: 20,
//                         vertical: 10,
//                       ),
//                       itemCount: cartProvider.cartItems.length,
//                       separatorBuilder: (context, index) =>
//                           const SizedBox(height: 12),
//                       itemBuilder: (context, index) {
//                         final item = cartProvider.cartItems[index];
//                         return _buildCartItem(item, context);
//                       },
//                     ),
//                   );
//                 },
//               ),
//             ),

//             // Checkout Section
//             Consumer<CartProvider>(
//               builder: (context, cartProvider, child) {
//                 if (cartProvider.cartItems.isEmpty) return const SizedBox();

//                 return Container(
//                   padding: const EdgeInsets.all(24),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: const BorderRadius.only(
//                       topLeft: Radius.circular(24),
//                       topRight: Radius.circular(24),
//                     ),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.black.withOpacity(0.1),
//                         blurRadius: 20,
//                         offset: const Offset(0, -5),
//                       ),
//                     ],
//                   ),
//                   child: Column(
//                     children: [
//                       // Order Summary
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Text(
//                             'Items (${cartProvider.itemCount})',
//                             style: const TextStyle(
//                               color: Color(0xFF7F8C8D),
//                               fontFamily: 'Inter',
//                             ),
//                           ),
//                           Text(
//                             '\$${cartProvider.totalAmount.toStringAsFixed(2)}',
//                             style: const TextStyle(
//                               color: Color(0xFF2C3E50),
//                               fontFamily: 'Inter',
//                               fontWeight: FontWeight.w600,
//                             ),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 8),
//                       const Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Text(
//                             'Delivery',
//                             style: TextStyle(
//                               color: Color(0xFF7F8C8D),
//                               fontFamily: 'Inter',
//                             ),
//                           ),
//                           Text(
//                             'Free',
//                             style: TextStyle(
//                               color: Color(0xFF27AE60),
//                               fontFamily: 'Inter',
//                               fontWeight: FontWeight.w600,
//                             ),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 16),
//                       const Divider(),
//                       const SizedBox(height: 16),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           const Text(
//                             'Total Amount',
//                             style: TextStyle(
//                               fontSize: 18,
//                               fontWeight: FontWeight.bold,
//                               color: Color(0xFF2C3E50),
//                               fontFamily: 'Poppins',
//                             ),
//                           ),
//                           Text(
//                             '\$${cartProvider.totalAmount.toStringAsFixed(2)}',
//                             style: const TextStyle(
//                               fontSize: 18,
//                               fontWeight: FontWeight.bold,
//                               color: Color(0xFF4A90E2),
//                               fontFamily: 'Poppins',
//                             ),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 20),
//                       SizedBox(
//                         width: double.infinity,
//                         height: 56,
//                         child: ElevatedButton(
//                           onPressed: cartProvider.isLoading
//                               ? null
//                               : () {
//                                   Navigator.pushNamed(
//                                     context,
//                                     AppRoutes.checkout,
//                                   );
//                                 },
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: const Color(0xFF4A90E2),
//                             foregroundColor: Colors.white,
//                             elevation: 0,
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(12),
//                             ),
//                           ),
//                           child: cartProvider.isLoading
//                               ? const SizedBox(
//                                   width: 20,
//                                   height: 20,
//                                   child: CircularProgressIndicator(
//                                     strokeWidth: 2,
//                                     valueColor: AlwaysStoppedAnimation<Color>(
//                                       Colors.white,
//                                     ),
//                                   ),
//                                 )
//                               : const Text(
//                                   'Proceed to Checkout',
//                                   style: TextStyle(
//                                     fontSize: 16,
//                                     fontWeight: FontWeight.w600,
//                                     fontFamily: 'Inter',
//                                   ),
//                                 ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 );
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildCartItem(CartItem item, BuildContext context) {
//     final cartProvider = Provider.of<CartProvider>(context);
//     final authProvider = Provider.of<AuthProvider>(context, listen: false);

//     final product = cartProvider.getCachedProduct(item.productId);
//     final isItemLoading = cartProvider.isItemLoading(item.id!);

//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.05),
//             blurRadius: 10,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Row(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Product Image
//             Container(
//               width: 80,
//               height: 80,
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(12),
//                 color: const Color(0xFF4A90E2).withOpacity(0.1),
//               ),
//               clipBehavior: Clip.antiAlias,
//               child: product?.imagePath != null
//                   ? Image.network(
//                       product!.imagePath!,
//                       fit: BoxFit.cover,
//                       loadingBuilder: (context, child, loadingProgress) {
//                         if (loadingProgress == null) return child;
//                         return const Center(
//                           child: SizedBox(
//                             width: 20,
//                             height: 20,
//                             child: CircularProgressIndicator(
//                               strokeWidth: 2,
//                               valueColor: AlwaysStoppedAnimation<Color>(
//                                 Color(0xFF4A90E2),
//                               ),
//                             ),
//                           ),
//                         );
//                       },
//                       errorBuilder: (context, error, stackTrace) {
//                         return const Center(
//                           child: Icon(
//                             Icons.coffee,
//                             color: Color(0xFF4A90E2),
//                             size: 30,
//                           ),
//                         );
//                       },
//                     )
//                   : const Center(
//                       child: Icon(
//                         Icons.coffee,
//                         color: Color(0xFF4A90E2),
//                         size: 30,
//                       ),
//                     ),
//             ),

//             const SizedBox(width: 16),

//             // Product Details
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     product?.name ?? 'Loading...',
//                     style: const TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.w600,
//                       color: Color(0xFF2C3E50),
//                       fontFamily: 'Inter',
//                     ),
//                     maxLines: 2,
//                     overflow: TextOverflow.ellipsis,
//                   ),

//                   const SizedBox(height: 4),

//                   Text(
//                     '\$${(item.price ?? 0).toStringAsFixed(2)}',
//                     style: const TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                       color: Color(0xFF4A90E2),
//                       fontFamily: 'Inter',
//                     ),
//                   ),

//                   if (item.customization != null &&
//                       item.customization!.isNotEmpty)
//                     Padding(
//                       padding: const EdgeInsets.only(top: 4),
//                       child: Text(
//                         item.customization!,
//                         style: const TextStyle(
//                           color: Color(0xFF7F8C8D),
//                           fontSize: 12,
//                           fontFamily: 'Inter',
//                         ),
//                         maxLines: 2,
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                     ),

//                   const SizedBox(height: 8),

//                   // Quantity Controls
//                   Row(
//                     children: [
//                       Container(
//                         decoration: BoxDecoration(
//                           color: const Color(0xFF4A90E2).withOpacity(0.1),
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                         child: Row(
//                           children: [
//                             IconButton(
//                               icon: const Icon(Icons.remove, size: 18),
//                               onPressed: isItemLoading || item.quantity <= 1
//                                   ? null
//                                   : () async {
//                                       await cartProvider.updateQuantity(
//                                         item.id!,
//                                         authProvider.customer!.id!,
//                                         item.quantity - 1,
//                                       );
//                                     },
//                               padding: EdgeInsets.zero,
//                               constraints: const BoxConstraints(
//                                 minWidth: 32,
//                                 minHeight: 32,
//                               ),
//                             ),
//                             isItemLoading
//                                 ? const SizedBox(
//                                     width: 20,
//                                     height: 20,
//                                     child: CircularProgressIndicator(
//                                       strokeWidth: 2,
//                                       valueColor: AlwaysStoppedAnimation<Color>(
//                                         Color(0xFF4A90E2),
//                                       ),
//                                     ),
//                                   )
//                                 : Text(
//                                     item.quantity.toString(),
//                                     style: const TextStyle(
//                                       fontWeight: FontWeight.w600,
//                                       fontFamily: 'Inter',
//                                     ),
//                                   ),
//                             IconButton(
//                               icon: const Icon(Icons.add, size: 18),
//                               onPressed: isItemLoading
//                                   ? null
//                                   : () async {
//                                       await cartProvider.updateQuantity(
//                                         item.id!,
//                                         authProvider.customer!.id!,
//                                         item.quantity + 1,
//                                       );
//                                     },
//                               padding: EdgeInsets.zero,
//                               constraints: const BoxConstraints(
//                                 minWidth: 32,
//                                 minHeight: 32,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),

//                       const Spacer(),

//                       // Delete Button
//                       IconButton(
//                         onPressed: isItemLoading
//                             ? null
//                             : () async {
//                                 await _showDeleteDialog(
//                                   item,
//                                   authProvider.customer!.id!,
//                                 );
//                               },
//                         icon: const Icon(Icons.delete_outline),
//                         color: const Color(0xFFE74C3C),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Future<void> _showDeleteDialog(CartItem item, int customerId) async {
//     final cartProvider = Provider.of<CartProvider>(context, listen: false);

//     return showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Remove Item'),
//         content: const Text(
//           'Are you sure you want to remove this item from your cart?',
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('Cancel'),
//           ),
//           TextButton(
//             onPressed: () async {
//               Navigator.pop(context);
//               await cartProvider.removeFromCart(item.id!, customerId);
//             },
//             child: const Text(
//               'Remove',
//               style: TextStyle(color: Color(0xFFE74C3C)),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vee_zee_coffee/config/routes.dart';
import 'package:vee_zee_coffee/providers/cart_provider.dart';
import 'package:vee_zee_coffee/providers/auth_provider.dart';
import 'package:vee_zee_coffee/models/cart_model.dart';
import 'package:vee_zee_coffee/models/product_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'dart:io';

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

  void _loadCartItems() {
    final authProvider = context.read<AuthProvider>();
    final cartProvider = context.read<CartProvider>();

    if (authProvider.customer != null) {
      cartProvider.fetchCartItems(authProvider.customer!.id!);
    }
  }

  @override
  // Widget build(BuildContext context) {
  //   final authProvider = context.watch<AuthProvider>();
  //   final cartProvider = context.watch<CartProvider>();
  //   return Scaffold(
  //     backgroundColor: const Color(0xFFF8F9FA),
  //     body: SafeArea(
  //       child: Column(
  //         children: [
  //           // Background Pattern (similar to coffee detail)
  //           // Positioned(
  //           //   top: -100,
  //           //   right: -100,
  //           //   child: Container(
  //           //     width: 300,
  //           //     height: 300,
  //           //     decoration: BoxDecoration(
  //           //       color: const Color(0xFF4A90E2).withOpacity(0.05),
  //           //       shape: BoxShape.circle,
  //           //     ),
  //           //   ),
  //           // ),
  //           // Positioned(
  //           //   bottom: -150,
  //           //   left: -100,
  //           //   child: Container(
  //           //     width: 300,
  //           //     height: 300,
  //           //     decoration: BoxDecoration(
  //           //       color: const Color(0xFF50E3C2).withOpacity(0.05),
  //           //       shape: BoxShape.circle,
  //           //     ),
  //           //   ),
  //           // ),
  //           Column(
  //             children: [
  //               // Custom App Bar with back button
  //               // Container(
  //               //   padding: const EdgeInsets.only(
  //               //     top: 60,
  //               //     bottom: 16,
  //               //     left: 16,
  //               //     right: 16,
  //               //   ),
  //               //   decoration: BoxDecoration(color: Colors.transparent),
  //               //   child: Row(
  //               //     children: [
  //               //       // Back button
  //               //       Container(
  //               //         decoration: BoxDecoration(
  //               //           color: Colors.white.withOpacity(0.9),
  //               //           shape: BoxShape.circle,
  //               //           boxShadow: [
  //               //             BoxShadow(
  //               //               color: Colors.black.withOpacity(0.1),
  //               //               blurRadius: 8,
  //               //               offset: const Offset(0, 2),
  //               //             ),
  //               //           ],
  //               //         ),
  //               //         child: IconButton(
  //               //           onPressed: () => Navigator.pop(context),
  //               //           icon: const Icon(
  //               //             Icons.arrow_back_ios_rounded,
  //               //             size: 20,
  //               //           ),
  //               //           color: const Color(0xFF2C3E50),
  //               //         ),
  //               //       ),
  //               //       const SizedBox(width: 16),
  //               //       const Text(
  //               //         'My Cart',
  //               //         style: TextStyle(
  //               //           fontSize: 24,
  //               //           fontWeight: FontWeight.bold,
  //               //           color: Color(0xFF2C3E50),
  //               //           fontFamily: 'Poppins',
  //               //         ),
  //               //       ),
  //               //     ],
  //               //   ),
  //               // ),
  //               Container(
  //                 padding: const EdgeInsets.all(24),
  //                 decoration: BoxDecoration(
  //                   color: Colors.white,
  //                   borderRadius: const BorderRadius.only(
  //                     bottomLeft: Radius.circular(24),
  //                     bottomRight: Radius.circular(24),
  //                   ),
  //                   boxShadow: [
  //                     BoxShadow(
  //                       color: Colors.black.withOpacity(0.05),
  //                       blurRadius: 20,
  //                       offset: const Offset(0, 4),
  //                     ),
  //                   ],
  //                 ),
  //                 child: Row(
  //                   children: [
  //                     Container(
  //                       decoration: BoxDecoration(
  //                         color: const Color(0xFF4A90E2).withOpacity(0.1),
  //                         borderRadius: BorderRadius.circular(12),
  //                       ),
  //                       child: IconButton(
  //                         onPressed: () => Navigator.pop(context),
  //                         icon: const Icon(
  //                           Icons.arrow_back_ios_rounded,
  //                           size: 20,
  //                         ),
  //                         color: const Color(0xFF4A90E2),
  //                       ),
  //                     ),
  //                     const SizedBox(width: 16),
  //                     Expanded(
  //                       child: Center(
  //                         child: const Text(
  //                           'My Cart',
  //                           style: TextStyle(
  //                             fontSize: 28,
  //                             fontWeight: FontWeight.bold,
  //                             color: Color(0xFF2C3E50),
  //                             fontFamily: 'Poppins',
  //                           ),
  //                         ),
  //                       ),
  //                     ),
  //                     Container(
  //                       padding: const EdgeInsets.symmetric(
  //                         horizontal: 12,
  //                         vertical: 6,
  //                       ),
  //                       decoration: BoxDecoration(
  //                         color: const Color(0xFF4A90E2),
  //                         borderRadius: BorderRadius.circular(16),
  //                       ),
  //                       child: Text(
  //                         '${cartProvider.cartItems.length} items',
  //                         style: const TextStyle(
  //                           color: Colors.white,
  //                           fontWeight: FontWeight.w600,
  //                           fontSize: 12,
  //                         ),
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //               // Cart Content
  //               Expanded(
  //                 child: authProvider.customer == null
  //                     ? const Center(
  //                         child: Text('Please login to view your cart'),
  //                       )
  //                     : cartProvider.isLoading
  //                     ? const Center(child: CircularProgressIndicator())
  //                     : cartProvider.cartItems.isEmpty
  //                     ? _buildEmptyCart()
  //                     : _buildCartContent(
  //                         cartProvider,
  //                         authProvider.customer!.id!,
  //                       ),
  //               ),
  //             ],
  //           ),
  //           // Checkout Section (Fixed at bottom)
  //           if (cartProvider.cartItems.isNotEmpty)
  //             Positioned(
  //               bottom: 0,
  //               left: 0,
  //               right: 0,
  //               child: _buildCheckoutSection(cartProvider),
  //             ),
  //         ],
  //       ),
  //     ),
  //   );
  // }
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final cartProvider = context.watch<CartProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: Column(
          children: [
            // Header (same as checkout screen)
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 20,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF4A90E2).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: IconButton(
                      onPressed: () => Navigator.pop(context),
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
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF4A90E2),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      '${cartProvider.cartItems.length} items',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Cart Content
            Expanded(
              child: authProvider.customer == null
                  ? const Center(child: Text('Please login to view your cart'))
                  : cartProvider.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : cartProvider.cartItems.isEmpty
                  ? _buildEmptyCart()
                  : _buildCartContent(cartProvider, authProvider.customer!.id!),
            ),

            // Checkout Section (same as checkout screen bottom)
            if (cartProvider.cartItems.isNotEmpty)
              Container(
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
                child: SafeArea(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Total Amount',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF2C3E50),
                              fontFamily: 'Inter',
                            ),
                          ),
                          Text(
                            '\$${cartProvider.totalAmount.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF4A90E2),
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamed(context, AppRoutes.checkout);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF4A90E2),
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            shadowColor: const Color(
                              0xFF4A90E2,
                            ).withOpacity(0.3),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.shopping_bag_outlined, size: 20),
                              SizedBox(width: 8),
                              Text(
                                'Proceed to Checkout',
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
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyCart() {
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
              size: 60,
              color: Color(0xFF4A90E2),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Your cart is empty',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2C3E50),
              fontFamily: 'Poppins',
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Add some delicious coffee to get started!',
            style: TextStyle(color: Color(0xFF7F8C8D), fontFamily: 'Inter'),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4A90E2),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
            ),
            child: const Text('Browse Menu'),
          ),
        ],
      ),
    );
  }

  Widget _buildCartContent(CartProvider cartProvider, int customerId) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: cartProvider.cartItems.length,
        itemBuilder: (context, index) {
          final item = cartProvider.cartItems[index];
          final product = cartProvider.getProductForCartItem(item.productId);
          return _buildCartItem(
            context,
            item,
            product,
            cartProvider,
            customerId,
          );
        },
      ),
    );
  }

  Widget _buildCartItem(
    BuildContext context,
    CartItem item,
    Product? product,
    CartProvider cartProvider,
    int customerId,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Top row: Image and basic info
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Image
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: const Color(0xFFF8F9FA),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: _buildProductImage(product),
                ),
              ),

              const SizedBox(width: 12),

              // Product Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product?.name ?? 'Product',
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

                    if (item.customization != null &&
                        item.customization!.isNotEmpty)
                      Text(
                        item.customization!,
                        style: TextStyle(
                          fontSize: 12,
                          color: const Color(0xFF7F8C8D).withOpacity(0.8),
                          fontFamily: 'Inter',
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                  ],
                ),
              ),

              // Remove button
              IconButton(
                onPressed: () => _removeItem(item, cartProvider, customerId),
                icon: const Icon(
                  Icons.delete_outline,
                  color: Colors.red,
                  size: 20,
                ),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Bottom row: Price and quantity controls
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '\$${((item.price ?? 0) * item.quantity).toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4A90E2),
                  fontFamily: 'Poppins',
                ),
              ),

              // Quantity controls
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFF8F9FA),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        _updateQuantity(
                          item,
                          item.quantity - 1,
                          cartProvider,
                          customerId,
                        );
                      },
                      icon: const Icon(Icons.remove, size: 18),
                      padding: const EdgeInsets.all(6),
                      constraints: const BoxConstraints(
                        minWidth: 36,
                        minHeight: 36,
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        item.quantity.toString(),
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                    ),

                    IconButton(
                      onPressed: () {
                        _updateQuantity(
                          item,
                          item.quantity + 1,
                          cartProvider,
                          customerId,
                        );
                      },
                      icon: const Icon(Icons.add, size: 18),
                      padding: const EdgeInsets.all(6),
                      constraints: const BoxConstraints(
                        minWidth: 36,
                        minHeight: 36,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProductImage(Product? product) {
    if (product == null) {
      return _buildFallbackImage();
    }

    if (product.imagePath != null && product.imagePath!.isNotEmpty) {
      return Image.file(
        File(product.imagePath!),
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return _buildFallbackImage();
        },
      );
    } else if (product.image != null && product.image!.isNotEmpty) {
      return CachedNetworkImage(
        imageUrl: product.image!,
        fit: BoxFit.cover,
        placeholder: (context, url) => Container(
          color: const Color(0xFF4A90E2).withOpacity(0.1),
          child: const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF4A90E2)),
            ),
          ),
        ),
        errorWidget: (context, url, error) => _buildFallbackImage(),
      );
    } else {
      return _buildFallbackImage();
    }
  }

  Widget _buildFallbackImage() {
    return Container(
      color: const Color(0xFF4A90E2).withOpacity(0.1),
      child: const Center(
        child: Icon(
          Icons.coffee_maker_outlined,
          size: 30,
          color: Color(0xFF4A90E2),
        ),
      ),
    );
  }

  Widget _buildCheckoutSection(CartProvider cartProvider) {
    final total = cartProvider.cartItems.fold<double>(
      0,
      (sum, item) => sum + (item.price ?? 0) * item.quantity,
    );

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
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2C3E50),
                    fontFamily: 'Inter',
                  ),
                ),
                Text(
                  '\$${total.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4A90E2),
                    fontFamily: 'Poppins',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () {
                  // Handle checkout
                  _proceedToCheckout(cartProvider);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4A90E2),
                  foregroundColor: Colors.white,
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text(
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
      ),
    );
  }

  void _updateQuantity(
    CartItem item,
    int newQuantity,
    CartProvider cartProvider,
    int customerId,
  ) {
    if (newQuantity <= 0) {
      _removeItem(item, cartProvider, customerId);
      return;
    }

    // Update locally without refreshing the entire cart
    final updatedItem = item.copyWith(quantity: newQuantity);

    // Update in provider without triggering full refresh
    cartProvider.updateCartItemQuantity(updatedItem, customerId);
  }

  void _removeItem(CartItem item, CartProvider cartProvider, int customerId) {
    showDialog(
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
            onPressed: () {
              if (item.id != null) {
                cartProvider.removeFromCart(item.id!, customerId);
              }
              Navigator.pop(context);
            },
            child: const Text('Remove', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _proceedToCheckout(CartProvider cartProvider) {
    // Implement your checkout logic here
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Proceeding to checkout...')));
  }
}
