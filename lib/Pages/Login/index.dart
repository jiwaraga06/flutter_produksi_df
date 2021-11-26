import 'dart:convert';
import 'dart:ui';

import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_produksi/API/index.dart';
import 'package:flutter_produksi/Pages/Home/index.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_icons/flutter_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

enum AuthLogin { signIn, noSignIn }

class _LoginState extends State<Login> {
  AuthLogin _authLogin = AuthLogin.noSignIn;
  final formGlobalKey = GlobalKey<FormState>();
  final controllerEmail = TextEditingController();
  final controllerPassword = TextEditingController();
  var showPassword = true;

  void postLogin() async {
    var snackBar = SnackBar(
        content: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            const SpinKitThreeBounce(
              color: Colors.white,
              size: 20.0,
            ),
            const Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text('Loading'),
            ),
          ],
        ),
      ],
    ));
    if (formGlobalKey.currentState!.validate()) {
      // ScaffoldMessenger.of(context).showSnackBar(
      //   const SnackBar(content: Text('Processing Data')),
      // );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      var data = {
        'email': controllerEmail.text,
        'password': controllerPassword.text,
      };
      var url = Uri.parse(API.apiLogin());
      try {
        var response = await http.post(url, headers: {'Accept': 'application/json', 'Authorization': API.apiToken()}, body: data);
        var json = jsonDecode(response.body);
        print(json);

        if (json['email'] != null) {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          setState(() {
            _authLogin = AuthLogin.signIn;
            saveEmail(json['email']);
          });
        } else if (json['textCode'] != null) {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          CoolAlert.show(context: context, type: CoolAlertType.warning, text: json['textCode'].toString());
        }
      } catch (e) {
        print(e);
      }
    }
  }

  void showPass() {
    showPassword = !showPassword;
  }

  void saveEmail(String email) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString('email', email);
  }

  var email;
  void getEmail() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      email = pref.getString('email');
      print(email);

      // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Home()));
      _authLogin = email != null ? AuthLogin.signIn : AuthLogin.noSignIn;
    });
  }

  @override
  void initState() {
    super.initState();
    getEmail();
  }

  @override
  Widget build(BuildContext context) {
    switch (_authLogin) {
      case AuthLogin.noSignIn:
        return Scaffold(
          backgroundColor: Color(0xff142850),
          body: ListView(
            children: [
              Container(
                color: Color(0xff142850),
                height: MediaQuery.of(context).size.height / 1.2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Container(
                        width: 600,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            const BoxShadow(
                              color: Color(0xff616161),
                              offset: Offset(0.0, 3.0),
                              blurRadius: 3.0,
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(top: 12.0, bottom: 12.0),
                                child: Text('Log in', style: TextStyle(fontSize: 27, color: Color(0xff142850), fontWeight: FontWeight.w600)),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8),
                                child: Container(
                                  // width: 300,
                                  child: Form(
                                    key: formGlobalKey,
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(top: 12.0, left: 8, right: 8, bottom: 8),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              const Padding(
                                                padding: EdgeInsets.only(bottom: 4.0),
                                                child: Text('Email', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
                                              ),
                                              Material(
                                                elevation: 4,
                                                shadowColor: Color(0xff142850),
                                                borderRadius: BorderRadius.circular(10),
                                                child: Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: TextFormField(
                                                    controller: controllerEmail,
                                                    keyboardType: TextInputType.emailAddress,
                                                    cursorColor: Color(0xff142850),
                                                    decoration: const InputDecoration(
                                                      focusColor: Color(0xff142850),
                                                      hintText: 'Masukan Email',
                                                      isDense: true,
                                                      contentPadding: const EdgeInsets.all(6),
                                                      hintStyle: const TextStyle(color: Colors.black54),
                                                      fillColor: Colors.white30,
                                                      filled: true,
                                                      prefixIcon: const Icon(MaterialIcons.email, size: 25, color: Color(0xff142850)),
                                                      border: OutlineInputBorder(borderSide: BorderSide.none),
                                                      errorStyle: TextStyle(fontSize: 17),
                                                    ),
                                                    validator: (value) {
                                                      if (value == null || value.isEmpty) {
                                                        return 'Please insert a valid email';
                                                      }
                                                      return null;
                                                    },
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(top: 18.0, left: 8, right: 8, bottom: 8),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              const Padding(
                                                padding: EdgeInsets.only(bottom: 4.0),
                                                child: Text('Password', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
                                              ),
                                              Material(
                                                elevation: 3,
                                                shadowColor: Colors.blue,
                                                borderRadius: BorderRadius.circular(10),
                                                child: Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: TextFormField(
                                                    controller: controllerPassword,
                                                    obscureText: showPassword,
                                                    cursorColor: Color(0xff142850),
                                                    decoration: InputDecoration(
                                                      fillColor: Colors.white30,
                                                      filled: true,
                                                      isDense: true,
                                                      hintText: 'Masukan Password',
                                                      contentPadding: const EdgeInsets.all(6),
                                                      prefixIcon: const Icon(MaterialIcons.lock_outline, size: 25, color: Color(0xff142850)),
                                                      suffixIcon: IconButton(
                                                        onPressed: () {
                                                          setState(() {
                                                            showPassword = !showPassword;
                                                          });
                                                        },
                                                        icon: Icon(showPassword ? MaterialIcons.visibility_off : MaterialIcons.visibility, color: Color(0xff142850)),
                                                      ),
                                                      border: OutlineInputBorder(borderSide: BorderSide.none),
                                                      errorStyle: TextStyle(fontSize: 17),
                                                    ),
                                                    validator: (value) {
                                                      if (value == null || value.isEmpty) {
                                                        return 'Please insert a valid password';
                                                      }
                                                      return null;
                                                    },
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: SizedBox(
                                            width: 350,
                                            height: 45,
                                            child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                  padding: const EdgeInsets.all(8), elevation: 6.0, primary: Color(0xff142850), onPrimary: Colors.blue[100]),
                                              onPressed: postLogin,
                                              child: const Text(
                                                'LOGIN',
                                                style: TextStyle(fontSize: 17.0, color: Colors.white),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                  alignment: Alignment.bottomCenter,
                  child: const Text(
                    'IT DEPARTEMENT | PT SIPATEX PUTRI LESTARI',
                    style: TextStyle(fontSize: 17, color: Colors.white),
                  )),
            ],
          ),
        );
      case AuthLogin.signIn:
        return Home();
        break;
    }
  }
}
