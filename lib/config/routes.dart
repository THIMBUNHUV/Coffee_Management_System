import 'package:vee_zee_coffee/models/order_model.dart';
import 'package:vee_zee_coffee/models/product_model.dart';
import 'package:vee_zee_coffee/screens/auth/forget_password_screen.dart';
import 'package:vee_zee_coffee/screens/auth/reset_password_screen.dart';
import 'package:vee_zee_coffee/screens/debug/users_screen.dart';
import 'package:vee_zee_coffee/screens/employee/employee_profile_screen.dart';
import 'package:vee_zee_coffee/screens/owner/owner_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:vee_zee_coffee/screens/auth/login_screen.dart';
import 'package:vee_zee_coffee/screens/auth/register_screen.dart';
import 'package:vee_zee_coffee/screens/auth/splash_screen.dart';
import 'package:vee_zee_coffee/screens/customer/home_screen.dart';
import 'package:vee_zee_coffee/screens/customer/menu_screen.dart';
import 'package:vee_zee_coffee/screens/customer/coffee_detail_screen.dart';
import 'package:vee_zee_coffee/screens/customer/cart_screen.dart';
import 'package:vee_zee_coffee/screens/customer/checkout_screen.dart';
import 'package:vee_zee_coffee/screens/customer/delivery_screen.dart';
import 'package:vee_zee_coffee/screens/customer/payment_screen.dart';
import 'package:vee_zee_coffee/screens/customer/order_tracking_screen.dart';
import 'package:vee_zee_coffee/screens/customer/profile_screen.dart';
import 'package:vee_zee_coffee/screens/customer/favorites_screen.dart';
import 'package:vee_zee_coffee/screens/employee/employee_home_screen.dart';
import 'package:vee_zee_coffee/screens/employee/orders_dashboard_screen.dart';
import 'package:vee_zee_coffee/screens/employee/order_detail_screen.dart';
import 'package:vee_zee_coffee/screens/employee/product_management_screen.dart';
import 'package:vee_zee_coffee/screens/employee/purchase_management_screen.dart';
import 'package:vee_zee_coffee/screens/employee/receive_purchase_screen.dart';
import 'package:vee_zee_coffee/screens/owner/dashboard_screen.dart';
import 'package:vee_zee_coffee/screens/owner/employee_management_screen.dart';
import 'package:vee_zee_coffee/screens/owner/inventory_screen.dart';
import 'package:path/path.dart';

class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';
  static const String resetPassword = '/reset-password';
  static const String home = '/home';
  static const String menu = '/menu';
  static const String coffeeDetail = '/coffee-detail';
  static const String cart = '/cart';
  static const String checkout = '/checkout';
  static const String delivery = '/delivery';
  static const String payment = '/payment';
  static const String orderTracking = '/order-tracking';
  static const String profile = '/profile';
  static const String favorites = '/favorites';
  static const String employeeHome = '/employee-home';
  static const String employeeProfile = '/employee-profile';
  static const String ordersDashboard = '/orders-dashboard';
  static const String orderDetail = '/order-detail';
  static const String productManagement = '/product-management';
  static const String purchaseManagement = '/purchase-management';
  static const String receivePurchase = '/receive-purchase';
  static const String ownerDashboard = '/owner-dashboard';
  static const String ownerProifle = '/owner-proflie';
  static const String employeeManagement = '/employee-management';
  static const String ownerProductManagement = '/owner-product-management';
  static const String ownerOrders = '/owner-orders';
  static const String inventory = '/inventory';
  static const String users = '/users';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case register:
        return MaterialPageRoute(builder: (_) => const RegisterScreen());
      case forgotPassword:
        return MaterialPageRoute(builder: (_) => ForgotPasswordScreen());
      case resetPassword:
        return MaterialPageRoute(
          builder: (_) => ResetPasswordScreen(
            email: ModalRoute.of(context as BuildContext)!.settings.arguments as String? ?? '',
           
          ),
        );
      case home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case menu:
        return MaterialPageRoute(builder: (_) => const MenuScreen());
      case coffeeDetail:
        final product = settings.arguments as Product;
        return MaterialPageRoute(
          builder: (_) => CoffeeDetailScreen(product: product),
        );
      case cart:
        return MaterialPageRoute(builder: (_) => const CartScreen());
      case checkout:
        return MaterialPageRoute(builder: (_) => const CheckoutScreen());
      case users:
        return MaterialPageRoute(builder: (_) => const UsersScreen());
      case delivery:
        return MaterialPageRoute(builder: (_) => const DeliveryScreen());
      case payment:
        return MaterialPageRoute(builder: (_) => const PaymentScreen());
      case orderTracking:
        return MaterialPageRoute(builder: (_) => const OrderTrackingScreen());
      case profile:
        return MaterialPageRoute(builder: (_) => const ProfileScreen());
      case favorites:
        return MaterialPageRoute(builder: (_) => const FavoritesScreen());
      case employeeHome:
        return MaterialPageRoute(builder: (_) => const EmployeeHomeScreen());
      case employeeProfile:
        return MaterialPageRoute(builder: (_) => const EmployeeProfileScreen());
      case ordersDashboard:
        return MaterialPageRoute(builder: (_) => const OrdersDashboardScreen());
      case orderDetail:
        final order = settings.arguments as Order;
        return MaterialPageRoute(
          builder: (_) => OrderDetailScreen(order: order),
        );
      case productManagement:
        return MaterialPageRoute(
          builder: (_) => const ProductManagementScreen(),
        );
      case purchaseManagement:
        return MaterialPageRoute(
          builder: (_) => const PurchaseManagementScreen(),
        );
      case receivePurchase:
        return MaterialPageRoute(builder: (_) => const ReceivePurchaseScreen());
      case ownerDashboard:
        return MaterialPageRoute(builder: (_) => const DashboardScreen());
      case employeeManagement:
        return MaterialPageRoute(
          builder: (_) => const EmployeeManagementScreen(),
        );
      case ownerProifle:
        return MaterialPageRoute(builder: (_) => OwnerProfileScreen());
      case inventory:
        return MaterialPageRoute(builder: (_) => const InventoryScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}
