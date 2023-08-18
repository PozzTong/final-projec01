import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<String> docIds = [];
  getDocId() async {
    await FirebaseFirestore.instance.collection('users').get().then((value) {
      value.docs.forEach((element) {
        setState(() {
          docIds.add(element.reference.id);
          print(element.reference.id);
        });
      });
    });
  }

  // Future getUsers(String docIds) async {
  //   final docProduct =
  //       FirebaseFirestore.instance.collection('users').doc(docIds);

  //   final snapshot = await docProduct.get();
  //   await docProduct.collection('users').doc(docIds).get();
  //   if (snapshot.exists) {
  //     return snapshot.data() as Map<String, dynamic>;
  //     // Lecture.fromJson(lect.data()!);
  //     // Student stu = Student.fromJson(snapshot.data()!);
  //     // stu.displayData();
  //     // print('Data:${snapshot.data()!}');
  //     // return Student.fromJson(snapshot.data()!);
  //   }
  //   return snapshot.data() as Map<String, dynamic>;
  // }

  @override
  void initState() {
    // TO DO: implement initState
    super.initState();
    getDocId();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home Screen')),
      body: ListView.builder(
          itemCount: docIds.length,
          itemBuilder: (context, index) {
            // return Card(
            //   child: ListTile(
            //     title: Text(docIds[index][0]),
            //   ),
            // );
            return FutureBuilder(
                // future: getUsers(docIds[index]),
                future: FirebaseFirestore.instance
                    .collection('users')
                    .doc(docIds[index])
                    .get(),
                builder: (context, snapshot) {
                  return snapshot.hasError
                      ? const Center(
                          child: Icon(
                            Icons.info,
                            color: Colors.red,
                          ),
                        )
                      : snapshot.connectionState == ConnectionState.waiting
                          ? const Center(
                              child: CircularProgressIndicator(),
                            )
                          : Card(
                              child: ListTile(
                                title: Text(snapshot.data!['name']),
                                subtitle: Text(snapshot.data!['age']),
                              ),
                            );
                });
          }
          //  => Card(
          //     child: ListTile(
          //   title: Text(docIds[index]),
          // )),
          ),
    );
  }
}
