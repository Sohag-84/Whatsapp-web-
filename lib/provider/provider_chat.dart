import 'package:flutter/material.dart';
import 'package:whatsapp_web_clone/models/user_model.dart';

class ProviderChat with ChangeNotifier {
  UserModel? _toUserData;
  UserModel? get toUser => _toUserData;

  set toUserData(UserModel? userModel) {
    _toUserData = userModel;
    notifyListeners();
  }
}
