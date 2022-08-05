import 'package:flutter/material.dart';

class HasilDf extends StatefulWidget {
  HasilDf({Key? key}) : super(key: key);

  @override
  State<HasilDf> createState() => _HasilDfState();
}

class _HasilDfState extends State<HasilDf> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: Text("Hasil Df")),
      body: ListView(
        children: [],
      ),
    );
  }
}
