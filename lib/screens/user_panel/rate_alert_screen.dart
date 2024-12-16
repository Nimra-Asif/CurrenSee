import 'package:eproject/components/common_pair_grid.dart';
import 'package:eproject/models/country_model.dart';
import 'package:eproject/screens/main/loader.dart';
import 'package:eproject/screens/main/snack_bar.dart';
import 'package:eproject/services/exchange_rate_service.dart';
import 'package:eproject/services/rate_monitor_service.dart';
import 'package:eproject/utils/app_constant.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:drop_down_search_field/drop_down_search_field.dart';


class RateAlertScreen extends StatefulWidget {
  const RateAlertScreen({Key? key}) : super(key: key);

  @override
  State<RateAlertScreen> createState() => _RateAlertScreenState();
}

class _RateAlertScreenState extends State<RateAlertScreen> {
  final _rateAlertService = RateAlertService();
  final _exchangeRateService = ExchangeRateService();
  
  List<Country> countries = [];
  String? baseCurrency;
  String? targetCurrency;
  String? targetSymbol;
  double? currentRate;
  double thresholdAmount = 0.0;
  bool isAbove = true;
  bool isLoading = false;

  final TextEditingController baseCurrencyController = TextEditingController();
  final TextEditingController targetCurrencyController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void switchCurrencies() {
    if (baseCurrency != null && targetCurrency != null) {
      setState(() {
        final tempCurrency = baseCurrency;
        final tempController = baseCurrencyController.text;
        
        baseCurrency = targetCurrency;
        baseCurrencyController.text = targetCurrencyController.text;
        
        targetCurrency = tempCurrency;
        targetCurrencyController.text = tempController;
      });
      calculateRate();
    }
  }

  Future<void> calculateRate() async {
    if (baseCurrency == null || targetCurrency == null) return;

    try {
      setState(() => isLoading = true);
      final rate = await _exchangeRateService.getRate(baseCurrency!, targetCurrency!);
      setState(() {
        currentRate = rate;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  Future<void> _saveAlert() async {
    if (!_formKey.currentState!.validate()) return;
    
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      Navigator.pushReplacementNamed(context, '/login');
      return;
    }

    if (baseCurrency == null || targetCurrency == null || thresholdAmount <= 0) {
      CustomErrorSnackbar.show(context, 'Please fill all fields');
      return;
    }

    try {
      setState(() => isLoading = true);
      await _rateAlertService.createRateAlert(
        uid: user.uid,
        baseCurrency: baseCurrency!,
        targetCurrency: targetCurrency!,
        thresholdAmount: thresholdAmount,
        isAbove: isAbove,
      );
      
      Navigator.pushReplacementNamed(context, '/manage-alerts');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Set Rate Alert'),
        backgroundColor: const Color.fromARGB(255, 153, 20, 171),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CommonPairsGrid(),
              const SizedBox(height: 24),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
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
                                if (targetCurrency != null) {
                                  calculateRate();
                                }
                              },
                              displayAllSuggestionWhenTap: true,
                            ),

                              ),
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: IconButton(
                                  onPressed: switchCurrencies,
                                  icon: const Icon(Icons.swap_horiz),
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
                                  // targetSymbol = suggestion['code'];
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
                          const SizedBox(height: 16),
                          if (baseCurrency != null && targetCurrency != null)
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              // child: Text(
                              //   "Current Rate: 1 $baseCurrency = ${exchangeRate.toStringAsFixed(4)} $targetCurrency",
                              //   style: const TextStyle(
                              //     fontSize: 16,
                              //     fontWeight: FontWeight.bold,
                              //   ),
                              // ),
                            ),
                          // const SizedBox(height: 16),
                          TextField(
                            // controller: con,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: "Target Rate",
                              hintText: "Enter your target exchange rate",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              prefixIcon: const Icon(Icons.trending_up),
                            ),
                            onChanged: (value) {
                              thresholdAmount = double.tryParse(value) ?? 0.0;
                            },
                          ),
                          const SizedBox(height: 16),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(8),
                            ),),
                      if (currentRate != null) ...[
                        const SizedBox(height: 16),
                        Text(
                          'Current Rate: 1 $baseCurrency = ${currentRate!.toStringAsFixed(4)} $targetCurrency',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                      const SizedBox(height: 16),
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Target Rate',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a target rate';
                          }
                          final rate = double.tryParse(value);
                          if (rate == null || rate <= 0) {
                            return 'Please enter a valid rate';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          thresholdAmount = double.tryParse(value) ?? 0.0;
                        },
                      ),
                      const SizedBox(height: 16),
                      SwitchListTile(
                        title: const Text('Alert Type'),
                        subtitle: Text(
                          isAbove ? 'Alert when above target' : 'Alert when below target',
                        ),
                        value: isAbove,
                        onChanged: (value) => setState(() => isAbove = value),
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: isLoading ? null : _saveAlert,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            backgroundColor: AppConstant().themeColor,
                          ),
                          child: isLoading
                              ? Loader()
                              : Text('Set Alert', style: TextStyle(color: AppConstant().textColor),),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}