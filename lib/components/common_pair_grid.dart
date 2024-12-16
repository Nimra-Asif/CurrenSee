import 'package:flutter/material.dart';

class CommonPairsGrid extends StatelessWidget {
  const CommonPairsGrid({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final commonPairs = [
      {
        'base': 'USD',
        'target': 'EUR',
        'description': 'Most traded pair globally',
        'icon': Icons.euro_rounded,
      },
      {
        'base': 'USD',
        'target': 'PKR',
        'description': 'US Dollar to Pakistani Rupee',
        'icon': Icons.currency_exchange,
      },
      {
        'base': 'EUR',
        'target': 'GBP',
        'description': 'Major European pair',
        'icon': Icons.currency_pound,
      },
      {
        'base': 'USD',
        'target': 'JPY',
        'description': 'Major Asian pair',
        'icon': Icons.currency_yen,
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.5,
      ),
      itemCount: commonPairs.length,
      itemBuilder: (context, index) {
        final pair = commonPairs[index];
        return Card(
          child: InkWell(
            onTap: () {
              // Handle pair selection
            },
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(pair['icon'] as IconData, size: 32),
                  const SizedBox(height: 8),
                  Text(
                    '${pair['base']}/${pair['target']}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    pair['description'] as String,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}