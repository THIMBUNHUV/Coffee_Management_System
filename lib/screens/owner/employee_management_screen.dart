import 'package:flutter/material.dart';
import 'package:vee_zee_coffee/models/employee_model.dart';
import 'package:vee_zee_coffee/config/database_helper.dart';

class EmployeeManagementScreen extends StatefulWidget {
  const EmployeeManagementScreen({super.key});

  @override
  State<EmployeeManagementScreen> createState() =>
      _EmployeeManagementScreenState();
}

class _EmployeeManagementScreenState extends State<EmployeeManagementScreen>
    with SingleTickerProviderStateMixin {
  List<Employee> _employees = [];
  List<Employee> _filteredEmployees = [];

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  bool _isLoading = true;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    // Initialize with empty lists to prevent null errors
    _employees = [];
    _filteredEmployees = [];

    _fetchEmployees();
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _fetchEmployees() async {
    if (mounted) {
      setState(() {
        _isLoading = true;
      });
    }

    try {
      final employees = await _databaseHelper.getEmployees();
      if (mounted) {
        setState(() {
          _employees = employees ?? [];
          _filteredEmployees = List.from(_employees);
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching employees: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
          _employees = [];
          _filteredEmployees = [];
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading employees: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _filterEmployees(String query) {
    if (!mounted) return;
    
    setState(() {
      if (query.isEmpty) {
        _filteredEmployees = List.from(_employees);
      } else {
        _filteredEmployees = _employees.where((employee) {
          return employee.name.toLowerCase().contains(query.toLowerCase()) ||
              employee.email.toLowerCase().contains(query.toLowerCase()) ||
              employee.role.toLowerCase().contains(query.toLowerCase());
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFD),
      appBar: AppBar(
        title: const Text(
          'Employee Management',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            color: Colors.white,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF4A90E2),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
      ),
      body: _isLoading
          ? _buildLoadingState()
          : FadeTransition(
              opacity: _fadeAnimation,
              child: Column(
                children: [
                  // Header Stats
                  _buildHeaderStats(),
                  const SizedBox(height: 16),

                  // Search Bar
                  _buildSearchBar(),
                  const SizedBox(height: 16),

                  // Employee List
                  Expanded(
                    child: _filteredEmployees.isEmpty
                        ? _buildEmptyState()
                        : Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: _buildEmployeeList(),
                          ),
                  ),
                ],
              ),
            ),
      floatingActionButton: ScaleTransition(
        scale: CurvedAnimation(
          parent: _animationController,
          curve: Curves.elasticOut,
        ),
        child: FloatingActionButton(
          onPressed: () {
            _showEmployeeDialog(context);
          },
          backgroundColor: const Color(0xFF4A90E2),
          elevation: 8,
          child: const Icon(Icons.add, color: Colors.white, size: 28),
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
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
            'Loading Employees...',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF2C3E50),
              fontFamily: 'Poppins',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderStats() {
    final baristaCount = _employees
        .where((e) => e.role.toLowerCase() == 'barista')
        .length;
    final managerCount = _employees
        .where((e) => e.role.toLowerCase() == 'manager')
        .length;
    final cashierCount = _employees
        .where((e) => e.role.toLowerCase() == 'cashier')
        .length;
    final serverCount = _employees
        .where((e) => e.role.toLowerCase() == 'server')
        .length;

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(
            value: _employees.length.toString(),
            label: 'Total',
            icon: Icons.people_alt_rounded,
            delay: 0,
          ),
          _buildStatItem(
            value: managerCount.toString(),
            label: 'Managers',
            icon: Icons.manage_accounts_rounded,
            delay: 100,
          ),
          _buildStatItem(
            value: baristaCount.toString(),
            label: 'Baristas',
            icon: Icons.coffee_rounded,
            delay: 200,
          ),
          _buildStatItem(
            value: cashierCount.toString(),
            label: 'Cashiers',
            icon: Icons.point_of_sale_rounded,
            delay: 300,
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required String value,
    required String label,
    required IconData icon,
    required int delay,
  }) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 500 + delay),
      curve: Curves.easeOutCubic,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.white, size: 22),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.white.withOpacity(0.9),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
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
          onChanged: _filterEmployees,
          decoration: InputDecoration(
            hintText: 'Search employees...',
            hintStyle: const TextStyle(color: Color(0xFF7F8C8D)),
            prefixIcon: const Icon(
              Icons.search_rounded,
              color: Color(0xFF4A90E2),
            ),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 16,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: const BorderSide(
                color: Color(0xFFE0E0E0),
                width: 1.5,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: const BorderSide(color: Color(0xFF4A90E2), width: 2),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmployeeList() {
    // Double safety check
    if (_filteredEmployees.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.builder(
      itemCount: _filteredEmployees.length,
      physics: const BouncingScrollPhysics(),
      itemBuilder: (context, index) {
        // Additional bounds checking
        if (index < 0 || index >= _filteredEmployees.length) {
          return const SizedBox.shrink();
        }

        final employee = _filteredEmployees[index];
        return AnimatedContainer(
          duration: Duration(milliseconds: 400 + (index * 100)),
          curve: Curves.easeOutCubic,
          margin: const EdgeInsets.only(bottom: 12),
          child: _buildEmployeeCard(employee, index),
        );
      },
    );
  }

  Widget _buildEmployeeCard(Employee employee, int index) {
    // Safe name initials
    String getInitials(String name) {
      try {
        final parts = name.split(' ');
        if (parts.length >= 2) {
          return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
        } else if (name.isNotEmpty) {
          return name[0].toUpperCase();
        }
        return '?';
      } catch (e) {
        return '?';
      }
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          _showEmployeeDetails(context, employee);
        },
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Avatar
                AnimatedContainer(
                  duration: const Duration(milliseconds: 500),
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    gradient: _getRoleGradient(employee.role),
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                        color: _getRoleColor(employee.role).withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      getInitials(employee.name),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),

                // Employee Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        employee.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 18,
                          color: Color(0xFF2C3E50),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Wrap(
                        spacing: 6,
                        runSpacing: 4,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: _getRoleColor(employee.role).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: _getRoleColor(employee.role).withOpacity(0.3),
                                width: 1,
                              ),
                            ),
                            child: Text(
                              employee.role,
                              style: TextStyle(
                                color: _getRoleColor(employee.role),
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          if (employee.salary != null)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.green.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: Colors.green.withOpacity(0.3),
                                  width: 1,
                                ),
                              ),
                              child: Text(
                                '\$${employee.salary!.toStringAsFixed(0)}',
                                style: const TextStyle(
                                  color: Colors.green,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      if (employee.email.isNotEmpty) ...[
                        Row(
                          children: [
                            Icon(
                              Icons.email_rounded,
                              size: 14,
                              color: const Color(0xFF7F8C8D),
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                employee.email,
                                style: TextStyle(
                                  color: const Color(0xFF7F8C8D),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                      if (employee.phone != null && employee.phone!.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              Icons.phone_rounded,
                              size: 14,
                              color: const Color(0xFF7F8C8D),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              employee.phone!,
                              style: TextStyle(
                                color: const Color(0xFF7F8C8D),
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),

                // Action Buttons - Stacked vertically
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildActionButton(
                      icon: Icons.edit_rounded,
                      color: const Color(0xFF4A90E2),
                      onPressed: () {
                        _showEmployeeDialog(context, employee: employee);
                      },
                    ),
                    const SizedBox(height: 6),
                    _buildActionButton(
                      icon: Icons.delete_rounded,
                      color: const Color(0xFFE74C3C),
                      onPressed: () {
                        _showDeleteConfirmation(context, employee, index);
                      },
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

  Widget _buildActionButton({
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: IconButton(
        icon: Icon(icon, size: 20, color: color),
        onPressed: onPressed,
        padding: EdgeInsets.zero,
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF4A90E2), Color(0xFF5D9CEC)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF4A90E2).withOpacity(0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: const Icon(
                Icons.people_alt_rounded,
                size: 70,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              'No Employees Yet',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: Color(0xFF2C3E50),
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Add your first team member to get started\nwith employee management',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF7F8C8D),
                fontSize: 14,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () {
                _showEmployeeDialog(context);
              },
              icon: const Icon(Icons.add_rounded),
              label: const Text(
                'Add First Employee',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4A90E2),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 4,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showEmployeeDetails(BuildContext context, Employee employee) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          margin: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 20,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    gradient: _getRoleGradient(employee.role),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      employee.name.split(' ').map((e) => e.isNotEmpty ? e[0] : '').join(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 24,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  employee.name,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF2C3E50),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: _getRoleColor(employee.role).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: _getRoleColor(employee.role).withOpacity(0.3),
                    ),
                  ),
                  child: Text(
                    employee.role,
                    style: TextStyle(
                      color: _getRoleColor(employee.role),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                _buildDetailItem(Icons.email_rounded, employee.email),
                _buildDetailItem(Icons.work_rounded, '${employee.role} Team'),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Close'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          _showEmployeeDialog(context, employee: employee);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF4A90E2),
                        ),
                        child: const Text('Edit'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDetailItem(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF4A90E2), size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(color: Color(0xFF7F8C8D)),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(
    BuildContext context,
    Employee employee,
    int index,
  ) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: const Color(0xFFE74C3C).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.warning_amber_rounded,
                  color: Color(0xFFE74C3C),
                  size: 30,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Delete Employee?',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF2C3E50),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Are you sure you want to remove "${employee.name}" from your team? This action cannot be undone.',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Color(0xFF7F8C8D), height: 1.5),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        try {
                          // Delete from database
                          await _databaseHelper.deleteEmployee(employee.id!);

                          // Refresh the list
                          await _fetchEmployees();

                          if (mounted) {
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  '${employee.name} has been removed',
                                ),
                                backgroundColor: const Color(0xFF27AE60),
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            );
                          }
                        } catch (e) {
                          if (mounted) {
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Error deleting employee: $e'),
                                backgroundColor: Colors.red,
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFE74C3C),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Delete',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getRoleColor(String role) {
    switch (role.toLowerCase()) {
      case 'manager':
        return const Color(0xFF9B59B6);
      case 'barista':
        return const Color(0xFFE67E22);
      case 'cashier':
        return const Color(0xFF3498DB);
      case 'server':
        return const Color(0xFF2ECC71);
      default:
        return const Color(0xFF95A5A6);
    }
  }

  Gradient _getRoleGradient(String role) {
    switch (role.toLowerCase()) {
      case 'manager':
        return const LinearGradient(
          colors: [Color(0xFF9B59B6), Color(0xFF8E44AD)],
        );
      case 'barista':
        return const LinearGradient(
          colors: [Color(0xFFE67E22), Color(0xFFD35400)],
        );
      case 'cashier':
        return const LinearGradient(
          colors: [Color(0xFF3498DB), Color(0xFF2980B9)],
        );
      case 'server':
        return const LinearGradient(
          colors: [Color(0xFF2ECC71), Color(0xFF27AE60)],
        );
      default:
        return const LinearGradient(
          colors: [Color(0xFF95A5A6), Color(0xFF7F8C8D)],
        );
    }
  }

  void _showEmployeeDialog(BuildContext context, {Employee? employee}) {
    final nameController = TextEditingController(text: employee?.name ?? '');
    final emailController = TextEditingController(text: employee?.email ?? '');
    final passwordController = TextEditingController(
      text: employee?.password ?? '',
    );
    final phoneController = TextEditingController(text: employee?.phone ?? '');
    final addressController = TextEditingController(
      text: employee?.address ?? '',
    );
    final salaryController = TextEditingController(
      text: employee?.salary?.toString() ?? '',
    );
    String selectedRole = employee?.role ?? 'Barista';

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xFF4A90E2).withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.person_add_rounded,
                          color: const Color(0xFF4A90E2),
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        employee == null ? 'Add Employee' : 'Edit Employee',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF2C3E50),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  _buildFormField(
                    controller: nameController,
                    label: 'Full Name',
                    icon: Icons.person_rounded,
                  ),
                  const SizedBox(height: 16),
                  _buildFormField(
                    controller: emailController,
                    label: 'Email Address',
                    icon: Icons.email_rounded,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 16),
                  _buildFormField(
                    controller: passwordController,
                    label: 'Password',
                    icon: Icons.lock_rounded,
                    obscureText: true,
                  ),
                  const SizedBox(height: 16),
                  _buildFormField(
                    controller: phoneController,
                    label: 'Phone Number',
                    icon: Icons.phone_rounded,
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 16),
                  _buildFormField(
                    controller: addressController,
                    label: 'Address',
                    icon: Icons.location_on_rounded,
                    maxLines: 2,
                  ),
                  const SizedBox(height: 16),
                  _buildFormField(
                    controller: salaryController,
                    label: 'Salary (\$)',
                    icon: Icons.attach_money_rounded,
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Role',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF2C3E50),
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFE0E0E0)),
                        ),
                        child: DropdownButtonFormField<String>(
                          value: selectedRole,
                          decoration: const InputDecoration(
                            prefixIcon: Icon(
                              Icons.work_rounded,
                              color: Color(0xFF4A90E2),
                            ),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 12,
                            ),
                          ),
                          items: ['Manager', 'Barista', 'Cashier', 'Server']
                              .map(
                                (role) => DropdownMenuItem(
                                  value: role,
                                  child: Text(
                                    role,
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                ),
                              )
                              .toList(),
                          onChanged: (value) {
                            if (value != null) {
                              setState(() {
                                selectedRole = value;
                              });
                            }
                          },
                          dropdownColor: Colors.white,
                          style: const TextStyle(color: Color(0xFF2C3E50)),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Cancel',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () async {
                            if (nameController.text.isEmpty ||
                                emailController.text.isEmpty ||
                                passwordController.text.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Please fill in all required fields',
                                  ),
                                  backgroundColor: Color(0xFFE74C3C),
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                              return;
                            }

                            try {
                              final newEmployee = Employee(
                                id: employee?.id,
                                name: nameController.text,
                                email: emailController.text,
                                password: passwordController.text,
                                role: selectedRole,
                                phone: phoneController.text.isNotEmpty
                                    ? phoneController.text
                                    : null,
                                address: addressController.text.isNotEmpty
                                    ? addressController.text
                                    : null,
                                salary: salaryController.text.isNotEmpty
                                    ? double.tryParse(salaryController.text)
                                    : null,
                              );

                              if (employee == null) {
                                await _databaseHelper.insertEmployee(
                                  newEmployee,
                                );
                              } else {
                                await _databaseHelper.updateEmployee(
                                  newEmployee,
                                );
                              }

                              await _fetchEmployees();
                              if (mounted) {
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Employee ${employee == null ? 'added' : 'updated'} successfully',
                                    ),
                                    backgroundColor: const Color(0xFF27AE60),
                                    behavior: SnackBarBehavior.floating,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                );
                              }
                            } catch (e) {
                              if (mounted) {
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Error saving employee: $e'),
                                    backgroundColor: Colors.red,
                                    behavior: SnackBarBehavior.floating,
                                  ),
                                );
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF4A90E2),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 2,
                          ),
                          child: const Text(
                            'Save',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
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
        );
      },
    );
  }

  Widget _buildFormField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: const Color(0xFF2C3E50),
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE0E0E0)),
          ),
          child: TextField(
            controller: controller,
            obscureText: obscureText,
            keyboardType: keyboardType,
            maxLines: maxLines,
            style: const TextStyle(color: Color(0xFF2C3E50)),
            decoration: InputDecoration(
              prefixIcon: Icon(icon, color: const Color(0xFF4A90E2)),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 14,
              ),
            ),
          ),
        ),
      ],
    );
  }
}