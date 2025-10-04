import 'package:vee_zee_coffee/config/routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vee_zee_coffee/providers/order_provider.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    final orderProvider = Provider.of<OrderProvider>(context, listen: false);
    orderProvider.fetchOrders();
  }

  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<OrderProvider>(context);

    double totalSales = orderProvider.orders.fold(
      0,
      (sum, order) => sum + order.totalPrice,
    );
    int totalOrders = orderProvider.orders.length;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome Section
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF4A90E2), Color(0xFF5D9CEC)],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF4A90E2).withOpacity(0.3),
                      blurRadius: 15,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Welcome Owner',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Here\'s your business overview',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white.withOpacity(0.9),
                        fontFamily: 'Inter',
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(
                          255,
                          255,
                          255,
                          255,
                        ).withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'Today • ${DateTime.now().toString().split(' ')[0]}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontFamily: 'Inter',
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Sales Overview Header
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  'Sales Overview',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2C3E50),
                    fontFamily: 'Poppins',
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Stats Cards
              Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      title: 'Total Sales',
                      value: '\$${totalSales.toStringAsFixed(2)}',
                      icon: Icons.attach_money_rounded,
                      color: const Color(0xFF27AE60),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildStatCard(
                      title: 'Total Orders',
                      value: totalOrders.toString(),
                      icon: Icons.shopping_bag_rounded,
                      color: const Color(0xFF3498DB),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 32),

              // Quick Actions Header
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  'Quick Actions',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2C3E50),
                    fontFamily: 'Poppins',
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Quick Actions Grid
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.0, // Changed to match EmployeeHomeScreen
                children: [
                  _buildActionCard(
                    title: 'View Orders',
                    icon: Icons.receipt_long_rounded,
                    color: const Color(0xFF4A90E2), // Blue
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFF4A90E2), Color(0xFF5D9CEC)],
                    ),
                    onTap: () {
                      Navigator.pushNamed(context, AppRoutes.ordersDashboard);
                    },
                    description: 'Manage customer orders',
                  ),

                  _buildActionCard(
                    title: 'View Accounts',
                    icon: Icons.group_rounded,
                    color: const Color(0xFFE74C3C), // Red
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFFE74C3C), Color(0xFFEC7063)],
                    ),
                    onTap: () {
                      Navigator.pushNamed(context, '/users');
                    },
                    description: 'Team members & roles',
                  ),

                  _buildActionCard(
                    title: 'Manage Products',
                    icon: Icons.inventory_2_rounded,
                    color: const Color(0xFF27AE60), // Green
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFF27AE60), Color(0xFF2ECC71)],
                    ),
                    onTap: () {
                      Navigator.pushNamed(context, AppRoutes.productManagement);
                    },
                    description: 'Update menu items',
                  ),
                  _buildActionCard(
                    title: 'Manage Purchases',
                    icon: Icons.shopping_cart_rounded,
                    color: const Color(0xFFE67E22), // Orange
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFFE67E22), Color(0xFFF39C12)],
                    ),
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        AppRoutes.purchaseManagement,
                      );
                    },
                    description: 'Handle inventory purchase',
                  ),
                  _buildActionCard(
                    title: 'Manage Employees',
                    icon: Icons.people_alt_rounded,
                    color: const Color(0xFF9B59B6), // Purple
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFF9B59B6), Color(0xFF8E44AD)],
                    ),
                    onTap: () =>
                        Navigator.pushNamed(context, '/employee-management'),
                    description: 'Manage staff members',
                  ),
                  _buildActionCard(
                    title: 'My Profile',
                    icon: Icons.person_rounded,
                    color: const Color(0xFF16A085), // Teal
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFF16A085), Color(0xFF1ABC9C)],
                    ),
                    onTap: () {
                      Navigator.pushNamed(context, AppRoutes.ownerProifle);
                    },
                    description: 'Your profile & settings',
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Recent Activity Section
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
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
                    const Row(
                      children: [
                        Icon(
                          Icons.timeline_rounded,
                          color: Color(0xFF4A90E2),
                          size: 20,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Recent Activity',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2C3E50),
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    if (orderProvider.orders.isEmpty)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        child: Text(
                          'No recent orders',
                          style: TextStyle(
                            color: Color(0xFF7F8C8D),
                            fontFamily: 'Inter',
                          ),
                        ),
                      )
                    else
                      Column(
                        children: orderProvider.orders
                            .take(3)
                            .map(
                              (order) => Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 8,
                                      height: 8,
                                      decoration: const BoxDecoration(
                                        color: Color(0xFF4A90E2),
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        'Order #${order.id} - \$${order.totalPrice.toStringAsFixed(2)}',
                                        style: const TextStyle(
                                          color: Color(0xFF2C3E50),
                                          fontFamily: 'Inter',
                                        ),
                                      ),
                                    ),
                                    Text(
                                      _formatDate(order.orderDate),
                                      style: const TextStyle(
                                        color: Color(0xFF7F8C8D),
                                        fontSize: 12,
                                        fontFamily: 'Inter',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                            .toList(),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
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
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, size: 20, color: color),
              ),
              const Spacer(),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF7F8C8D),
                  fontFamily: 'Inter',
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
              fontFamily: 'Poppins',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard({
    required String title,
    required IconData icon,
    required Color color,
    required Gradient gradient,
    required VoidCallback onTap,
    required String description,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      shadowColor: color.withOpacity(0.3),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        splashColor: color.withOpacity(0.1),
        highlightColor: color.withOpacity(0.05),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon Container with Gradient (like EmployeeHomeScreen)
              Container(
                width: 55,
                height: 55,
                decoration: BoxDecoration(
                  gradient: gradient,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: color.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(icon, size: 28, color: Colors.white),
              ),
              const SizedBox(height: 12),
              // Title
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF2C3E50),
                  fontFamily: 'Inter',
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              // Description
              Text(
                description,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 10,
                  color: const Color(0xFF7F8C8D),
                  height: 1.3,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Inter',
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return '${date.hour}:${date.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return dateString;
    }
  }
}
