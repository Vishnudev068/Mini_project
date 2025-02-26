import 'package:flutter/material.dart';
import 'package:flutter_application_4/models/models.dart';

ValueNotifier<List<Pharmacy>> pharmacylist = ValueNotifier([]);

void view_pharmacy(Map<String, dynamic> data) {
  pharmacylist.value.clear();
  data['data'].forEach((value) {
    pharmacylist.value.add(
      Pharmacy(
        id: value['id'],
        name: value['name'],
        location: value['location'],
      ),
    );
  });
  pharmacylist.notifyListeners();
}
