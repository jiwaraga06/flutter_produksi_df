import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:google_fonts/google_fonts.dart';

class ListJO extends StatefulWidget {
  ListJO({Key? key}) : super(key: key);

  @override
  _ListJOState createState() => _ListJOState();
}

class _ListJOState extends State<ListJO> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF6F7D7),
      body: Stack(
        children: [
          Container(
            color:const Color(0xff679B9B),
            height: MediaQuery.of(context).size.height / 2.5,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10.0, left: 8.0),
                  child: Row(
                    children: [
                      const Icon(MaterialIcons.format_list_bulleted, color: Colors.white, size: 20),
                      const Padding(
                        padding: EdgeInsets.only(left: 12.0, right: 12.0),
                        child: Text('-', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.white)),
                      ),
                      Text('Job Order', style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.white)),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
