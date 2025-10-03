import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:coffee_shop_app/providers/purchase_provider.dart';

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({super.key});

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  @override
  void initState() {
    super.initState();
    final purchaseProvider = Provider.of<PurchaseProvider>(context, listen: false);
    purchaseProvider.fetchPurchases();
  }

  @override
  Widget build(BuildContext context) {
    final purchaseProvider = Provider.of<PurchaseProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Inventory'),
      ),
      body: purchaseProvider.purchases.isEmpty
          ? const Center(child: Text('No inventory data'))
          : ListView.builder(
              itemCount: purchaseProvider.purchases.length,
              itemBuilder: (context, index) {
                final purchase = purchaseProvider.purchases[index];
                return Card(
                  child: ListTile(
                    title: Text('Purchase #${purchase.id}'),
                    subtitle: Text('${purchase.supplierName} - \$${purchase.totalPrice.toStringAsFixed(2)}'),
                  ),
                );
              },
            ),
    );
  }
}