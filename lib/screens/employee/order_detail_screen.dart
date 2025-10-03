import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:coffee_shop_app/providers/order_provider.dart';
import 'package:coffee_shop_app/models/order_model.dart';

class OrderDetailScreen extends StatefulWidget {
  final Order order;

  const OrderDetailScreen({super.key, required this.order});

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;

  @override
  void initState() {
    super.initState();
    final orderProvider = Provider.of<OrderProvider>(context, listen: false);
    orderProvider.fetchOrderDetails(widget.order.id!);
    
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    
    _slideAnimation = Tween<double>(begin: 50.0, end: 0.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutBack),
    );
    
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<OrderProvider>(context);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? Color(0xFF0F0F0F) : Color(0xFFFAFAFA),
      body: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return CustomScrollView(
            slivers: [
              // App Bar with Parallax Effect
              SliverAppBar(
                expandedHeight: 200,
                collapsedHeight: 80,
                floating: false,
                pinned: true,
                backgroundColor: Colors.transparent,
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          _getStatusColor(widget.order.status).withOpacity(0.8),
                          _getStatusColor(widget.order.status).withOpacity(0.4),
                        ],
                      ),
                    ),
                    child: Opacity(
                      opacity: _fadeAnimation.value,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Transform.translate(
                            offset: Offset(0, _slideAnimation.value),
                            child: Text(
                              'ORDER #${widget.order.id}',
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.w900,
                                color: Colors.white.withOpacity(0.9),
                                letterSpacing: 2,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                  title: Transform.translate(
                    offset: Offset(0, _slideAnimation.value * 0.5),
                    child: Text(
                      'Order Details',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        shadows: [
                          Shadow(blurRadius: 10, color: Colors.black.withOpacity(0.3))
                        ],
                      ),
                    ),
                  ),
                  titlePadding: const EdgeInsets.only(left: 20, bottom: 16),
                ),
              ),

              // Main Content
              SliverList(
                delegate: SliverChildListDelegate([
                  Transform.translate(
                    offset: Offset(0, _slideAnimation.value),
                    child: Opacity(
                      opacity: _fadeAnimation.value,
                      child: Column(
                        children: [
                          const SizedBox(height: 20),
                          
                          // Status Timeline
                          _buildStatusTimeline(widget.order.status, theme),
                          
                          const SizedBox(height: 30),
                          
                          // Order Summary Card
                          _buildOrderSummaryCard(theme, isDark),
                          
                          const SizedBox(height: 20),
                          
                          // Delivery Address Card
                          if (widget.order.deliveryAddress != null)
                            _buildAddressCard(theme, isDark),
                          
                          const SizedBox(height: 20),
                          
                          // Order Items Header
                          _buildItemsHeader(orderProvider, theme),
                          
                          const SizedBox(height: 10),
                          
                          // Order Items List
                          _buildOrderItemsList(orderProvider, theme, isDark),
                          
                          const SizedBox(height: 30),
                          
                          // Update Status Button
                          if (widget.order.status != 'Delivered')
                            _buildUpdateStatusButton(orderProvider, theme),
                          
                          const SizedBox(height: 40),
                        ],
                      ),
                    ),
                  ),
                ]),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildStatusTimeline(String status, ThemeData theme) {
    final steps = ['Preparing', 'Ready', 'Delivered'];
    final currentIndex = steps.indexOf(status);
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.primary.withOpacity(0.1),
            theme.colorScheme.secondary.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: theme.colorScheme.primary.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: steps.map((step) {
              final index = steps.indexOf(step);
              final isCompleted = index <= currentIndex;
              final isCurrent = index == currentIndex;
              
              return Expanded(
                child: Column(
                  children: [
                    // Step Circle
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: isCompleted ? _getStatusColor(step) : Colors.grey.withOpacity(0.3),
                        shape: BoxShape.circle,
                        border: isCurrent ? Border.all(color: _getStatusColor(step), width: 3) : null,
                        boxShadow: isCompleted ? [
                          BoxShadow(
                            color: _getStatusColor(step).withOpacity(0.4),
                            blurRadius: 8,
                            spreadRadius: 2,
                          )
                        ] : null,
                      ),
                      child: Icon(
                        _getStatusIcon(step),
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      step,
                      style: TextStyle(
                        fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
                        color: isCompleted ? _getStatusColor(step) : Colors.grey,
                        fontSize: 12,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
          
          // Progress Line
          Container(
            margin: const EdgeInsets.only(top: 20),
            height: 4,
            child: Stack(
              children: [
                // Background Line
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                // Progress Line
                AnimatedContainer(
                  duration: const Duration(milliseconds: 500),
                  width: (currentIndex + 1) / steps.length * MediaQuery.of(context).size.width - 80,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        _getStatusColor('Preparing'),
                        _getStatusColor('Ready'),
                        _getStatusColor('Delivered'),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderSummaryCard(ThemeData theme, bool isDark) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: isDark ? Color(0xFF1A1A1A) : Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          // Order Info Row
          // _buildInfoRow('Order Date', widget.order.orderDate, Icons.calendar_today_rounded, theme),
          _buildInfoRow('Order Date', _formatOrderDate(widget.order.orderDate), Icons.calendar_today_rounded, theme),
          const SizedBox(height: 15),
          _buildInfoRow('Total Amount', '\$${widget.order.totalPrice.toStringAsFixed(2)}', Icons.attach_money_rounded, theme),
          const SizedBox(height: 15),
          _buildInfoRow('Payment Status', 'Paid', Icons.payment_rounded, theme),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String title, String value, IconData icon, ThemeData theme) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 18, color: theme.colorScheme.primary),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              color: theme.colorScheme.onSurface.withOpacity(0.6),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
        ),
      ],
    );
  }

  Widget _buildAddressCard(ThemeData theme, bool isDark) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: isDark ? Color(0xFF1A1A1A) : Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.location_on_rounded, color: Colors.blue, size: 24),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Delivery Address',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurface.withOpacity(0.8),
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  widget.order.deliveryAddress!,
                  style: TextStyle(
                    color: theme.colorScheme.onSurface.withOpacity(0.6),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemsHeader(OrderProvider orderProvider, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Row(
        children: [
          Text(
            'Order Items',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(width: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              orderProvider.orderDetails.length.toString(),
              style: TextStyle(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderItemsList(OrderProvider orderProvider, ThemeData theme, bool isDark) {
    if (orderProvider.orderDetails.isEmpty) {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        padding: const EdgeInsets.all(40),
        child: Column(
          children: [
            Icon(Icons.coffee_rounded, size: 64, color: theme.colorScheme.onSurface.withOpacity(0.3)),
            const SizedBox(height: 16),
            Text(
              'Loading your coffee items...',
              style: TextStyle(
                color: theme.colorScheme.onSurface.withOpacity(0.5),
                fontSize: 16,
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: orderProvider.orderDetails.map((item) {
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: isDark ? Color(0xFF1A1A1A) : Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              leading: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      theme.colorScheme.primary.withOpacity(0.2),
                      theme.colorScheme.secondary.withOpacity(0.1),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Icon(Icons.coffee_rounded, color: theme.colorScheme.primary),
              ),
              title: Text(
                'Coffee Product #${item.productId}',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              subtitle: Text(
                'Quantity: ${item.quantity}',
                style: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.6)),
              ),
              trailing: Text(
                '\$${item.price.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                  color: Colors.brown,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildUpdateStatusButton(OrderProvider orderProvider, ThemeData theme) {
    final nextStatus = widget.order.status == 'Preparing' ? 'Ready' : 'Delivered';
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: ElevatedButton(
        onPressed: () async {
          await orderProvider.updateOrderStatus(widget.order.id!, nextStatus);
          if (mounted) Navigator.pop(context);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: _getStatusColor(nextStatus),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 24),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          elevation: 5,
          shadowColor: _getStatusColor(nextStatus).withOpacity(0.4),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(_getStatusIcon(nextStatus), size: 22),
            const SizedBox(width: 12),
            Text(
              _getButtonText(widget.order.status),
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Preparing': return Color(0xFFFF6B35);
      case 'Ready': return Color(0xFF00C853);
      case 'Delivered': return Color(0xFF2979FF);
      default: return Colors.grey;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'Preparing': return Icons.coffee_maker_rounded;
      case 'Ready': return Icons.emoji_food_beverage_rounded;
      case 'Delivered': return Icons.local_shipping_rounded;
      default: return Icons.pending_rounded;
    }
  }

  String _getButtonText(String currentStatus) {
    switch (currentStatus) {
      case 'Preparing': return 'Mark as Ready ☕';
      case 'Ready': return 'Mark as Delivered 🚚';
      default: return 'Update Status';
    }
  }

  String _formatOrderDate(String orderDate) {
    final DateTime dateTime = DateTime.parse(orderDate);
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    return formatter.format(dateTime);
  }
}