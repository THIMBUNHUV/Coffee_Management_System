import 'package:coffee_shop_app/models/order_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:coffee_shop_app/providers/order_provider.dart';
import 'package:coffee_shop_app/widgets/order_card.dart';
import 'package:coffee_shop_app/config/routes.dart';

class OrdersDashboardScreen extends StatefulWidget {
  const OrdersDashboardScreen({super.key});

  @override
  State<OrdersDashboardScreen> createState() => _OrdersDashboardScreenState();
}

class _OrdersDashboardScreenState extends State<OrdersDashboardScreen> {
  String _statusFilter = 'All';

  @override
  void initState() {
    super.initState();
    final orderProvider = Provider.of<OrderProvider>(context, listen: false);
    orderProvider.fetchOrders();
  }

  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<OrderProvider>(context);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    List<Order> filteredOrders = orderProvider.orders;
    if (_statusFilter != 'All') {
      filteredOrders = orderProvider.orders
          .where((order) => order.status == _statusFilter)
          .toList();
    }

    // Status colors mapping
    final statusColors = {
      'Preparing': Colors.orange,
      'Ready': Colors.green,
      'Delivered': Colors.blue,
    };

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: Column(
          children: [
            // Header Section (Updated to match previous screens)
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
                        'View Orders',
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
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: const Color(0xFF4A90E2),
                      shape: BoxShape.circle,
                    ),

                    child: Center(
                      child: Text(
                        '${filteredOrders.length}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Filter Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Container(
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
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: const Color(0xFF4A90E2).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.filter_list_rounded,
                          color: Color(0xFF4A90E2),
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'Status:',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF2C3E50),
                          fontFamily: 'Inter',
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: DropdownButton<String>(
                          value: _statusFilter,
                          isExpanded: true,
                          underline: const SizedBox(),
                          icon: const Icon(
                            Icons.arrow_drop_down_rounded,
                            color: Color(0xFF4A90E2),
                          ),
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF2C3E50),
                            fontFamily: 'Inter',
                          ),
                          items: ['All', 'Preparing', 'Ready', 'Delivered'].map(
                            (status) {
                              return DropdownMenuItem(
                                value: status,
                                child: Row(
                                  children: [
                                    if (status != 'All')
                                      Container(
                                        width: 8,
                                        height: 8,
                                        decoration: BoxDecoration(
                                          color: statusColors[status],
                                          shape: BoxShape.circle,
                                        ),
                                      )
                                    else
                                      Container(
                                        width: 8,
                                        height: 8,
                                        decoration: BoxDecoration(
                                          color: const Color(
                                            0xFF7F8C8D,
                                          ).withOpacity(0.5),
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                    const SizedBox(width: 12),
                                    Text(
                                      status,
                                      style: const TextStyle(
                                        fontFamily: 'Inter',
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ).toList(),
                          onChanged: (value) {
                            setState(() {
                              _statusFilter = value!;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Orders Count (Updated styling)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: Row(
                children: [
                  Text(
                    'Showing ${filteredOrders.length} ${filteredOrders.length == 1 ? 'order' : 'orders'}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF7F8C8D),
                      fontFamily: 'Inter',
                    ),
                  ),
                ],
              ),
            ),

            // Orders List
            Expanded(
              child: filteredOrders.isEmpty
                  ? Center(
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
                              Icons.receipt_long_rounded,
                              size: 50,
                              color: Color(0xFF4A90E2),
                            ),
                          ),
                          const SizedBox(height: 24),
                          Text(
                            _statusFilter == 'All'
                                ? 'No Orders Yet'
                                : 'No Orders Found',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2C3E50),
                              fontFamily: 'Poppins',
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _statusFilter == 'All'
                                ? 'When orders are placed, they will appear here'
                                : 'No orders with status "$_statusFilter"',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Color(0xFF7F8C8D),
                              fontFamily: 'Inter',
                            ),
                          ),
                          const SizedBox(height: 24),
                          if (_statusFilter != 'All')
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  _statusFilter = 'All';
                                });
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
                                'View All Orders',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Inter',
                                ),
                              ),
                            ),
                        ],
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: () async {
                        await orderProvider.fetchOrders();
                      },
                      child: ListView.separated(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        itemCount: filteredOrders.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final order = filteredOrders[index];
                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            child: OrderCard(
                              order: order,
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  AppRoutes.orderDetail,
                                  arguments: order,
                                );
                              },
                            ),
                          );
                        },
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
