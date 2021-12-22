import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserWidget extends InheritedWidget{
  final User? user;

  const UserWidget({
    Key? key,
    this.user,
    required Widget child
  }) : super(key: key, child: child);

  static User? of(BuildContext context) => 
context.
    dependOnInheritedWidgetOfExactType<UserWidget>()!
    .user;

  @override
  bool updateShouldNotify(UserWidget oldWidget) => 
    oldWidget.user != user;
}