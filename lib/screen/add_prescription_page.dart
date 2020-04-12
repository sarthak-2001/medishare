import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:intl/intl.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:medishare/models/bought_product.dart';
import 'package:medishare/models/global_medicine.dart';
import 'package:medishare/models/sell_medicine.dart';
import 'package:medishare/models/user.dart';
import 'package:image_picker/image_picker.dart';
import 'package:medishare/screen/medicine_bought_page.dart';
import 'package:provider/provider.dart';
import 'package:search_page/search_page.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class AppPrescriptionPage extends StatefulWidget {
  final SellMedicine med;
  AppPrescriptionPage({this.med});
  @override
  _AppPrescriptionPageState createState() => _AppPrescriptionPageState();
}

class _AppPrescriptionPageState extends State<AppPrescriptionPage> {
  bool loading = false;
  File _image1;
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    var mail = user.email;

    List<SellMedicine> sellmedicine = Provider.of<List<SellMedicine>>(context);

    List<GlobalMedicine> globalmedicine =
        Provider.of<List<GlobalMedicine>>(context);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xff191919),
          title: Text('Add Prescription'),
          centerTitle: true,
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Upload your prescription which would be verified before you could purchase medicine',
                style: TextStyle(fontSize: 20),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: OutlineButton(
                borderSide:
                    BorderSide(color: Colors.grey.withOpacity(0.5), width: 2.5),
                onPressed: () {
                  _selectImage(
                      ImagePicker.pickImage(source: ImageSource.gallery), 1);
                },
                child: _displayChild1(),
              ),
            ),
            loading == true
                ? Center(child: CircularProgressIndicator())
                : RaisedButton(
                    child: Text('SUBMIT'),
                    onPressed: () async {
                      print('tap0');
//                                                      Navigator.pop(context);
                      if (_image1 == null) {
                        Fluttertoast.showToast(msg: 'Upload prescription');
                        return;
                      }
                      setState(() {
                        loading = true;
                      });

                      String imageUrl;
                      final String picture =
                          'prescription${user.email}_${DateTime.now().toIso8601String().toString()}';
                      final FirebaseStorage storage = FirebaseStorage.instance;

                      StorageUploadTask task = storage
                          .ref()
                          .child('/category')
                          .child(picture)
                          .putFile(_image1);

                      StorageTaskSnapshot snapshot =
                          await task.onComplete.then((snap) => snap);

                      imageUrl = await snapshot.ref.getDownloadURL();

                      print('pic updated');
                      Fluttertoast.showToast(msg: 'prescription sent');

                      BoughtMedicineService(email: mail)
                          .addBoughtMedicine(BoughtMedicine(
                        seller_med_ID: widget.med.ID,
                        buyer_email: Provider.of<User>(context).email,
                        seller_email: widget.med.seller_email,
                        med_name: widget.med.med_name,
                        med_qty: widget.med.med_qty,
                        med_price: widget.med.med_price,
                        seller_location: widget.med.seller_location,
                        verified: false,
                        payment_done: false,
                        prescription: imageUrl,
                        verified_by: '',
                      ));
                      Fluttertoast.showToast(msg: 'data stored');

                      setState(() {
                        loading = false;
                      });
                      _image1 = null;
                      Navigator.pop(context);
                    },
                  )
          ],
        ),
      ),
    );
  }

  void _selectImage(Future<File> pickImage, int imageNumber) async {
    File tempImg = await pickImage;
    setState(() => _image1 = tempImg);
  }

  Widget _displayChild1() {
    if (_image1 == null) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(14, 50, 14, 50),
        child: new Icon(
          Icons.add,
          color: Colors.grey,
        ),
      );
    } else {
      return Image.file(
        _image1,
        fit: BoxFit.cover,
        width: 200,
        height: 250,
      );
    }
  }
}
