
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eproject/screens/main/bottom_bar.dart';
import 'package:eproject/screens/main/loader.dart';
import 'package:eproject/screens/main/snack_bar.dart';
import 'package:eproject/utils/app_constant.dart';
import 'package:eproject/widgets/app_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Bottom_Bar(child: 
    StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: Loader());
        }
        final user = snapshot.data;
        if (user == null) {
          return Scaffold(
           appBar: const CustomAppBar(title: 'Conversion History'),
            body: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "To save your Conversion history, you have to Login first!",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: AppConstant().secondaryColor,
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, '/login');
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            vertical: 15, horizontal: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        backgroundColor: AppConstant().themeColor,
                      ),
                      child: Text(
                        'Login Now',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppConstant().textColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        } else {
          return HistoryContent(userId: user.uid);
        }
      },
    ));
  }
}

class HistoryContent extends StatefulWidget {
  final String userId;
  const HistoryContent({super.key, required this.userId});

  @override
  State<HistoryContent> createState() => _HistoryContentState();
}

class _HistoryContentState extends State<HistoryContent> {
  @override
  Widget build(BuildContext context) {
    final historyCollection =
        FirebaseFirestore.instance.collection('conversion_history');

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppConstant().themeColor,
        title: Text(
          "Conversion History",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: AppConstant().textColor,
          ),
        ), centerTitle: true,
        actions: [
          StreamBuilder<QuerySnapshot>(
            stream: historyCollection
                .where('userId', isEqualTo: widget.userId)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                return IconButton(
                  icon: Icon(Icons.delete_forever, color: AppConstant().dangerColor),
                  onPressed: () async {
                    bool confirm = await showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title:  Text("Delete History", style: TextStyle(
                          color: AppConstant().dangerColor,
                        ),),
                        content: const Text(
                            "Are you sure you want to delete all your conversion history?"),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: const Text("Cancel"),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context, true),
                            child: const Text("OK"),
                          ),
                        ],
                      ),
                    );

                    if (confirm) {
                      try {
                        final snapshots = await historyCollection
                            .where('userId', isEqualTo: widget.userId)
                            .get();
                        for (var doc in snapshots.docs) {
                          await doc.reference.delete();
                        }
                        CustomErrorSnackbar.show(
                            context, "All conversion history deleted!");
                      } catch (e) {
                        CustomErrorSnackbar.show(
                            context, "An error occurred: $e");
                      }
                    }
                  },
                );
              }
              return const SizedBox.shrink(); // Hide button if no history exists
            },
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: historyCollection
            .where('userId', isEqualTo: widget.userId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: Loader());
          }
          if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
            final historyDocs = snapshot.data!.docs;

            return Stack(
              children: [
                Container(
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('/images/formBackground.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.purple.withOpacity(0.7),
                    Colors.purpleAccent.withOpacity(0.7),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
                ),
                ListView.builder(
                  itemCount: historyDocs.length,
                  itemBuilder: (context, index) {
                    final history =
                        historyDocs[index].data() as Map<String, dynamic>;
                    final docId = historyDocs[index].id;

                    return Card(
                      elevation: 4,
                      shadowColor: Colors.purple[200],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      margin: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 16),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    DateFormat('dd-MM-yyyy HH:mm').format(
                                        (history['timestamp'] as Timestamp)
                                            .toDate()),
                                    style:  TextStyle(
                                      fontSize: 14,
                                      color: AppConstant().secondaryColor,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "${history['fromCurrency']} to ${history['toCurrency']}",
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    "Rate: ${history['rate']} | Amount: ${history['amount']}",
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: AppConstant().secondaryColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  "${history['result']}",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: AppConstant().themeColor,
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete_outline,
                                      color: Colors.red[300]),
                                  onPressed: () async {
                                    try {
                                      await historyCollection.doc(docId).delete();
                                      CustomErrorSnackbar.show(context,
                                          'History has been deleted!');
                                    } catch (e) {
                                      CustomErrorSnackbar.show(
                                          context, 'An error occurred: $e');
                                    }
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            );
          }
          return const Center(
            child: Text("No Conversion History yet!"),
          );
        },
      ),
    );
  }
}