// Copyright 2022 Google LLC
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import 'dart:async';
import 'package:authentication/src/get_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late StreamSubscription<User?> _userSubscription;
  late User _user;
  int _pointsEarned = 0;
  List<String> docIDs = [];
  String myDocId = '';
  int pb = 9223372036854775807;

  // void _incrementCounter() {
  //   setState(() {
  //     _counter++;
  //   });
  // }

  void _getData() async {
    docIDs.clear();
    await FirebaseFirestore.instance
        .collection("data")
        .orderBy("points", descending: false)
        .get()
        .then((value) => value.docs.forEach((element) {
              docIDs.add(element.reference.id);
              if (element["username"] == _user.displayName) {
                myDocId = element.reference.id;
                // print(myDocId);
                if (pb > element["points"]) {
                  pb = element["points"];
                }
              }
            }));
    // print(docIDs.length);
    setState(() {});
  }

  @override
  void initState() {
    _getData();

    super.initState();
    _user = FirebaseAuth.instance.currentUser!;

    // Detect when a user signs in or out
    _userSubscription = FirebaseAuth.instance.authStateChanges().listen((user) {
      if (mounted) {
        if (user != null) {
          setState(() {
            _user = FirebaseAuth.instance.currentUser!;
          });
        } else {
          setState(() {
            SchedulerBinding.instance.addPostFrameCallback((_) {
              Navigator.of(context).pushNamedAndRemoveUntil(
                '/',
                (_) => false,
              );
            });
          });
        }
      }
    });
  }

  @override
  void dispose() {
    _userSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: _user.displayName != null
            ? Text('Welcome ${_user.displayName}')
            : const Text('Welcome'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
                child: ListView.builder(
                    itemCount: docIDs.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: GetData(documentId: docIDs[index]),
                      );
                    })),
            if (_pointsEarned != 0)
              Column(
                children: [
                  const Text(
                    'Your points:',
                  ),
                  Text(
                    pointsEarnedString(),
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                ],
              ),
            // TextButton(
            //   onPressed: () async {},
            //   child: const Text('Save'),
            // ),
            TextButton(
              onPressed: _getData,
              child: const Text('Get leaderboard'),
            ),
            TextButton(
                onPressed: () async {
                  final res =
                      await Navigator.of(context).pushNamed('/unity') as int;
                  if (res != -1) {
                    setPoints(res);
                  } else {
                    setPoints(0);
                  }
                  _getData();
                },
                child: const Text("Play")),
            TextButton(
              onPressed: () async {
                await Navigator.of(context).pushNamed('/profile');
                if (!mounted) {
                  return;
                }
                if (FirebaseAuth.instance.currentUser != null) {
                  // Refresh the UI with a new user instance
                  // to catch any changes done in the profile screen
                  setState(() {
                    _user = FirebaseAuth.instance.currentUser!;
                  });
                }
              },
              child: const Text('Proflie Screen'),
            )
          ],
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: _incrementCounter,
      //   tooltip: 'Increment',
      //   child: const Icon(Icons.add),
      // ),
    );
  }

  void setPoints(int points) {
    _pointsEarned = points;
    // popUp("Setting points to: ",
    //     "$points docid len-mine: ${docIDs.length}$myDocId");
    if (points != 0) {
      if (!docIDs.contains(myDocId)) {
        FirebaseFirestore.instance
            .collection('data')
            .add({"username": _user.displayName, "points": points});
      } else if (pb > points) {
        FirebaseFirestore.instance
            .collection('data')
            .doc(myDocId)
            .set({"username": _user.displayName, "points": points});
      }
    }
  }

  String twoDigits(int n) => n.toString().padLeft(2, '0');

  String pointsEarnedString() {
    int minutes = _pointsEarned ~/ 60;
    int remainingSeconds = _pointsEarned % 60;
    String minutesStr = minutes.toString().padLeft(2, '0');
    String secondsStr = remainingSeconds.toString().padLeft(2, '0');
    return '$minutesStr:$secondsStr';
  }

  void popUp(String title, String content) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
