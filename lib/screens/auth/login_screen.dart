import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:coffee_shop_app/providers/auth_provider.dart';
import 'package:coffee_shop_app/config/routes.dart';
import 'package:coffee_shop_app/utils/validators.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String _userType = 'customer';
  bool _isLoading = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Back button and title
                const SizedBox(height: 40),

                // Welcome section
                Center(
                  child: Column(
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: Colors.blue[600],
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.blue.withOpacity(0.3),
                              blurRadius: 15,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.coffee,
                          size: 40,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Welcome Back',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[900],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Sign in to continue your coffee journey',
                        style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 40),

                // Login Form Card
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(24),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        // User Type Selection
                        _buildUserTypeSelector(),
                        const SizedBox(height: 20),

                        // Email Field
                        _buildTextField(
                          controller: _emailController,
                          label: 'Email Address',
                          icon: Icons.email_outlined,
                          validator: Validators.validateEmail,
                          keyboardType: TextInputType.emailAddress,
                        ),
                        const SizedBox(height: 20),

                        // Password Field
                        _buildPasswordField(),
                        const SizedBox(height: 10),

                        // Forgot Password
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: const Text(
                                    'Forgot password feature coming soon!',
                                  ),
                                  backgroundColor: Colors.blue[600],
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              );
                            },
                            child: Text(
                              'Forgot Password?',
                              style: TextStyle(
                                color: Colors.blue[600],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),

                        // Login Button
                        _buildLoginButton(),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                // Register Link
                Center(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, AppRoutes.register);
                    },
                    child: RichText(
                      text: TextSpan(
                        style: TextStyle(color: Colors.grey[600], fontSize: 15),
                        children: [
                          const TextSpan(text: "Don't have an account? "),
                          TextSpan(
                            text: 'Create Account',
                            style: TextStyle(
                              color: Colors.blue[600],
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                // Demo Accounts
                _buildTestAccountsInfo(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUserTypeSelector() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: DropdownButtonFormField<String>(
        value: _userType,
        isExpanded: true,
        icon: Icon(Icons.arrow_drop_down, color: Colors.grey[600]),
        style: TextStyle(color: Colors.grey[900], fontSize: 16),
        dropdownColor: Colors.white,
        items: [
          DropdownMenuItem(
            value: 'customer',
            child: Row(
              children: [
                Icon(Icons.person, color: Colors.blue[600], size: 20),
                const SizedBox(width: 12),
                const Text('Customer'),
              ],
            ),
          ),
          DropdownMenuItem(
            value: 'employee',
            child: Row(
              children: [
                Icon(Icons.work, color: Colors.orange[600], size: 20),
                const SizedBox(width: 12),
                const Text('Employee'),
              ],
            ),
          ),
          DropdownMenuItem(
            value: 'owner',
            child: Row(
              children: [
                Icon(Icons.business, color: Colors.green[600], size: 20),
                const SizedBox(width: 12),
                const Text('Owner'),
              ],
            ),
          ),
        ],
        onChanged: (value) {
          setState(() {
            _userType = value!;
          });
        },
        decoration: InputDecoration(
          labelText: 'Login as',
          labelStyle: TextStyle(color: Colors.grey[600], fontSize: 14),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please select a user type';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required String? Function(String?) validator,
    TextInputType? keyboardType,
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      keyboardType: keyboardType,
      style: TextStyle(color: Colors.grey[900], fontSize: 16),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.grey[600], fontSize: 14),
        prefixIcon: Icon(icon, color: Colors.grey[500]),
        filled: true,
        fillColor: Colors.grey[50],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[200]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.blue[400]!),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red),
        ),
      ),
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      controller: _passwordController,
      obscureText: _obscurePassword,
      validator: Validators.validatePassword,
      style: TextStyle(color: Colors.grey[900], fontSize: 16),
      decoration: InputDecoration(
        labelText: 'Password',
        labelStyle: TextStyle(color: Colors.grey[600], fontSize: 14),
        prefixIcon: Icon(Icons.lock_outline, color: Colors.grey[500]),
        suffixIcon: IconButton(
          icon: Icon(
            _obscurePassword
                ? Icons.visibility_off_outlined
                : Icons.visibility_outlined,
            color: Colors.grey[500],

            size: 20,
          ),
          onPressed: () {
            setState(() {
              _obscurePassword = !_obscurePassword;
            });
          },
        ),
        filled: true,
        fillColor: Colors.grey[50],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[200]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.blue[400]!),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red),
        ),
      ),
    );
  }

  Widget _buildLoginButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: _isLoading
          ? Container(
              decoration: BoxDecoration(
                color: Colors.blue[400],
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
              ),
            )
          : ElevatedButton(
              onPressed: _performLogin,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[600],
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text(
                'Sign In',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
    );
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

  Future<void> _performLogin() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        bool success = false;
        final authProvider = Provider.of<AuthProvider>(context, listen: false);

        if (_userType == 'customer') {
          success = await authProvider.loginCustomer(
            _emailController.text,
            _passwordController.text,
          );
        } else if (_userType == 'employee') {
          success = await authProvider.loginEmployee(
            _emailController.text,
            _passwordController.text,
          );
        } else if (_userType == 'owner') {
          success = await authProvider.loginOwner(
            _emailController.text,
            _passwordController.text,
          );
        }

        setState(() {
          _isLoading = false;
        });

        if (success && mounted) {
          _navigateAfterLogin();
        } else {
          _showErrorSnackBar();
        }
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
        _showErrorSnackBar(error: e.toString());
      }
    }
  }

  void _navigateAfterLogin() {
    String route = AppRoutes.home;
    if (_userType == 'employee') {
      route = AppRoutes.employeeHome;
    } else if (_userType == 'owner') {
      route = AppRoutes.ownerDashboard;
    }
    Navigator.pushReplacementNamed(context, route);
  }

  void _showErrorSnackBar({String? error}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(error ?? 'Login failed. Please check your credentials.'),
        backgroundColor: Colors.red[600],
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}
