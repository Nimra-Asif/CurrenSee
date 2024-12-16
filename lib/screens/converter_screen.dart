import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eproject/screens/main/bottom_bar.dart';
import 'package:eproject/screens/main/loader.dart';
import 'package:eproject/screens/main/snack_bar.dart';
import 'package:eproject/screens/slider.dart';
import 'package:eproject/utils/app_constant.dart';
import 'package:eproject/widgets/app_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:drop_down_search_field/drop_down_search_field.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/country_service.dart';
import '../services/exchange_rate_service.dart';
import '../models/country_model.dart';

class ConverterScreen extends StatefulWidget {
  @override
  _ConverterScreenState createState() => _ConverterScreenState();
}

class _ConverterScreenState extends State<ConverterScreen> {
  List<Country> countries = [];
  bool isLoading = true;
  bool isConverting = false;
  bool isLoggedIn = false;
  String? userName;
  String? baseCurrency;
  String? targetCurrency;
  String? targetSymbol;
  double amount = 1.0;
  double result = 0.0;
  double rate = 0.0;
  Map<String, double> exchangeRates = {};

  final TextEditingController baseCurrencyController = TextEditingController();
  final TextEditingController targetCurrencyController = TextEditingController();
  final TextEditingController amountController = TextEditingController();

  static const String PREF_BASE_CURRENCY = 'base_currency';

  @override
  void initState() {
    super.initState();
    loadData();
    _initializeUserData();
  }

  @override
  void dispose() {
    baseCurrencyController.dispose();
    targetCurrencyController.dispose();
    amountController.dispose();
    super.dispose();
  }

  Future<void> loadData() async {
    try {
      countries = await CountryService().fetchCountries();
      exchangeRates = await ExchangeRateService().fetchRates();
      await _loadStoredBaseCurrency();
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print("Error loading data: $e");
      CustomErrorSnackbar.show(context, 'Error loading data. Please try again.');
    }
  }

  Future<void> _loadStoredBaseCurrency() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? storedCurrency;
      
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // Try to get from Firestore first for logged-in users
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection("users")
            .doc(user.uid)
            .get();

        if (userDoc.exists) {
          storedCurrency = userDoc.get('setCurrencyPreference');
        }
      }
      
      // If no Firestore preference, try SharedPreferences
      if (storedCurrency == null || storedCurrency.isEmpty) {
        storedCurrency = prefs.getString(PREF_BASE_CURRENCY);
      }

      if (storedCurrency != null && storedCurrency.isNotEmpty) {
        setState(() {
          baseCurrency = storedCurrency!.toUpperCase();
          baseCurrencyController.text = storedCurrency.toUpperCase();
        });
      }
    } catch (e) {
      print("Error loading stored currency: $e");
    }
  }

  Future<void> _saveBaseCurrency(String currency) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString(PREF_BASE_CURRENCY, currency);
      
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // First check if document exists
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection("users")
            .doc(user.uid)
            .get();

        if (userDoc.exists) {
          // Update if document exists
          await FirebaseFirestore.instance
              .collection("users")
              .doc(user.uid)
              .update({'setCurrencyPreference': currency});
        } else {
          // Create if document doesn't exist
          await FirebaseFirestore.instance
              .collection("users")
              .doc(user.uid)
              .set({
                'setCurrencyPreference': currency,
                'email': user.email,
                'createdAt': FieldValue.serverTimestamp(),
              });
        }
      }
    } catch (e) {
      print("Error saving base currency: $e");
      CustomErrorSnackbar.show(context, 'Error saving currency preference.');
    }
  }

  Future<void> _initializeUserData() async {
    try {
      User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        setState(() {
          isLoggedIn = true;
          userName = prefs.getString('userName') ?? currentUser.email ?? 'User';
        });
      } else {
        setState(() {
          isLoggedIn = false;
          userName = null;
        });
      }
    } catch (e) {
      print("Error initializing user data: $e");
      setState(() {
        isLoggedIn = false;
        userName = null;
      });
    }
  }



  void calculateRate() {
    if (baseCurrency != null && targetCurrency != null) {
      final double baseRate = exchangeRates[baseCurrency!] ?? 1.0;
      final double targetRate = exchangeRates[targetCurrency!] ?? 1.0;
      setState(() {
        rate = targetRate / baseRate;
      });
    }
  }

  void switchCurrencies() {
    setState(() {
      final tempCurrency = baseCurrency;
      baseCurrency = targetCurrency;
      targetCurrency = tempCurrency;

      final tempText = baseCurrencyController.text;
      baseCurrencyController.text = targetCurrencyController.text;
      targetCurrencyController.text = tempText;

      if (baseCurrency != null) {
        _saveBaseCurrency(baseCurrency!);
      }
      calculateRate();
    });
  }

  Future<void> saveConversionHistory() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      final double parsedAmount = double.tryParse(amountController.text) ?? 0.0;
      if (parsedAmount <= 0) return;

      await FirebaseFirestore.instance.collection('conversion_history').add({
        'userId': user.uid,
        'username': userName ?? 'Unknown User',
        'fromCurrency': baseCurrencyController.text,
        'toCurrency': targetCurrencyController.text,
        'amount': parsedAmount,
        'result': result.toStringAsFixed(2),
        'rate': rate.toStringAsFixed(2),
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print("Error saving conversion history: $e");
    }
  }

  Future<void> handleConversion() async {
    if (baseCurrency == null || targetCurrency == null) {
      CustomErrorSnackbar.show(
        context,
        'Please select both currencies for conversion.',
      );
      return;
    }
    
    if (amountController.text.isEmpty) {
      CustomErrorSnackbar.show(
        context,
        'Please enter an amount to convert.',
      );
      return;
    }

    setState(() {
      isConverting = true;
    });

    try {
      calculateRate();
      
      if (amountController.text.isNotEmpty) {
        final double inputAmount = double.tryParse(amountController.text) ?? 0.0;
        setState(() {
          result = inputAmount * rate;
        });
        
        if (isLoggedIn) {
          await saveConversionHistory();
        }
      }
    } finally {
      setState(() {
        isConverting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Bottom_Bar(
      child: Scaffold(
        backgroundColor: AppConstant().textColor,
       appBar: const CustomAppBar(title: 'Convert Your Currency'),
        body: isLoading
            ? Center(child: Loader())
            : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        height: 250,
                        width: double.infinity,
                        child: Carousel(),
                      ),
                      SizedBox(height: 15.0),
                      Row(
                        children: [
                          Expanded(
                            child: DropDownSearchField(
                              textFieldConfiguration: TextFieldConfiguration(
                                controller: baseCurrencyController,
                                decoration: InputDecoration(
                                  labelText: "Base Currency",
                                  labelStyle: TextStyle(
                                    color: AppConstant().themeColor,
                                    fontSize: 14.0,
                                  ),
                                  border: OutlineInputBorder(),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: AppConstant().themeColor,
                                    ),
                                  ),
                                ),
                              ),
                              suggestionsCallback: (pattern) async {
                                return countries
                                    .where((c) =>
                                        c.country
                                            .toLowerCase()
                                            .contains(pattern.toLowerCase()) ||
                                        c.code
                                            .toLowerCase()
                                            .contains(pattern.toLowerCase()))
                                    .map((c) => {
                                          'name': c.country,
                                          'code': c.code,
                                          'flag': c.flag,
                                        })
                                    .toList();
                              },
                              itemBuilder: (context, suggestion) {
                                return ListTile(
                                  leading: Image.asset(
                                    suggestion['flag']!,
                                    width: 25,
                                    height: 15,
                                    fit: BoxFit.cover,
                                  ),
                                  title: Text(
                                    suggestion['name']!,
                                    style: TextStyle(fontSize: 14.0),
                                  ),
                                );
                              },
                              onSuggestionSelected: (suggestion) {
                                setState(() {
                                  baseCurrency = suggestion['code']!.toUpperCase();
                                  baseCurrencyController.text = suggestion['code']!;
                                });
                                _saveBaseCurrency(suggestion['code']!);
                                if (targetCurrency != null) {
                                  calculateRate();
                                }
                              },
                              displayAllSuggestionWhenTap: true,
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: IconButton(
                              onPressed: switchCurrencies,
                              icon: Icon(
                                Icons.swap_horiz,
                                size: 32,
                                color: AppConstant().themeColor,
                              ),
                            ),
                          ),
                          Expanded(
                            child: DropDownSearchField(
                              textFieldConfiguration: TextFieldConfiguration(
                                controller: targetCurrencyController,
                                decoration: InputDecoration(
                                  labelText: "Target Currency",
                                  labelStyle: TextStyle(
                                    color: AppConstant().themeColor,
                                    fontSize: 14.0,
                                  ),
                                  border: OutlineInputBorder(),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: AppConstant().themeColor,
                                    ),
                                  ),
                                ),
                              ),
                              suggestionsCallback: (pattern) async {
                                return countries
                                    .where((c) =>
                                        c.country
                                            .toLowerCase()
                                            .contains(pattern.toLowerCase()) ||
                                        c.code
                                            .toLowerCase()
                                            .contains(pattern.toLowerCase()))
                                    .map((c) => {
                                          'name': c.country,
                                          'code': c.code,
                                          'flag': c.flag,
                                        })
                                    .toList();
                              },
                              itemBuilder: (context, suggestion) {
                                return ListTile(
                                  leading: Image.asset(
                                    suggestion['flag']!,
                                    width: 25,
                                    height: 15,
                                    fit: BoxFit.cover,
                                  ),
                                  title: Text(
                                    suggestion['name']!,
                                    style: TextStyle(fontSize: 14.0),
                                  ),
                                );
                              },
                              onSuggestionSelected: (suggestion) {
                                setState(() {
                                  targetCurrency =
                                      suggestion['code']!.toUpperCase();
                                  targetSymbol = suggestion['code'];
                                  targetCurrencyController.text =
                                      suggestion['code']!;
                                });
                                if (baseCurrency != null) {
                                  calculateRate();
                                }
                              },
                              displayAllSuggestionWhenTap: true,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      if (rate > 0)
                        Column(
                          children: [
                            Text(
                              "1.00 ${baseCurrencyController.text} = ${rate.toStringAsFixed(6)} ${targetCurrencyController.text}",
                              style: TextStyle(
                                color: AppConstant().themeColor,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 3),
                            Text(
                              "1.00 ${targetCurrencyController.text} = ${(1 / rate).toStringAsFixed(6)} ${baseCurrencyController.text}",
                              style: TextStyle(
                                color: AppConstant().secondaryColor,
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        )
                      else
                        Text(
                          "Please select both currencies to see the exchange rates",
                          style: TextStyle(
                            color: AppConstant().secondaryColor,
                            fontSize: 14,
                          ),
                        ),
                      SizedBox(height: 10),
                      TextField(
                        controller: amountController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: "Enter Amount",
                          labelStyle: TextStyle(
                            color: AppConstant().themeColor,
                            fontSize: 14.0,
                          ),
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: AppConstant().themeColor,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: isConverting ? null : handleConversion,
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                            vertical: 15,
                            horizontal: 20,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: BorderSide(
                              color: AppConstant().themeColor,
                              width: 1,
                            ),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (isConverting)
                              SizedBox(
                                width: 14,
                                height: 14,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    AppConstant().themeColor,
                                  ),
                                ),
                              )
                            else
                              Icon(
                                Icons.currency_exchange,
                                color: AppConstant().themeColor,
                                size: 14,
                              ),
                            SizedBox(width: 8),
                            Text(
                              isConverting ? 'Converting...' : 'Convert',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppConstant().themeColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 16),
                      Text(
                        result == 0.0
                            ? "Converted Amount: --"
                            : "Converted Amount: ${result.toStringAsFixed(2)} ${targetCurrencyController.text}",
                        style: TextStyle(
                          color: AppConstant().themeColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}