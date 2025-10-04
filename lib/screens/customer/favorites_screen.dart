import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vee_zee_coffee/providers/auth_provider.dart';
import 'package:vee_zee_coffee/providers/product_provider.dart';
import 'package:vee_zee_coffee/widgets/coffee_card.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  @override
  void initState() {
    super.initState();
    final productProvider = Provider.of<ProductProvider>(context, listen: false);
    productProvider.fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final productProvider = Provider.of<ProductProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Favorites'),
      ),
      body: productProvider.products.isEmpty
          ? const Center(child: Text('No favorites yet'))
          : GridView.builder(
              padding: const EdgeInsets.all(10),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.8,
              ),
              itemCount: productProvider.products.length,
              itemBuilder: (context, index) {
                final product = productProvider.products[index];
                return CoffeeCard(
                  product: product,
                  onTap: () {
                    // Navigate to product detail
                  },
                );
              },
            ),
    );
  }
}