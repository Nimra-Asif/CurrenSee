import 'package:eproject/screens/main/bottom_bar.dart';
import 'package:eproject/utils/app_constant.dart';
import 'package:eproject/widgets/app_bar.dart';
import 'package:flutter/material.dart';

class FAQPage extends StatelessWidget {
  final List<Map<String, String>> faqs = [
    {
      'question': 'What is CurrenSee App?',
      'answer':
          'CurrenSee is a currency conversion app designed to provide real-time exchange rates, rate alerts, and financial news to users.'
    },
    {
      'question': 'How do I perform a currency conversion?',
      'answer':
          'Select your base currency and target currency, enter the amount, and the app will display the converted amount using real-time rates.'
    },
    {
      'question': 'What is a rate alert?',
      'answer':
          'A rate alert notifies you when the exchange rate for a specific currency pair reaches your desired value.'
    },
    {
      'question': 'Can I view historical exchange rates?',
      'answer':
          'Yes, historical exchange rate data and trends are available in the Exchange Rate Information section.'
    },
    {
      'question': 'Is my data secure?',
      'answer':
          'Yes, CurrenSee uses encryption and secure authentication to ensure your data is protected.'
    },
    {
      'question': 'How do I contact support?',
      'answer':
          'You can contact customer support through the Help Center in the app menu.'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Bottom_Bar(
        child: Scaffold(
      appBar: const CustomAppBar(title: 'Frequently Asked Questions'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: faqs.length,
          itemBuilder: (context, index) {
            return FAQItem(
              question: faqs[index]['question']!,
              answer: faqs[index]['answer']!,
            );
          },
        ),
      ),
    ));
  }
}

class FAQItem extends StatefulWidget {
  final String question;
  final String answer;

  FAQItem({required this.question, required this.answer});

  @override
  _FAQItemState createState() => _FAQItemState();
}

class _FAQItemState extends State<FAQItem> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppConstant().textColor,
      child: ExpansionTile(
        // backgroundColor: AppConstant().textColor,
        title: Text(
          widget.question,
          style: TextStyle(color: AppConstant().themeColor,fontSize: 15.0),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(widget.answer),
          ),
        ],
        onExpansionChanged: (bool expanded) {
          setState(() {
            isExpanded = expanded;
          });
        },
      ),
    );
  }
}
