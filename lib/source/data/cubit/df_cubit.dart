import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_produksi/source/data/repository/repository.dart';
import 'package:flutter_produksi/source/router/string.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'df_state.dart';

class DfCubit extends Cubit<DfState> {
  final MyRepository? myRepository;
  DfCubit({this.myRepository}) : super(DfInitial());

  void splashAuth(context) async {
    emit(SplashLoading());
    await Future.delayed(Duration(seconds: 2));
    emit(SplashLoaded());
    Navigator.pushReplacementNamed(context, LOGIN);
    final SharedPreferences pref = await SharedPreferences.getInstance();
    var email = pref.getString('email');
    print("Email splash: $email");
    if(email != null){
      Navigator.pushReplacementNamed(context, HOME);
    } else {
      Navigator.pushReplacementNamed(context, LOGIN);
    }
  }

  void login(email, password, context) async {
    emit(LoginLoading());
    myRepository!.login(email, password).then((value) async {
      var json = jsonDecode(value.body);
      emit(LoginLoaded());
      print("JSON LOGIN: $json");
      if (value.statusCode == 200) {
        SharedPreferences pref = await SharedPreferences.getInstance();
        pref.setString('email', json['email']);
        Navigator.pushReplacementNamed(context, HOME);
      } else {
        emit(LoginMessageError(message: json['textCode']));
      }
    });
  }
}
