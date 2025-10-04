import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vee_zee_coffee/config/routes.dart';
import 'package:vee_zee_coffee/config/theme.dart';
import 'package:vee_zee_coffee/config/database_helper.dart';
import 'package:provider/provider.dart';
import 'package:vee_zee_coffee/providers/auth_provider.dart';
import 'package:vee_zee_coffee/providers/cart_provider.dart';
import 'package:vee_zee_coffee/providers/order_provider.dart';
import 'package:vee_zee_coffee/providers/product_provider.dart';
import 'package:vee_zee_coffee/providers/purchase_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final authProvider = AuthProvider();
  await authProvider.initialize();

  // Check if it's the first run
  final prefs = await SharedPreferences.getInstance();
  final bool isFirstRun = prefs.getBool('isFirstRun') ?? true;

  if (isFirstRun) {
    // Clear the database on first run
    final dbHelper = DatabaseHelper();
    await dbHelper.clearDatabase();

    // Mark that the app has been run
    await prefs.setBool('isFirstRun', false);
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => OrderProvider()),
        ChangeNotifierProvider(create: (_) => ProductProvider()),     
        ChangeNotifierProvider(create: (_) => PurchaseProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Coffee App',
        theme: AppTheme.lightTheme,
        initialRoute: AppRoutes.splash,
        onGenerateRoute: AppRoutes.generateRoute,
      ),
    );
  }
}
