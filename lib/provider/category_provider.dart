import 'package:sperro_neu/services/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CategoryProvider with ChangeNotifier {
  final UserService _firebaseUser = UserService();
  DocumentSnapshot? doc;
  DocumentSnapshot<Map<String, dynamic>>? userDetails;

  String? selectedCategory;
  String? selectedSubCategory;
  List<String> imageUploadedUrls = [];
  Map<String, dynamic> formData = {};

  void setCategory(String selectedCategory) {
    this.selectedCategory = selectedCategory;
    notifyListeners();
  }

  void setSubCategory(String selectedSubCategory) {
    this.selectedSubCategory = selectedSubCategory;
    notifyListeners();
  }

  void setCategorySnapshot(DocumentSnapshot snapshot) {
    doc = snapshot;
    notifyListeners();
  }

  void setImageList(String url) {
    imageUploadedUrls.add(url);
    print(imageUploadedUrls.length);
    notifyListeners();
  }

  void setFormData(Map<String, dynamic> data) {
    formData = data;
    notifyListeners();
  }

  void getUserDetail() {
    _firebaseUser.getUserData().then((value) {
      userDetails = value as DocumentSnapshot<Map<String, dynamic>>;
      notifyListeners();
    });
  }

  void clearData() {
    imageUploadedUrls = [];
    formData = {};
    notifyListeners();
  }
}
