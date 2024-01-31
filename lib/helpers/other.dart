import 'package:intl/intl.dart';

String formatCurrency(int value) {
  final formatter = NumberFormat('#,##,000', 'en_PK');
  return formatter.format(value);
}
