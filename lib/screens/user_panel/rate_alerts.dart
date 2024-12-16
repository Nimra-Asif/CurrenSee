// import 'dart:async';

// import 'package:drop_down_search_field/drop_down_search_field.dart';
// import 'package:eproject/controllers/rate_alerts.dart';
// import 'package:eproject/models/country_model.dart';
// import 'package:eproject/screens/main/snack_bar.dart';
// import 'package:eproject/services/country_service.dart';
// import 'package:eproject/services/exchange_rate_service.dart';
// import 'package:eproject/utils/app_constant.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:eproject/screens/main/loader.dart';
// import 'package:flutter/material.dart';

// class SetRateAlerts extends StatefulWidget {
//   const SetRateAlerts({Key? key}) : super(key: key);

//   @override
//   State<SetRateAlerts> createState() => _SetRateAlertsState();
// }

// class _SetRateAlertsState extends State<SetRateAlerts> {
//   // Variables
//   List<Country> countries = [];
//   Map<String, double> exchangeRates = {};
//   bool isLoading = true;
//   double rate = 0.0;
//   String? baseCurrency;
//   String? targetCurrency;
//   double thresholdAmount = 0.0;
//   bool isAbove = true;
//   double exchangeRate = 0.0;

//   final TextEditingController baseCurrencyController = TextEditingController();
//   final TextEditingController targetCurrencyController =
//       TextEditingController();
//   final TextEditingController thresholdController = TextEditingController();

//   final List<Map<String, dynamic>> commonPairs = [
//     {
//       'base': 'USD',
//       'target': 'EUR',
//       'description': 'Most traded currency pair globally',
//       'icon': Icons.euro_rounded,
//     },
//      {
//       'base': 'USD',
//       'target': 'PKR',
//       'description': 'US Dollar to Pakistani Rupee',
//       'icon': Icons.currency_exchange,
//     },
//     {
//       'base': 'EUR',
//       'target': 'GBP',
//       'description': 'Major European currency pair',
//       'icon': Icons.currency_pound,
//     },
//     {
//       'base': 'USD',
//       'target': 'JPY',
//       'description': 'Major Asian currency pair',
//       'icon': Icons.currency_yen,
//     },
//   ];
//  void initState() {
//     super.initState();
//     _updateCurrentRate();
//     // Update rate every 30 seconds
//     _rateUpdateTimer = Timer.periodic(const Duration(seconds: 30), (_) {
//       _updateCurrentRate();
//     });
//   }

//   @override
//   void dispose() {
//     _rateUpdateTimer?.cancel();
//     super.dispose();
//   }

//   Future<void> _updateCurrentRate() async {
//     if (baseCurrency != null && targetCurrency != null) {
//       final rate = await ExchangeRateService.getRatesForBase(baseCurrency!, targetCurrency!);
//       setState(() {
//         currentRate = rate;
//       });
//     }
//   }

//   bool _validateThresholdAmount(double amount) {
//     if (isAbove) {
//       return amount > currentRate;
//     } else {
//       return amount < currentRate;
//     }
//   }

//   void saveRateAlert() async {
//     final user = FirebaseAuth.instance.currentUser;
//     if (user == null) {
//       Navigator.pushReplacementNamed(context, '/login');
//       return;
//     }

//     if (baseCurrency == null || targetCurrency == null || thresholdAmount == 0.0) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('Please select currencies and enter a valid threshold amount'),
//           backgroundColor: Colors.red,
//         ),
//       );
//       return;
//     }

//     if (!_validateThresholdAmount(thresholdAmount)) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text(
//             isAbove 
//               ? 'Threshold amount must be higher than current rate (${currentRate.toStringAsFixed(2)})'
//               : 'Threshold amount must be lower than current rate (${currentRate.toStringAsFixed(2)})'
//           ),
//           backgroundColor: Colors.red,
//         ),
//       );
//       return;
//     }

//     // Save the alert
//     await RateAlerts.saveRateAlert(
//       uid: user.uid,
//       baseCurrency: baseCurrency!,
//       targetCurrency: targetCurrency!,
//       thresholdAmount: thresholdAmount,
//       isAbove: isAbove,
//     );

//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(
//         content: Text('Rate alert saved successfully!'),
//         backgroundColor: Colors.green,
//       ),
//     );
//   }

//     void calculateRate() {
//     if (baseCurrency != null && targetCurrency != null) {
//       final double baseRate = exchangeRates[baseCurrency!] ?? 1.0;
//       final double targetRate = exchangeRates[targetCurrency!] ?? 1.0;
//       setState(() {
//         rate = targetRate / baseRate;
//       });
//     }
//   }


//   @override
//   Widget build(BuildContext context) {
//      return Scaffold(
//       appBar: AppBar(
//         title: const Text("Set Rate Alerts"),
//         backgroundColor: const Color.fromARGB(255, 153, 20, 171),
//         actions: [
//           Stack(
//             children: [
//               IconButton(
//                 icon: const Icon(Icons.notifications),
//                 onPressed: () {
//                   // Navigate to notifications screen
//                 },
//               ),
//               Positioned(
//                 right: 8,
//                 top: 8,
//                 child: Container(
//                   padding: const EdgeInsets.all(2),
//                   decoration: BoxDecoration(
//                     color: Colors.red,
//                     borderRadius: BorderRadius.circular(6),
//                   ),
//                   constraints: const BoxConstraints(
//                     minWidth: 14,
//                     minHeight: 14,
//                   ),
//                   child: const Text(
//                     '0',
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 8,
//                     ),
//                     textAlign: TextAlign.center,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//       body: isLoading
//           ? const Center(child: Loader())
//           : SingleChildScrollView(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Text(
//                     'Popular Currency Pairs',
//                     style: TextStyle(
//                       fontSize: 20,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   const SizedBox(height: 16),
//                   SizedBox(
//                     height: 160,
//                     child: ListView.builder(
//                       scrollDirection: Axis.horizontal,
//                       itemCount: commonPairs.length,
//                       itemBuilder: (context, index) {
//                         final pair = commonPairs[index];
//                         return Card(
//                           margin: const EdgeInsets.only(right: 16),
//                           elevation: 4,
//                           child: Container(
//                             width: 200,
//                             padding: const EdgeInsets.all(16),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Row(
//                                   children: [
//                                     Icon(pair['icon'], size: 24),
//                                     const SizedBox(width: 8),
//                                     Text(
//                                       '${pair['base']}/${pair['target']}',
//                                       style: const TextStyle(
//                                         fontSize: 18,
//                                         fontWeight: FontWeight.bold,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                                 const SizedBox(height: 8),
//                                 Text(
//                                   pair['description'],
//                                   style: const TextStyle(
//                                     color: Colors.grey,
//                                   ),
//                                 ),
//                                 const Spacer(),
//                                 ElevatedButton(
//                                   onPressed: () {
//                                     setState(() {
//                                       baseCurrency = pair['base'];
//                                       targetCurrency = pair['target'];
//                                       baseCurrencyController.text = pair['base'];
//                                       targetCurrencyController.text = pair['target'];
//                                       calculateExchangeRate();
//                                     });
//                                   },
//                                   child: const Text('Use This Pair'),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         );
//                       },
//                     ),
//                   ),
//                   const SizedBox(height: 24),
//                   const Text(
//                     'Set Custom Alert',
//                     style: TextStyle(
//                       fontSize: 20,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   const SizedBox(height: 16),
//                   Card(
//                     elevation: 4,
//                     child: Padding(
//                       padding: const EdgeInsets.all(16.0),
//                       child: Column(
//                         children: [
//                           Row(
//                             children: [
//                               Expanded(
//                                   child: DropDownSearchField(
//                               textFieldConfiguration: TextFieldConfiguration(
//                                 controller: baseCurrencyController,
//                                 decoration: InputDecoration(
//                                   labelText: "Base Currency",
//                                   labelStyle: TextStyle(
//                                     color: AppConstant().themeColor,
//                                     fontSize: 14.0,
//                                   ),
//                                   border: OutlineInputBorder(),
//                                   focusedBorder: OutlineInputBorder(
//                                     borderSide: BorderSide(
//                                       color: AppConstant().themeColor,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                               suggestionsCallback: (pattern) async {
//                                 return countries
//                                     .where((c) =>
//                                         c.country
//                                             .toLowerCase()
//                                             .contains(pattern.toLowerCase()) ||
//                                         c.code
//                                             .toLowerCase()
//                                             .contains(pattern.toLowerCase()))
//                                     .map((c) => {
//                                           'name': c.country,
//                                           'code': c.code,
//                                           'flag': c.flag,
//                                         })
//                                     .toList();
//                               },
//                               itemBuilder: (context, suggestion) {
//                                 return ListTile(
//                                   leading: Image.asset(
//                                     suggestion['flag']!,
//                                     width: 25,
//                                     height: 15,
//                                     fit: BoxFit.cover,
//                                   ),
//                                   title: Text(
//                                     suggestion['name']!,
//                                     style: TextStyle(fontSize: 14.0),
//                                   ),
//                                 );
//                               },
//                               onSuggestionSelected: (suggestion) {
//                                 setState(() {
//                                   baseCurrency = suggestion['code']!.toUpperCase();
//                                   baseCurrencyController.text = suggestion['code']!;
//                                 });
//                                 if (targetCurrency != null) {
//                                   calculateRate();
//                                 }
//                               },
//                               displayAllSuggestionWhenTap: true,
//                             ),
                         
//                               ),
//                               Container(
//                                 padding: const EdgeInsets.all(8),
//                                 decoration: BoxDecoration(
//                                   color: Colors.grey[200],
//                                   borderRadius: BorderRadius.circular(8),
//                                 ),
//                                 child: IconButton(
//                                   onPressed: switchCurrencies,
//                                   icon: const Icon(Icons.swap_horiz),
//                                 ),
//                               ),
//                               Expanded(
//                                child: DropDownSearchField(
//                               textFieldConfiguration: TextFieldConfiguration(
//                                 controller: targetCurrencyController,
//                                 decoration: InputDecoration(
//                                   labelText: "Target Currency",
//                                   labelStyle: TextStyle(
//                                     color: AppConstant().themeColor,
//                                     fontSize: 14.0,
//                                   ),
//                                   border: OutlineInputBorder(),
//                                   focusedBorder: OutlineInputBorder(
//                                     borderSide: BorderSide(
//                                       color: AppConstant().themeColor,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                               suggestionsCallback: (pattern) async {
//                                 return countries
//                                     .where((c) =>
//                                         c.country
//                                             .toLowerCase()
//                                             .contains(pattern.toLowerCase()) ||
//                                         c.code
//                                             .toLowerCase()
//                                             .contains(pattern.toLowerCase()))
//                                     .map((c) => {
//                                           'name': c.country,
//                                           'code': c.code,
//                                           'flag': c.flag,
//                                         })
//                                     .toList();
//                               },
//                               itemBuilder: (context, suggestion) {
//                                 return ListTile(
//                                   leading: Image.asset(
//                                     suggestion['flag']!,
//                                     width: 25,
//                                     height: 15,
//                                     fit: BoxFit.cover,
//                                   ),
//                                   title: Text(
//                                     suggestion['name']!,
//                                     style: TextStyle(fontSize: 14.0),
//                                   ),
//                                 );
//                               },
//                               onSuggestionSelected: (suggestion) {
//                                 setState(() {
//                                   targetCurrency =
//                                       suggestion['code']!.toUpperCase();
//                                   // targetSymbol = suggestion['code'];
//                                   targetCurrencyController.text =
//                                       suggestion['code']!;
//                                 });
//                                 if (baseCurrency != null) {
//                                   calculateRate();
//                                 }
//                               },
//                               displayAllSuggestionWhenTap: true,
//                             ),
//                               ),
//                             ],
//                           ),
//                           const SizedBox(height: 16),
//                           if (baseCurrency != null && targetCurrency != null)
//                             Container(
//                               padding: const EdgeInsets.all(12),
//                               decoration: BoxDecoration(
//                                 color: Colors.grey[100],
//                                 borderRadius: BorderRadius.circular(8),
//                               ),
//                               child: Text(
//                                 "Current Rate: 1 $baseCurrency = ${exchangeRate.toStringAsFixed(4)} $targetCurrency",
//                                 style: const TextStyle(
//                                   fontSize: 16,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                             ),
//                           const SizedBox(height: 16),
//                           TextField(
//                             controller: thresholdController,
//                             keyboardType: TextInputType.number,
//                             decoration: InputDecoration(
//                               labelText: "Target Rate",
//                               hintText: "Enter your target exchange rate",
//                               border: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(8),
//                               ),
//                               prefixIcon: const Icon(Icons.trending_up),
//                             ),
//                             onChanged: (value) {
//                               thresholdAmount = double.tryParse(value) ?? 0.0;
//                             },
//                           ),
//                           const SizedBox(height: 16),
//                           Container(
//                             padding: const EdgeInsets.all(12),
//                             decoration: BoxDecoration(
//                               color: Colors.grey[100],
//                               borderRadius: BorderRadius.circular(8),
//                             ),
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     const Text(
//                                       "Notification Trigger",
//                                       style: TextStyle(
//                                         fontWeight: FontWeight.bold,
//                                       ),
//                                     ),
//                                     Text(
//                                       isAbove
//                                           ? "Alert when rate goes above target"
//                                           : "Alert when rate goes below target",
//                                       style: TextStyle(
//                                         color: Colors.grey[600],
//                                         fontSize: 12,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                                 Switch(
//                                   value: isAbove,
//                                   onChanged: (value) {
//                                     setState(() {
//                                       isAbove = value;
//                                     });
//                                   },
//                                   // activeColor: Colors.green,
//                                   // inactiveColor: Colors.red,
//                                 ),
//                               ],
//                             ),
//                           ),
//                           const SizedBox(height: 24),
//                           SizedBox(
//                             width: double.infinity,
//                             child: ElevatedButton(
//                               onPressed: () {
//                                 if (baseCurrency == null ||
//                                     targetCurrency == null ||
//                                     thresholdAmount <= 0) {
//                                   ScaffoldMessenger.of(context).showSnackBar(
//                                     const SnackBar(
//                                       content: Text(
//                                         'Please select currencies and enter a valid target rate',
//                                       ),
//                                       backgroundColor: Colors.red,
//                                     ),
//                                   );
//                                   return;
//                                 }
//                                 saveRateAlert();
//                               },
//                               style: ElevatedButton.styleFrom(
//                                 padding: const EdgeInsets.symmetric(vertical: 16),
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(8),
//                                 ),
//                                 backgroundColor:
//                                     const Color.fromARGB(255, 153, 20, 171),
//                               ),
//                               child: const Text(
//                                 "Set Alert",
//                                 style: TextStyle(
//                                   fontSize: 16,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//     );
//   }
// }