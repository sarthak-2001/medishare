import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:medishare/screen/chemist_verify_page.dart';
import 'package:medishare/screen/welcome_screen.dart';

class ChemistScreen extends StatefulWidget {
  ChemistScreen({this.email});
  final String email;
  @override
  _ChemistScreenState createState() => _ChemistScreenState();
}

class _ChemistScreenState extends State<ChemistScreen> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            leading: Container(),
            actions: <Widget>[
              RaisedButton(
                child: Text('SignOut'),
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                  Fluttertoast.showToast(msg: 'Signed Out');
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => WelcomeScreen()));
                },
              )
            ],
            title: Text('Prescriptions'),
            centerTitle: true,
          ),
          body: StreamBuilder(
            stream: Firestore.instance.collection('users').snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData)
                return Center(
                  child: CircularProgressIndicator(),
                );

              List users = snapshot.data.documents;
              return LimitedBox(
                maxHeight: double.infinity,
                child: ListView.builder(
                    itemCount: users.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          print('hola');
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ChemistVerifyPage(
                                        email: users[index].documentID,
                                      )));
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(width: 2),
                              borderRadius: BorderRadius.circular(7),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Text(
                                users[index].documentID,
                                style: TextStyle(fontSize: 24),
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
              );
            },
          ),
        ),
      ),
    );
  }
}
