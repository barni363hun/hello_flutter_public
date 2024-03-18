import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class GetData extends StatelessWidget {
  final String documentId;
  GetData({required this.documentId});

  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection("data");
    return FutureBuilder<DocumentSnapshot>(
        future: users.doc(documentId).get(),
        builder: ((context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            Map<String, dynamic> data =
                snapshot.data!.data() as Map<String, dynamic>;
            return Text("${data['username']} - ${data['points']} second");
          }
          return const Text("loading...");
        }));
  }
}
