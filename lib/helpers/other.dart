import 'package:intl/intl.dart';

String formatCurrency(int value) {
  final formatter = NumberFormat('#,##,000', 'en_PK');
  return formatter.format(value);
}

// Expected results
// int amount = 765200;
// String formattedAmount = formatAmount(amount);
// String formattedCurrency = formatCurrency(amount);
//
// print(formattedAmount);   // Output: 7,65,200.00
// print(formattedCurrency); // Output: Rs.7,65,200.00

// OLD APPROACH
// String formatCurrency(int value) {
//   return NumberFormat.simpleCurrency(locale: 'en_PK', name: 'PKR').format(value);
// }
//
// String formatAmount(int value) {
//   String amountString = value.toString();
//   String formattedAmount = '';
//
//   int decimalIndex = amountString.length - 2; // Index of the decimal point
//
//   for (int i = amountString.length - 1; i >= 0; i--) {
//     formattedAmount = amountString[i] + formattedAmount;
//
//     if (i == decimalIndex) {
//       formattedAmount = '.' + formattedAmount;
//       decimalIndex -= 3; // Skip 3 digits for comma placement
//     } else if ((amountString.length - i) % 3 == 0 && i != 0) {
//       formattedAmount = ',' + formattedAmount;
//     }
//   }
//
//   return formattedAmount;
// }
//
// class NumberFormat {
//   Pattern? get formattedAmount => null;
//
//   static NumberFormat simpleCurrency({String? locale, String? name}) {
//     return NumberFormat();
//   }
//   String format(int value) {
//     return '\Rs.${value.toString().replaceAllMapped(
//         formattedAmount!, (Match m) => '${m[1]},')}';
//   }
// }
//
