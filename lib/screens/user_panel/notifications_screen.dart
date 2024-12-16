import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        backgroundColor: const Color.fromARGB(255, 153, 20, 171),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('rate_alerts')
            .where('uid', isEqualTo: user?.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Something went wrong'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final alerts = snapshot.data?.docs ?? [];

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: alerts.length,
            itemBuilder: (context, index) {
              final alert = alerts[index].data() as Map<String, dynamic>;
              final isEnabled = alert['isEnabled'] ?? true;

              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                child: ListTile(
                  title: Text(
                    '${alert['baseCurrency']}/${alert['targetCurrency']}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    'Target: ${alert['thresholdAmount']} (${alert['isAbove'] ? 'Above' : 'Below'})',
                  ),
                  trailing: Switch(
                    value: isEnabled,
                    onChanged: (value) {
                      FirebaseFirestore.instance
                          .collection('rate_alerts')
                          .doc(alerts[index].id)
                          .update({'isEnabled': value});
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}