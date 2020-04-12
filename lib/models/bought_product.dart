import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class BoughtMedicine {
  final String buyer_email,
      ID,
      seller_med_ID,
      seller_email,
      med_name,
      verified_by,
      prescription;
  final int med_qty, med_price;
  final GeoPoint seller_location;
  final bool verified, payment_done;

  BoughtMedicine(
      {this.ID,
      @required this.seller_med_ID,
      this.prescription,
      this.verified,
      this.payment_done,
      this.verified_by,
      this.seller_location,
      this.med_qty,
      this.seller_email,
      this.med_name,
      this.buyer_email,
      this.med_price});
}

class BoughtMedicineService {
  final String email;
  BoughtMedicineService({this.email});

  Firestore _firestore = Firestore.instance;
  String ref = 'users';
  String ref1 = 'bought_medicine';

  void addBoughtMedicine(BoughtMedicine boughtMedicine) async {
    await _firestore.collection(ref).document(email).collection(ref1).add({
      'email': email,
      'seller_med_ID': boughtMedicine.seller_med_ID,
      'prescription': boughtMedicine.prescription,
      'buyer_email': boughtMedicine.buyer_email,
      'verified': boughtMedicine.verified,
      'payment_done': boughtMedicine.payment_done,
      'seller_email': boughtMedicine.seller_email,
      'med_name': boughtMedicine.med_name,
      'verified_by': boughtMedicine.verified_by,
      'med_qty': boughtMedicine.med_qty,
      'med_price': boughtMedicine.med_price,
      'seller_location': boughtMedicine.seller_location,
    });
  }

  void updatePayment(String id) async {
    await _firestore
        .collection(ref)
        .document(email)
        .collection(ref1)
        .document(id)
        .updateData({'payment_done': true});
  }

  List<BoughtMedicine> _boughtFromSnap(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return BoughtMedicine(
        ID: doc.documentID,
        seller_med_ID: doc.data['seller_med_ID'] ?? '',
        prescription: doc.data['prescription'] ?? '',
        verified: doc.data['verified'] ?? false,
        buyer_email: doc.data['buyer_email'] ?? '',
        payment_done: doc.data['payment_done'] ?? false,
        verified_by: doc.data['verified_by'] ?? '',
        seller_email: doc.data['seller_email'] ?? '',
        med_name: doc.data['med_name'] ?? '',
        med_qty: doc.data['med_qty'] ?? 0,
        med_price: doc.data['med_price'] ?? 0,
        seller_location: doc.data['seller_location'] ?? '',
      );
    }).toList();
  }

  Stream<List<BoughtMedicine>> get boughtMedicine {
    return _firestore
        .collection(ref)
        .document(email)
        .collection(ref1)
        .snapshots()
        .map(_boughtFromSnap);
  }
}
