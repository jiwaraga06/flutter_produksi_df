import 'dart:ui';

import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_produksi/Pages/Dashboard/index.dart';
import 'package:flutter_produksi/Pages/List_JO/index.dart';
import 'package:flutter_produksi/Pages/Login/index.dart';
import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

enum Page { dashboard, listjo }

class _HomeState extends State<Home> {
  Page _page = Page.dashboard;
  GlobalKey<SliderMenuContainerState> key = GlobalKey<SliderMenuContainerState>();
  Color color = const Color(0xFF1B366D);

  Widget _pages() {
    switch (_page) {
      case Page.dashboard:
        return Dashboard();
      case Page.listjo:
        return ListJO();
    }
  }

  void logOut() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.clear();
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const Login()));
  }

  var email;
  void getEmail() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      email = pref.getString('email');
    });
  }

  @override
  void initState() {
    super.initState();
    getEmail();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SliderMenuContainer(
            key: key,
            animationDuration: 300,
            isTitleCenter: false,
            appBarColor: color,
            drawerIconColor: Colors.white,
            sliderMenuOpenSize: 225,
            hasAppBar: true,
            appBarPadding: const EdgeInsets.only(top: 10.0),
            drawerIconSize: 17,
            title: Text('Menu', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white)),
            trailing: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.0),
                boxShadow: const [
                  BoxShadow(color: Color(0xff616161), offset: Offset(0.0, 3.0), blurRadius: 3.0),
                ],
              ),
              margin: const EdgeInsets.all(8.0),
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(right: 6.0),
                    child: Icon(FontAwesome.user_circle_o, color: Color(0xff393E46), size: 22),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 12.0),
                    child: Text(email.toString(), style: const TextStyle(color: Color(0xff393E46), fontSize: 13)),
                  ),
                ],
              ),
            ),
            sliderMenu: Container(
              color: Colors.white38,
              child: ListView(
                children: [
                  Container(
                      color: Colors.white,
                      height: 80,
                      alignment: Alignment.center,
                      child: Text('Dyeing Finishing', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w700, color: const Color(0xff323232)))),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                      hoverColor: const Color(0xFF1B366D),
                      tileColor: _page == Page.dashboard ? const Color(0xFF193775) : Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      leading: const Icon(MaterialCommunityIcons.view_dashboard, color: Color(0xFF1B366D), size: 17),
                      title: Text('Dashboard',
                          style: GoogleFonts.poppins(fontSize: 13, fontWeight: _page == Page.dashboard ? FontWeight.w700 : FontWeight.normal)),
                      onTap: () {
                        key.currentState!.closeDrawer();
                        setState(() {
                          _page = Page.dashboard;
                          color = const Color(0xFF1B366D);
                        });
                      },
                    ),
                  ),
                  Divider(color: Colors.grey[400], height: 2),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                      hoverColor: const Color(0xFF598585),
                      tileColor: _page == Page.listjo ? const Color(0xff679B9B) : Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      leading: const Icon(MaterialIcons.format_list_bulleted, color: Color(0xFF598585), size: 17),
                      title:
                          Text('Job Order', style: GoogleFonts.poppins(fontSize: 13, fontWeight: _page == Page.listjo ? FontWeight.w700 : FontWeight.normal)),
                      onTap: () {
                        setState(() {
                          key.currentState!.closeDrawer();
                          _page = Page.listjo;
                          color = const Color(0xFF598585);
                        });
                      },
                    ),
                  ),
                  Divider(color: Colors.grey[400], height: 2),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                      hoverColor: Colors.red[100],
                      leading: Icon(MaterialCommunityIcons.logout, color: Colors.red[700], size: 17),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      title: Text('Log out', style: GoogleFonts.poppins(fontSize: 13)),
                      onTap: () {
                        CoolAlert.show(
                            context: context,
                            type: CoolAlertType.confirm,
                            title: 'Apakah Anda Yakin Ingin Keluar ?',
                            confirmBtnText: 'Iya',
                            cancelBtnText: 'Tidak',
                            cancelBtnTextStyle: TextStyle(color: Colors.red[700], fontWeight: FontWeight.w700),
                            onConfirmBtnTap: logOut);
                      },
                    ),
                  ),
                ],
              ),
            ),
            sliderMain: _pages()));
  }
}
