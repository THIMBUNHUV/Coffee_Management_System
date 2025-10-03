import 'package:flutter/material.dart';

class StatusIndicator extends StatelessWidget {
  final String status;
  final double? fontSize;

  const StatusIndicator({super.key, required this.status, this.fontSize});

  @override
  Widget build(BuildContext context) {
    Color color;
    switch (status.toLowerCase()) {
      case 'preparing':
        color = Colors.orange;
        break;
      case 'ready':
        color = Colors.green;
        break;
      case 'delivered':
        color = Colors.blue;
        break;
      case 'pending':
        color = Colors.grey;
        break;
      case 'cancelled':
        color = Colors.red;
        break;
      default:
        color = Colors.brown;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: fontSize ?? 14,
        ),
      ),
    );
  }
}