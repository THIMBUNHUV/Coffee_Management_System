import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vee_zee_coffee/providers/purchase_provider.dart';

class ReceivePurchaseScreen extends StatefulWidget {
  const ReceivePurchaseScreen({super.key});

  @override
  State<ReceivePurchaseScreen> createState() => _ReceivePurchaseScreenState();
}

class _ReceivePurchaseScreenState extends State<ReceivePurchaseScreen> {
  @override
  Widget build(BuildContext context) {
    final purchaseProvider = Provider.of<PurchaseProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Receive Purchase')),
      body: purchaseProvider.purchases.isEmpty
          ? const Center(child: Text('No purchases to receive'))
          : ListView.builder(
              itemCount: purchaseProvider.purchases.length,
              itemBuilder: (context, index) {
                final purchase = purchaseProvider.purchases[index];
                return Card(
                  child: ListTile(
                    title: Text('Purchase #${purchase.id}'),
                    subtitle: Text(
                      '${purchase.supplierName} - \$${purchase.totalPrice.toStringAsFixed(2)}',
                    ),
                    trailing: ElevatedButton(
                      onPressed: () {
                        // Implement receive purchase logic
                      },
                      child: const Text('Receive'),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
