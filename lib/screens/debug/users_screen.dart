import 'package:flutter/material.dart';
import 'package:vee_zee_coffee/config/database_helper.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen({super.key});

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  List<Map<String, dynamic>> customers = [];
  List<Map<String, dynamic>> employees = [];
  List<Map<String, dynamic>> owners = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  Future<void> _fetchUsers() async {
    final dbHelper = DatabaseHelper();
    final db = await dbHelper.database;

    final customerList = await db.query('tblCustomer');
    final employeeList = await db.query('tblEmployee');
    final ownerList = await db.query('tblOwner');

    setState(() {
      customers = customerList;
      employees = employeeList;
      owners = ownerList;
      isLoading = false;
    });
  }

  Future<void> _refreshUsers() async {
    setState(() {
      isLoading = true;
    });
    await _fetchUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
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
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back_ios_rounded, size: 20),
                      color: const Color(0xFF4A90E2),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    'User Accounts',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[900],
                    ),
                  ),
                  const Spacer(),
                  // Refresh button
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
                      onPressed: _refreshUsers,
                      icon: Icon(
                        Icons.refresh,
                        color: Colors.blue[600],
                        size: 20,
                      ),
                      tooltip: 'Refresh Users',
                    ),
                  ),
                ],
              ),
            ),

            // Content area
            Expanded(
              child: isLoading
                  ? const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(strokeWidth: 3),
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Loading users...',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: _refreshUsers,
                      child: SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Statistics Cards
                            _buildStatisticsCards(),
                            const SizedBox(height: 24),

                            // Customers Section
                            _buildUserSection(
                              title: 'Customers',
                              users: customers,
                              icon: Icons.person,
                              color: Colors.blue,
                              emptyMessage: 'No customers registered yet',
                            ),
                            const SizedBox(height: 24),

                            // Employees Section
                            _buildUserSection(
                              title: 'Employees',
                              users: employees,
                              icon: Icons.work,
                              color: Colors.orange,
                              emptyMessage: 'No employees registered yet',
                            ),
                            const SizedBox(height: 24),

                            // Owners Section
                            _buildUserSection(
                              title: 'Owners',
                              users: owners,
                              icon: Icons.business,
                              color: Colors.green,
                              emptyMessage: 'No owners registered yet',
                            ),
                            const SizedBox(height: 24),

                            // Test Accounts Info
                            _buildTestAccountsInfo(),
                            const SizedBox(height: 20),
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

  Widget _buildStatisticsCards() {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            title: 'Total Users',
            count: customers.length + employees.length + owners.length,
            color: Colors.blue[600]!,
            icon: Icons.people,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            title: 'Customers',
            count: customers.length,
            color: Colors.green[600]!,
            icon: Icons.person,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            title: 'Staff',
            count: employees.length + owners.length,
            color: Colors.orange[600]!,
            icon: Icons.work,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required String title,
    required int count,
    required Color color,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 16, color: color),
              ),
              const Spacer(),
              Text(
                count.toString(),
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserSection({
    required String title,
    required List<Map<String, dynamic>> users,
    required IconData icon,
    required Color color,
    required String emptyMessage,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(icon, size: 18, color: color),
                  const SizedBox(width: 8),
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                users.length.toString(),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (users.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Icon(Icons.people_outline, size: 40, color: Colors.grey[400]),
                const SizedBox(height: 8),
                Text(
                  emptyMessage,
                  style: TextStyle(color: Colors.grey[600], fontSize: 14),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          )
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: users.length,
            separatorBuilder: (context, index) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final user = users[index];
              return _buildUserCard(user, title, color);
            },
          ),
      ],
    );
  }

  Widget _buildUserCard(
    Map<String, dynamic> user,
    String userType,
    Color color,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(_getUserIcon(userType), color: color, size: 20),
        ),
        title: Text(
          user['name'] ?? 'Unknown Name',
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              user['email'] ?? 'No email',
              style: TextStyle(color: Colors.grey[600], fontSize: 14),
            ),
            if (userType == 'Employees' && user['role'] != null)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    user['role'] ?? '',
                    style: TextStyle(
                      color: color,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
          ],
        ),
        trailing: Icon(Icons.chevron_right, color: Colors.grey[400]),
      ),
    );
  }

  IconData _getUserIcon(String userType) {
    switch (userType) {
      case 'Customers':
        return Icons.person;
      case 'Employees':
        return Icons.work;
      case 'Owners':
        return Icons.business;
      default:
        return Icons.person;
    }
  }

  Widget _buildTestAccountsInfo() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.blue[50]!, Colors.blue[100]!],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.blue[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.blue[400],
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.info, color: Colors.white, size: 16),
              ),
              const SizedBox(width: 8),
              const Text(
                'Demo Accounts',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildDemoAccountItem(
            '👤 Customer',
            'bunhov1232@gmail.com',
            '12345678',
          ),
          const SizedBox(height: 8),
          _buildDemoAccountItem('👔 Employee', 'ratana@gmail.com', '12345678'),
          const SizedBox(height: 8),
          _buildDemoAccountItem('🏢 Owner', 'dara@gmail.com', '12345678'),
        ],
      ),
    );
  }

  Widget _buildDemoAccountItem(String role, String email, String password) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Role with colored badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: _getRoleColor(role),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              role.toUpperCase(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(height: 8),

          // Email
          Row(
            children: [
              Icon(Icons.email, size: 12, color: Colors.grey[600]),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  email,
                  style: TextStyle(
                    color: Colors.grey[800],
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 4),

          // Password
          Row(
            children: [
              Icon(Icons.lock, size: 12, color: Colors.grey[600]),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  password,
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 12,
                    fontFamily: 'RobotoMono',
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Helper method to get color based on role
  Color _getRoleColor(String role) {
    switch (role.toLowerCase()) {
      case 'customer':
        return Colors.blue[600]!;
      case 'employee':
        return Colors.orange[600]!;
      case 'owner':
        return Colors.green[600]!;
      default:
        return Colors.grey[600]!;
    }
  }
}
