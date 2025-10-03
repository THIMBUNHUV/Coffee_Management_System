import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:coffee_shop_app/config/database_helper.dart';
import 'package:flutter/material.dart';
import 'package:coffee_shop_app/models/customer_model.dart';
import 'package:coffee_shop_app/models/employee_model.dart';
import 'package:coffee_shop_app/models/owner_model.dart';
import 'package:coffee_shop_app/services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  final DatabaseHelper _dbHelper = DatabaseHelper();

  // User data
  Customer? _customer;
  Employee? _employee;
  Owner? _owner;
  String? _userType;
  bool _isLoading = false;

  // Image data
  File? _employeeImage;
  File? _customerImage;
  File? _ownerImage;
  String? _customerImagePath;
  String? _employeeImagePath;
  String? _ownerImagePath;

  // ========== GETTERS ==========
  Customer? get customer => _customer;
  Employee? get employee => _employee;
  Owner? get owner => _owner;
  String? get userType => _userType;
  bool get isLoading => _isLoading;
  File? get employeeImage => _employeeImage;
  File? get customerImage => _customerImage;
  File? get ownerImage => _ownerImage;
  String? get customerImagePath => _customerImagePath;
  String? get employeeImagePath => _employeeImagePath;
  String? get ownerImagePath => _ownerImagePath;

  // ========== AUTHENTICATION METHODS ==========

  // Customer Authentication
  Future<bool> loginCustomer(String email, String password) async {
    _setLoading(true);
    try {
      _customer = await _authService.loginCustomer(email, password);
      _userType = 'customer';

      // Load customer image after login
      await _loadCustomerImage();

      _setLoading(false);
      return true;
    } catch (e) {
      _setLoading(false);
      return false;
    }
  }

  Future<bool> registerCustomer(Customer customer) async {
    _setLoading(true);
    try {
      await _authService.registerCustomer(customer);
      _setLoading(false);
      return true;
    } catch (e) {
      _setLoading(false);
      return false;
    }
  }

  // Employee Authentication
  Future<bool> loginEmployee(String email, String password) async {
    _setLoading(true);
    try {
      _employee = await _authService.loginEmployee(email, password);
      _userType = 'employee';

      // Load employee image after login
      await _loadEmployeeImage();

      _setLoading(false);
      return true;
    } catch (e) {
      _setLoading(false);
      return false;
    }
  }


  // ========== IMAGE MANAGEMENT ==========

  // Customer Image Methods
  Future<void> saveCustomerImage(File imageFile) async {
    try {
      if (_customer == null) return;

      // Copy image to app directory for persistence
      final appDir = await getApplicationDocumentsDirectory();
      final fileName =
          'customer_${_customer!.id}_profile_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final savedImage = await imageFile.copy('${appDir.path}/$fileName');

      // Save path to database
      await _dbHelper.updateCustomerProfileImage(
        _customer!.id!,
        savedImage.path,
      );

      // Update local state
      _customerImagePath = savedImage.path;
      _customerImage = savedImage;
      notifyListeners();
    } catch (e) {
      print('Error saving customer image: $e');
      rethrow;
    }
  }

  Future<void> _loadCustomerImage() async {
    if (_customer != null) {
      try {
        final imagePath = await _dbHelper.getCustomerProfileImage(
          _customer!.id!,
        );
        if (imagePath != null && await File(imagePath).exists()) {
          _customerImagePath = imagePath;
          _customerImage = File(imagePath);
          notifyListeners();
        }
      } catch (e) {
        print('Error loading customer image: $e');
      }
    }
  }

  Future<File?> getCustomerImageFile() async {
    if (_customerImagePath != null &&
        await File(_customerImagePath!).exists()) {
      return File(_customerImagePath!);
    }
    return null;
  }

  // Employee Image Methods
  Future<void> saveEmployeeImage(File imageFile) async {
    try {
      if (_employee == null) return;

      // Copy image to app directory for persistence
      final appDir = await getApplicationDocumentsDirectory();
      final fileName =
          'employee_${_employee!.id}_profile_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final savedImage = await imageFile.copy('${appDir.path}/$fileName');

      // Save path to database
      await _dbHelper.updateEmployeeProfileImage(
        _employee!.id!,
        savedImage.path,
      );

      // Update local state
      _employeeImagePath = savedImage.path;
      _employeeImage = savedImage;
      notifyListeners();
    } catch (e) {
      print('Error saving employee image: $e');
      rethrow;
    }
  }

  Future<void> _loadEmployeeImage() async {
    if (_employee != null) {
      try {
        final imagePath = await _dbHelper.getEmployeeProfileImage(
          _employee!.id!,
        );
        if (imagePath != null && await File(imagePath).exists()) {
          _employeeImagePath = imagePath;
          _employeeImage = File(imagePath);
          notifyListeners();
        }
      } catch (e) {
        print('Error loading employee image: $e');
      }
    }
  }

  Future<File?> getEmployeeImageFile() async {
    if (_employeeImagePath != null &&
        await File(_employeeImagePath!).exists()) {
      return File(_employeeImagePath!);
    }
    return null;
  }


  // Owner image management
  Future<void> saveOwnerImage(File imageFile) async {
    try {
      if (_owner == null) return;

      final appDir = await getApplicationDocumentsDirectory();
      final fileName = 'owner_${_owner!.id}_profile.jpg';
      final savedImage = await imageFile.copy('${appDir.path}/$fileName');

      await _dbHelper.updateOwnerProfileImage(_owner!.id!, savedImage.path);

      _ownerImagePath = savedImage.path;
      notifyListeners();
      print('✅ Owner image saved: ${savedImage.path}');
    } catch (e) {
      print('❌ Error saving owner image: $e');
      rethrow;
    }
  }

  Future<void> _loadOwnerImage() async {
    if (_owner != null) {
      try {
        final imagePath = await _dbHelper.getOwnerProfileImage(_owner!.id!);
        if (imagePath != null && await File(imagePath).exists()) {
          _ownerImagePath = imagePath;
          print('✅ Owner image loaded: $imagePath');
        } else {
          _ownerImagePath = null;
          print('ℹ️ No owner image found');
        }
        notifyListeners();
      } catch (e) {
        print('❌ Error loading owner image: $e');
        _ownerImagePath = null;
        notifyListeners();
      }
    }
  }

  Future<File?> getOwnerImageFile() async {
    if (_ownerImagePath != null && await File(_ownerImagePath!).exists()) {
      return File(_ownerImagePath!);
    }
    return null;
  }

  // Owner profile update
  Future<void> updateOwnerProfile(Owner updatedOwner) async {
    try {
      await _dbHelper.updateOwner(updatedOwner);
      _owner = updatedOwner;
      notifyListeners();
      print('✅ Owner profile updated');
    } catch (e) {
      print('❌ Error updating owner profile: $e');
      rethrow;
    }
  }

  // Add to loginOwner method to load image
  Future<bool> loginOwner(String email, String password) async {
    _setLoading(true);
    try {
      _owner = await _authService.loginOwner(email, password);
      _userType = 'owner';

      // Load owner image after login
      await _loadOwnerImage();

      _setLoading(false);
      print('✅ Owner logged in successfully');
      return true;
    } catch (e) {
      _setLoading(false);
      print('❌ Owner login failed: $e');
      return false;
    }
  }

  // Convenience image setters (for immediate UI updates)
  void setCustomerImage(File image) {
    _customerImage = image;
    notifyListeners();
  }

  void setEmployeeImage(File image) {
    _employeeImage = image;
    notifyListeners();
  }

  void setOwnerImage(File image) {
    _ownerImage = image;
    notifyListeners();
  }

  // ========== PROFILE UPDATE METHODS ==========

  Future<void> updateCustomerProfile(Customer updatedCustomer) async {
    try {
      // Update in database
      await _dbHelper.updateCustomer(updatedCustomer);

      // Update local state
      _customer = updatedCustomer;
      notifyListeners();
    } catch (e) {
      print('Error updating customer profile: $e');
      rethrow;
    }
  }

  Future<void> updateEmployeeProfile(Employee updatedEmployee) async {
    try {
      // Update in database
      await _dbHelper.updateEmployee(updatedEmployee);

      // Update local state
      _employee = updatedEmployee;
      notifyListeners();
    } catch (e) {
      print('Error updating employee profile: $e');
      rethrow;
    }
  }

  // ========== PASSWORD CHANGE METHODS ==========

  Future<bool> changeCustomerPassword(
    String currentPassword,
    String newPassword,
  ) async {
    try {
      if (_customer != null && _customer!.password == currentPassword) {
        final updatedCustomer = _customer!.copyWith(password: newPassword);
        await _dbHelper.updateCustomer(updatedCustomer);
        _customer = updatedCustomer;
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      print('Error changing customer password: $e');
      return false;
    }
  }

  Future<bool> changeEmployeePassword(
    String currentPassword,
    String newPassword,
  ) async {
    try {
      if (_employee != null && _employee!.password == currentPassword) {
        final updatedEmployee = _employee!.copyWith(password: newPassword);
        await _dbHelper.updateEmployee(updatedEmployee);
        _employee = updatedEmployee;
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      print('Error changing employee password: $e');
      return false;
    }
  }

  Future<bool> changeOwnerPassword(
    String currentPassword,
    String newPassword,
  ) async {
    try {
      if (_owner != null && _owner!.password == currentPassword) {
        final updatedOwner = _owner!.copyWith(password: newPassword);
        await _dbHelper.updateOwner(updatedOwner);
        _owner = updatedOwner;
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      print('Error changing owner password: $e');
      return false;
    }
  }

  // ========== UTILITY METHODS ==========

  // Check if user is logged in
  bool get isLoggedIn =>
      _customer != null || _employee != null || _owner != null;

  // Get current user name for display
  String get currentUserName {
    if (_customer != null) return _customer!.name;
    if (_employee != null) return _employee!.name;
    if (_owner != null) return _owner!.name;
    return 'Guest';
  }

  // Get current user email
  String get currentUserEmail {
    if (_customer != null) return _customer!.email;
    if (_employee != null) return _employee!.email;
    if (_owner != null) return _owner!.email;
    return '';
  }

  // Get user role for display
  String get userRole {
    if (_customer != null) return 'Customer';
    if (_employee != null) return _employee!.role;
    if (_owner != null) return 'Owner';
    return 'Guest';
  }

  // Get current user ID
  int? get currentUserId {
    if (_customer != null) return _customer!.id;
    if (_employee != null) return _employee!.id;
    if (_owner != null) return _owner!.id;
    return null;
  }

  // Check if user can access certain features based on role
  bool canAccessEmployeeFeatures() {
    return _employee != null || _owner != null;
  }

  bool canAccessOwnerFeatures() {
    return _owner != null;
  }

  // Check if profile is complete
  bool get isCustomerProfileComplete {
    if (_customer == null) return false;
    return _customer!.phone != null &&
        _customer!.phone!.isNotEmpty &&
        _customer!.address != null &&
        _customer!.address!.isNotEmpty;
  }

  bool get isEmployeeProfileComplete {
    if (_employee == null) return false;
    return _employee!.phone != null &&
        _employee!.phone!.isNotEmpty &&
        _employee!.address != null &&
        _employee!.address!.isNotEmpty;
  }

  bool get isOwnerProfileComplete {
    if (_owner == null) return false;
    return _owner!.phone != null &&
        _owner!.phone!.isNotEmpty &&
        _owner!.businessName != null &&
        _owner!.businessName!.isNotEmpty &&
        _owner!.businessAddress != null &&
        _owner!.businessAddress!.isNotEmpty;
  }

  // Get profile completion percentage
  double get profileCompletionPercentage {
    if (_customer != null) {
      int completedFields = 1; // Name is always present
      if (_customer!.phone != null && _customer!.phone!.isNotEmpty)
        completedFields++;
      if (_customer!.address != null && _customer!.address!.isNotEmpty)
        completedFields++;
      if (_customerImagePath != null) completedFields++;
      return completedFields / 4; // Total fields: name, phone, address, image
    }

    if (_employee != null) {
      int completedFields = 1; // Name is always present
      if (_employee!.phone != null && _employee!.phone!.isNotEmpty)
        completedFields++;
      if (_employee!.address != null && _employee!.address!.isNotEmpty)
        completedFields++;
      if (_employeeImagePath != null) completedFields++;
      return completedFields / 4;
    }

    if (_owner != null) {
      int completedFields = 1; // Name is always present
      if (_owner!.phone != null && _owner!.phone!.isNotEmpty) completedFields++;
      if (_owner!.businessName != null && _owner!.businessName!.isNotEmpty)
        completedFields++;
      if (_owner!.businessAddress != null &&
          _owner!.businessAddress!.isNotEmpty)
        completedFields++;
      if (_ownerImagePath != null) completedFields++;
      return completedFields /
          5; // Total fields: name, phone, businessName, businessAddress, image
    }

    return 0.0;
  }

  // ========== LOGOUT & CLEANUP ==========

  void logout() {
    _customer = null;
    _employee = null;
    _owner = null;
    _userType = null;
    _customerImage = null;
    _employeeImage = null;
    _ownerImage = null;
    _customerImagePath = null;
    _employeeImagePath = null;
    _ownerImagePath = null;
    notifyListeners();
  }

  // Clear image cache (useful for testing or cleanup)
  Future<void> clearImageCache() async {
    try {
      if (_customerImagePath != null &&
          await File(_customerImagePath!).exists()) {
        await File(_customerImagePath!).delete();
      }
      if (_employeeImagePath != null &&
          await File(_employeeImagePath!).exists()) {
        await File(_employeeImagePath!).delete();
      }
      if (_ownerImagePath != null && await File(_ownerImagePath!).exists()) {
        await File(_ownerImagePath!).delete();
      }
    } catch (e) {
      print('Error clearing image cache: $e');
    }
  }

  // Initialize provider (call this when app starts)
  Future<void> initialize() async {
    // You can add any initialization logic here
    // For example, auto-login from shared preferences
    print('AuthProvider initialized');
  }

  // Helper method to set loading state
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  // ========== VALIDATION METHODS ==========

  bool isValidEmail(String email) {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(email);
  }

  bool isValidPassword(String password) {
    return password.length >= 6;
  }

  bool isValidPhone(String phone) {
    final phoneRegex = RegExp(r'^[0-9]{10,15}$');
    return phoneRegex.hasMatch(phone.replaceAll(RegExp(r'[-\s]'), ''));
  }

  // ========== DEBUG METHODS ==========

  void printCurrentState() {
    print('=== AuthProvider State ===');
    print('User Type: $_userType');
    print('Customer: ${_customer?.name}');
    print('Employee: ${_employee?.name}');
    print('Owner: ${_owner?.name}');
    print('Customer Image Path: $_customerImagePath');
    print('Employee Image Path: $_employeeImagePath');
    print('Owner Image Path: $_ownerImagePath');
    print('Is Loading: $_isLoading');
    print('==========================');
  }

  // ========== SESSION MANAGEMENT ==========

  // Check if session is valid (you can add token validation here)
  bool get isSessionValid {
    // For now, just check if user data exists
    // You can add token expiration checks here
    return isLoggedIn;
  }

  // Get user type for navigation
  String get navigationUserType {
    if (_customer != null) return 'customer';
    if (_employee != null) return 'employee';
    if (_owner != null) return 'owner';
    return 'guest';
  }

  // Check if user has profile image
  bool get hasProfileImage {
    if (_customer != null) return _customerImagePath != null;
    if (_employee != null) return _employeeImagePath != null;
    if (_owner != null) return _ownerImagePath != null;
    return false;
  }

  // Get current profile image path
  String? get currentProfileImagePath {
    if (_customer != null) return _customerImagePath;
    if (_employee != null) return _employeeImagePath;
    if (_owner != null) return _ownerImagePath;
    return null;
  }

  // Get current profile image file
  Future<File?> get currentProfileImageFile async {
    if (_customer != null) return getCustomerImageFile();
    if (_employee != null) return getEmployeeImageFile();
    if (_owner != null) return getOwnerImageFile();
    return null;
  }

  // Save image for current user
  Future<void> saveCurrentUserImage(File imageFile) async {
    if (_customer != null) {
      await saveCustomerImage(imageFile);
    } else if (_employee != null) {
      await saveEmployeeImage(imageFile);
    } else if (_owner != null) {
      await saveOwnerImage(imageFile);
    }
  }

  // Update profile for current user
  Future<void> updateCurrentUserProfile(dynamic updatedUser) async {
    if (updatedUser is Customer) {
      await updateCustomerProfile(updatedUser);
    } else if (updatedUser is Employee) {
      await updateEmployeeProfile(updatedUser);
    } else if (updatedUser is Owner) {
      await updateOwnerProfile(updatedUser);
    }
  }

  // Change password for current user
  Future<bool> changeCurrentUserPassword(
    String currentPassword,
    String newPassword,
  ) async {
    if (_customer != null) {
      return await changeCustomerPassword(currentPassword, newPassword);
    } else if (_employee != null) {
      return await changeEmployeePassword(currentPassword, newPassword);
    } else if (_owner != null) {
      return await changeOwnerPassword(currentPassword, newPassword);
    }
    return false;
  }

  // Get current user model
  dynamic get currentUser {
    if (_customer != null) return _customer;
    if (_employee != null) return _employee;
    if (_owner != null) return _owner;
    return null;
  }
}
