import 'package:coffee_shop_app/utils/constants.dart';
import 'package:intl/intl.dart';

class Helpers {
  static String formatCurrency(double amount) {
    final formatter = NumberFormat.currency(
      symbol: AppConstants.currencySymbol,
      decimalDigits: 2,
    );
    return formatter.format(amount);
  }

  static String formatDate(DateTime date) {
    final formatter = DateFormat('yyyy-MM-dd');
    return formatter.format(date);
  }

  static String formatDateTime(DateTime dateTime) {
    final formatter = DateFormat('yyyy-MM-dd HH:mm');
    return formatter.format(dateTime);
  }

  static String formatTime(DateTime time) {
    final formatter = DateFormat('HH:mm');
    return formatter.format(time);
  }

  static String getInitials(String name) {
    List<String> parts = name.split(' ');
    if (parts.length >= 2) {
      return parts[0][0] + parts[1][0];
    } else if (parts.isNotEmpty) {
      return parts[0][0];
    }
    return '';
  }

  static String truncateText(String text, int maxLength) {
    if (text.length <= maxLength) {
      return text;
    }
    return '${text.substring(0, maxLength)}...';
  }
}