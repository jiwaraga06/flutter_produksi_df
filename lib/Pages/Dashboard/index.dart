import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_produksi/API/index.dart';
import 'package:flutter_produksi/Pages/InputHasilDF/index.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Dashboard extends StatefulWidget {
  Dashboard({Key? key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  var email;
  void getHasilDF() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    email = pref.getString('email');
    var url = Uri.parse(API.apiHasil_DF(email));
    try {
      var response = await http.get(url, headers: {'Accept': 'application/json', 'Authorization': API.apiToken()});
      var json = jsonDecode(response.body);
      print(json);
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    getHasilDF();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF6F7D7),
      body: Stack(
        children: [
          Container(
            color: const Color(0xff142850),
            height: MediaQuery.of(context).size.height / 2.5,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10.0, left: 8.0),
                  child: Row(children: [
                    const Icon(MaterialCommunityIcons.view_dashboard, color: Colors.white, size: 20),
                    const Padding(
                      padding: EdgeInsets.only(left: 12.0, right: 12.0),
                      child: Text('-', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.white)),
                    ),
                    Text('Dashboard', style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.white)),
                  ]),
                ),
              ],
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xff142850),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => InputHasilDF()));
        },
        child: const Icon(MaterialIcons.add),
      ),
    );
  }
}
