import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vee_zee_coffee/providers/cart_provider.dart';
import 'package:vee_zee_coffee/providers/auth_provider.dart';
import 'package:vee_zee_coffee/providers/order_provider.dart';
import 'package:vee_zee_coffee/models/order_model.dart';
import 'package:vee_zee_coffee/models/cart_model.dart';
import 'package:vee_zee_coffee/config/routes.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  String _deliveryOption = 'delivery';
  String _paymentMethod = 'cash';
  final _addressController = TextEditingController();
  bool _isPlacingOrder = false;

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final cartProvider = Provider.of<CartProvider>(context);
    final orderProvider = Provider.of<OrderProvider>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: Column(
          children: [
            // Header
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
                        'Checkout',
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

            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Delivery Option Card
                    _buildSectionCard(
                      title: 'Delivery Option',
                      child: Column(
                        children: [
                          _buildOptionCard(
                            title: '🚚 Delivery',
                            subtitle: 'Get it delivered to your doorstep',
                            isSelected: _deliveryOption == 'delivery',
                            onTap: () =>
                                setState(() => _deliveryOption = 'delivery'),
                          ),
                          const SizedBox(height: 12),
                          _buildOptionCard(
                            title: '🏪 Pickup',
                            subtitle: 'Pick up from our store',
                            isSelected: _deliveryOption == 'pickup',
                            onTap: () =>
                                setState(() => _deliveryOption = 'pickup'),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Delivery Address (if delivery selected)
                    if (_deliveryOption == 'delivery')
                      _buildSectionCard(
                        title: 'Delivery Address',
                        child: TextField(
                          controller: _addressController,
                          decoration: InputDecoration(
                            hintText: 'Enter your delivery address...',
                            hintStyle: TextStyle(
                              color: Colors.grey.shade600,
                              fontFamily: 'Inter',
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            filled: true,
                            fillColor: Colors.grey.shade50,
                            contentPadding: const EdgeInsets.all(16),
                          ),
                          maxLines: 2,
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            color: Color(0xFF2C3E50),
                          ),
                        ),
                      ),

                    const SizedBox(height: 20),

                    // Payment Method Card
                    _buildSectionCard(
                      title: 'Payment Method',
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: _buildPaymentOption(
                                  icon: Icons.money,
                                  title: 'Cash',
                                  isSelected: _paymentMethod == 'cash',
                                  onTap: () =>
                                      setState(() => _paymentMethod = 'cash'),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: _buildPaymentOption(
                                  icon: Icons.credit_card,
                                  title: 'Card',
                                  isSelected: _paymentMethod == 'card',
                                  onTap: () =>
                                      setState(() => _paymentMethod = 'card'),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: _buildPaymentOption(
                                  icon: Icons.phone_iphone,
                                  title: 'Mobile',
                                  isSelected: _paymentMethod == 'mobile',
                                  onTap: () =>
                                      setState(() => _paymentMethod = 'mobile'),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Order Summary Card
                    _buildSectionCard(
                      title: 'Order Summary',
                      child: Column(
                        children: [
                          ...cartProvider.cartItems.map(
                            (item) => _buildOrderItem(item),
                          ),
                          const SizedBox(height: 16),
                          const Divider(height: 1),
                          const SizedBox(height: 16),
                          _buildTotalRow('Subtotal', cartProvider.totalAmount),
                          _buildTotalRow('Delivery Fee', 0.0),
                          const SizedBox(height: 8),
                          const Divider(height: 1),
                          const SizedBox(height: 12),
                          _buildTotalRow(
                            'Total Amount',
                            cartProvider.totalAmount,
                            isTotal: true,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),

            // Checkout Button
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
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _isPlacingOrder
                      ? null
                      : () => _placeOrder(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4A90E2),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    shadowColor: const Color(0xFF4A90E2).withOpacity(0.3),
                  ),
                  child: _isPlacingOrder
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
                      : const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.shopping_bag_outlined, size: 20),
                            SizedBox(width: 8),
                            Text(
                              'Place Order',
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
          ],
        ),
      ),
    );
  }

  Widget _buildSectionCard({required String title, required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2C3E50),
              fontFamily: 'Poppins',
            ),
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  Widget _buildOptionCard({
    required String title,
    required String subtitle,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF4A90E2).withOpacity(0.1)
              : Colors.grey.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? const Color(0xFF4A90E2) : Colors.transparent,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected
                      ? const Color(0xFF4A90E2)
                      : Colors.grey.shade400,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? const Icon(Icons.check, size: 16, color: Color(0xFF4A90E2))
                  : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: isSelected
                          ? const Color(0xFF4A90E2)
                          : const Color(0xFF2C3E50),
                      fontFamily: 'Inter',
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                      fontFamily: 'Inter',
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentOption({
    required IconData icon,
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF4A90E2).withOpacity(0.1)
              : Colors.grey.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? const Color(0xFF4A90E2) : Colors.transparent,
            width: 2,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected
                  ? const Color(0xFF4A90E2)
                  : Colors.grey.shade600,
              size: 24,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: isSelected
                    ? const Color(0xFF4A90E2)
                    : const Color(0xFF2C3E50),
                fontFamily: 'Inter',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderItem(CartItem item) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: const Color(0xFF4A90E2).withOpacity(0.1),
            ),
            child: const Icon(Icons.coffee, color: Color(0xFF4A90E2), size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Product ${item.productId}',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2C3E50),
                    fontFamily: 'Inter',
                  ),
                ),
                if (item.customization != null &&
                    item.customization!.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Text(
                      item.customization!,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 12,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Text(
            '×${item.quantity}',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade600,
              fontFamily: 'Inter',
            ),
          ),
          const SizedBox(width: 12),
          Text(
            '\$${(item.price ?? 0).toStringAsFixed(2)}',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF4A90E2),
              fontFamily: 'Inter',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTotalRow(String label, double amount, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: isTotal ? const Color(0xFF2C3E50) : Colors.grey.shade600,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              fontFamily: 'Inter',
              fontSize: isTotal ? 16 : 14,
            ),
          ),
          Text(
            amount == 0 && label == 'Delivery Fee'
                ? 'FREE'
                : '\$${amount.toStringAsFixed(2)}',
            style: TextStyle(
              color: isTotal ? const Color(0xFF4A90E2) : Colors.grey.shade600,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              fontFamily: 'Inter',
              fontSize: isTotal ? 16 : 14,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _placeOrder(BuildContext context) async {
    if (_deliveryOption == 'delivery' && _addressController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please enter delivery address'),
          backgroundColor: Colors.red.shade400,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
      return;
    }

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    final orderProvider = Provider.of<OrderProvider>(context, listen: false);

    setState(() => _isPlacingOrder = true);

    try {
      final order = Order(
        customerId: authProvider.customer!.id!,
        totalPrice: cartProvider.totalAmount,
        status: 'Preparing',
        orderDate: DateTime.now().toIso8601String(),
        deliveryAddress: _deliveryOption == 'delivery'
            ? _addressController.text
            : null,
      );

      final orderDetails = cartProvider.cartItems.map((item) {
        return OrderDetail(
          orderId: 0,
          productId: item.productId,
          quantity: item.quantity,
          price: item.price ?? 0,
          customization: item.customization,
        );
      }).toList();

      await orderProvider.placeOrder(order, orderDetails);
      await cartProvider.clearCart(authProvider.customer!.id!);

      // Navigate to order tracking
      Navigator.pushNamed(context, AppRoutes.orderTracking);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to place order: $e'),
          backgroundColor: Colors.red.shade400,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      setState(() => _isPlacingOrder = false);
    }
  }

  @override
  void dispose() {
    _addressController.dispose();
    super.dispose();
  }
}
