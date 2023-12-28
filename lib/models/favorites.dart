import 'package:flutter/material.dart';

class Favorites extends ChangeNotifier {
  final List<int> _favoriteItems = [];

  List<int> get items => _favoriteItems;

  void add(int itemNo) {
    _favoriteItems.add(itemNo);
    notifyListeners();
  }

  void remove(int itemNo) {
    _favoriteItems.remove(itemNo);
    notifyListeners();
  }

  void toggle(int itemNo) {
    if (_favoriteItems.contains(itemNo)) {
      _favoriteItems.remove(itemNo);
    } else {
      _favoriteItems.add(itemNo);
    }
    notifyListeners();
  }
}
