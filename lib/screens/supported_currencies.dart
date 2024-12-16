import 'dart:convert';

import 'package:eproject/screens/main/bottom_bar.dart';
import 'package:eproject/utils/app_constant.dart';
import 'package:eproject/widgets/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class SupportedCurrenciesList extends StatefulWidget {
  const SupportedCurrenciesList({super.key});

  @override
  State<SupportedCurrenciesList> createState() =>
      _SupportedCurrenciesListState();
}

class _SupportedCurrenciesListState extends State<SupportedCurrenciesList> {
  List<dynamic> _currencies = [];
  List<dynamic> _filteredCurrencies = [];
  bool _isLoading = true;

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadCurrencies();
  }

  Future<void> _loadCurrencies() async {
    await Future.delayed(Duration(seconds: 2));
    final String jsonString = await DefaultAssetBundle.of(context)
        .loadString('countries.json');
    final List<dynamic> jsonData = json.decode(jsonString);

    setState(() {
      _currencies = jsonData;
      _filteredCurrencies = jsonData;
      _isLoading = false;
    });
  }

    void _filterCurrencies(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredCurrencies = _currencies;
      } else {
        _filteredCurrencies = _currencies.where((currency) {
          final code = currency['code'].toLowerCase();
          final country = currency['country'].toLowerCase();
          return code.contains(query.toLowerCase()) ||
              country.contains(query.toLowerCase());
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Bottom_Bar(
      child: Column(
        children: [
          const CustomAppBar(title: 'Supported Currencies'),
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(5),
            child: TextField(
              controller: _searchController,
              onChanged: _filterCurrencies,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: 'Search by code or country',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          Expanded(
            child: _isLoading
                ? _buildShimmerList()
                : _filteredCurrencies.isEmpty
                    ? Center(
                        child: Text(
                          'No country found',
                          style: TextStyle(fontSize: 18),
                        ),
                      )
                    : ListView.builder(
  itemCount: _filteredCurrencies.length, // Dynamically set the length
  itemBuilder: (context, index) {
    final currency = _filteredCurrencies[index];
    return ListTile(
      leading: Image.asset(
        currency['flag'],
        width: 40,
        height: 40,
        fit: BoxFit.cover,
      ),
      title: Text(currency['country']),
      subtitle: Text(currency['code']),
    );
  },
),
          ),
        ],
      ),
    );
  }

  Widget _buildShimmerList() {
    return ListView.builder(
      itemCount: _currencies.length > 0 ? _currencies.length : 10,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: AppConstant().shimmerEffectColor,
          highlightColor: Colors.grey[100]!,
          child: ListTile(
            leading: Container(
              width: 40,
              height: 40,
              color: AppConstant().shimmerEffectColor,
            ),
            title: Container(
              height: 10,
              width: double.infinity,
              color: AppConstant().shimmerEffectColor,
            ),
            subtitle: Container(
              height: 10,
              width: 100,
              color: AppConstant().shimmerEffectColor,
            ),
          ),
        );
      },
    );
  }
}