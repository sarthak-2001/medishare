import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ChemistVerifyPage extends StatefulWidget {
  final String email;
  ChemistVerifyPage({this.email});
  @override
  _ChemistVerifyPageState createState() => _ChemistVerifyPageState();
}

class _ChemistVerifyPageState extends State<ChemistVerifyPage> {
  Firestore _firestore = Firestore.instance;
  String ref = 'users';
  String ref1 = 'bought_medicine';
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Verify'),
          centerTitle: true,
        ),
        body: StreamBuilder(
          stream: _firestore
              .collection(ref)
              .document(widget.email)
              .collection(ref1)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData || snapshot.data.documents.length == 0)
              return Center(
                child: Text(
                  'No requests',
                  style: TextStyle(fontSize: 20),
                ),
              );

            List req = snapshot.data.documents;
            return LimitedBox(
              maxHeight: MediaQuery.of(context).size.height * 0.8,
              child: ListView.builder(
                  itemCount: req.length,
                  itemBuilder: (context, index) {
                    return Visibility(
                      visible: req[index]['verified'] == false,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            height: 300,
                            width: double.infinity,
                            child: CachedNetworkImage(
                              placeholder: (context, url) => Center(
                                child: Container(
                                  height: 30,
                                  width: 30,
                                  child: CircularProgressIndicator(),
                                ),
                              ),
                              imageUrl: req[index]['prescription'],
                              fit: BoxFit.fitHeight,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  'Buyer: ${req[index]['buyer_email']}',
                                  style: TextStyle(fontSize: 20),
                                ),
                                SizedBox(
                                  height: 4,
                                ),
                                Text(
                                  'Medicine: ${req[index]['med_name']}',
                                  style: TextStyle(fontSize: 20),
                                ),
                                SizedBox(
                                  height: 4,
                                ),
                                Text(
                                  'Quantitiy: ${req[index]['med_qty']}',
                                  style: TextStyle(fontSize: 20),
                                ),
                                Center(
                                  child: RaisedButton(
                                    child: Text('APPROVE'),
                                    onPressed: () async {
                                      _firestore
                                          .collection(ref)
                                          .document(widget.email)
                                          .collection(ref1)
                                          .document(req[index].documentID)
                                          .updateData({
                                        'verified': true,
                                      });
                                      Fluttertoast.showToast(
                                          msg: 'Verified',
                                          toastLength: Toast.LENGTH_LONG);
                                    },
                                  ),
                                ),
                                Divider(
                                  thickness: 2,
                                  color: Colors.white,
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    );
                  }),
            );
          },
        ),
      ),
    );
  }
}
