import 'package:flutter/material.dart';
import 'package:coffee_shop_app/models/order_model.dart';
import 'package:coffee_shop_app/widgets/status_indicator.dart';

class OrderCard extends StatelessWidget {
  final Order order;
  final VoidCallback onTap;
  final bool showCustomer;

  const OrderCard({
    super.key,
    required this.order,
    required this.onTap,
    this.showCustomer = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(15),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Order #${order.id}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  StatusIndicator(status: order.status),
                ],
              ),
              const SizedBox(height: 5),
              if (showCustomer)
                Text(
                  'Customer ID: ${order.customerId}',
                  style: TextStyle(
                    color: Colors.grey[600],
                  ),
                ),
              const SizedBox(height: 5),
              Text(
                'Date: ${order.orderDate}',
                style: TextStyle(
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 5),
              if (order.deliveryAddress != null)
                Text(
                  'Delivery: ${order.deliveryAddress}',
                  style: TextStyle(
                    color: Colors.grey[600],
                  ),
                ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total:',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '\$${order.totalPrice.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.brown,
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
}