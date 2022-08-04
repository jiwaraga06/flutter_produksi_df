import 'dart:convert';
import 'dart:ui';

import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_produksi/source/data/cubit/df_cubit.dart';
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff142850),
      body: BlocListener<DfCubit, DfState>(
        listener: (context, state) {
          if (state is LoginLoading) {
            showDialog(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: Colors.white,
                    ),
                  );
                });
          }
          if (state is LoginLoaded) {
            Navigator.of(context).pop();
          }
        },
        child: ListView(
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
                                                      icon: Icon(showPassword ? MaterialIcons.visibility_off : MaterialIcons.visibility,
                                                          color: Color(0xff142850)),
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
                                            onPressed: () {
                                              BlocProvider.of<DfCubit>(context).login(controllerEmail.text, controllerPassword.text, context);
                                            },
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
      ),
    );
  }
}
