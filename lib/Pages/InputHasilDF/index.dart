import 'dart:convert' as convert;
import 'dart:js';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_produksi/API/index.dart';
import 'package:flutter_produksi/Model/modelCariMesin.dart';
import 'package:flutter_produksi/Pages/InputHasilDF/CariMesin/index.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class InputHasilDF extends StatefulWidget {
  InputHasilDF({Key? key}) : super(key: key);

  @override
  _InputHasilDFState createState() => _InputHasilDFState();
}

class _InputHasilDFState extends State<InputHasilDF> {
  TextEditingController valuePilihMesin = TextEditingController();
  TextEditingController valueSelectMesin = TextEditingController();
  TextEditingController valueDate = TextEditingController();
  TextEditingController valueWoven = TextEditingController(text: '0');
  TextEditingController valuePanjang = TextEditingController(text: '0');
  TextEditingController valueKnitting = TextEditingController(text: '0');
  TextEditingController valueBerat = TextEditingController(text: '0');
  TextEditingController valueBatch = TextEditingController(text: '0');
  DateTime? _selectedDate;
  var valueKelompok, valueShift, valueWaktu, valueTipe, valueTahun;
  List listKelompok = [
    {'name': 'DYEING PERSIAPAN', 'value': 'dyeing_persiapan'},
    {'name': 'DYEING PROCESSING', 'value': 'dyeing_processing'},
    {'name': 'DYEING FINISHING', 'value': 'dyeing_finishing'},
  ];
  List shift = [
    {'name': 'NS', 'value': 'NS'},
    {'name': 'A', 'value': 'A'},
    {'name': 'B', 'value': 'B'},
    {'name': 'C', 'value': 'C'},
  ];
  List waktu = [
    {'name': 'PAGI', 'value': 'PAGI'},
    {'name': 'MALAM', 'value': 'MALAM'},
  ];
  List tipe = [
    {'name': 'Normal', 'value': 'Normal'},
    {'name': 'Normal', 'value': 'Normal'},
  ];
  List tahun = [
    {'name': '2019', 'value': '2019'},
    {'name': '2020', 'value': '2020'},
    {'name': '2021', 'value': '2021'},
  ];

  _selectDate(BuildContext context) async {
    showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1999, 1),
        lastDate: DateTime.now(),
        builder: (context, picker) {
          return Theme(
            //TODO: change colors
            data: ThemeData.dark().copyWith(
              colorScheme: ColorScheme.light(
                primary: Colors.white,
                onPrimary: Colors.blue,
                surface: Colors.blue,
                primaryVariant: Colors.white,
                onSecondary: Colors.white,
                onSurface: Colors.white,
              ),
              dialogBackgroundColor: Colors.blue[800],
            ),
            child: picker!,
          );
        }).then((selectedDate) {
      //TODO: handle selected date
      if (selectedDate != null) {
        _selectedDate = selectedDate;
        valueDate
          ..text = DateFormat.yMd().format(selectedDate)
          ..selection = TextSelection.fromPosition(TextPosition(
              offset: valueDate.text.length, affinity: TextAffinity.upstream));
      }
    });
  }

  void showMyDialog(BuildContext context) async {
    return showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.teal[50],
          title: const Text('Pilih JO'),
          content: SizedBox(
            height: MediaQuery.of(context).size.height / 2,
            width: MediaQuery.of(context).size.width / 1.5,
            child: ListView(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height / 4.5,
                  child: Row(
                    children: [
                      Expanded(
                        flex: 4,
                        child: Container(
                          height: 40,
                          padding: const EdgeInsets.all(8),
                          margin: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey, width: 1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: DropdownButton(
                            underline: SizedBox(),
                            value: valueTipe,
                            isExpanded: true,
                            hint: Text('-- Tipe --'),
                            items: tipe.map((value) {
                              return DropdownMenuItem(
                                  child: Text(value['name']),
                                  value: value['value']);
                            }).toList(),
                            onChanged: (value) {
                              print(value);
                              setState(() {
                                valueTipe = value;
                              });
                            },
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 4,
                        child: Container(
                          height: 40,
                          padding: const EdgeInsets.all(8),
                          margin: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey, width: 1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: DropdownButton(
                            underline: SizedBox(),
                            value: valueTahun,
                            isExpanded: true,
                            hint: Text('-- Tahun --'),
                            items: tahun.map((value) {
                              return DropdownMenuItem(
                                  child: Text(value['name']),
                                  value: value['value']);
                            }).toList(),
                            onChanged: (value) {
                              print(value);
                              setState(() {
                                valueTahun = value;
                              });
                            },
                          ),
                        ),
                      ),
                      Expanded(
                          flex: 4,
                          child: Container(
                            height: 40,
                            padding: const EdgeInsets.all(8),
                            margin: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey, width: 1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: DropdownSearch(
                              validator: (v) =>
                                  v == null ? "required field" : null,
                              dropdownSearchDecoration: InputDecoration(
                                  hintText: "Select a country",
                                  enabled: true,
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide.none)),
                              mode: Mode.BOTTOM_SHEET,
                              enabled: true,
                              showSearchBox: true,
                              showSelectedItems: true,
                              items: [
                                "Brazil",
                                "Italia (Disabled)",
                                "Tunisia",
                                'Canada'
                              ],
                              showClearButton: true,
                              onChanged: print,
                              popupItemDisabled: (String? s) =>
                                  s?.startsWith('I') ?? false,
                              clearButtonSplashRadius: 20,
                              onBeforeChange: (a, b) {
                                if (b == null) {
                                  AlertDialog alert = AlertDialog(
                                    title: Text("Are you sure..."),
                                    content: Text(
                                        "...you want to clear the selection"),
                                    actions: [
                                      TextButton(
                                        child: Text("OK"),
                                        onPressed: () {
                                          Navigator.of(context).pop(true);
                                        },
                                      ),
                                      TextButton(
                                        child: Text("NOT OK"),
                                        onPressed: () {
                                          Navigator.of(context).pop(false);
                                        },
                                      ),
                                    ],
                                  );

                                  return showDialog<bool>(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return alert;
                                      });
                                }

                                return Future.value(true);
                              },
                            ),
                          )),
                    ],
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Tutup'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1B366D),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(MaterialIcons.chevron_left,
                color: Colors.white, size: 23)),
        title: Text(
          'Hasil Produksi Dyeing Finishing',
          style: GoogleFonts.poppins(fontSize: 16),
        ),
      ),
      body: ListView(
        children: [
          SizedBox(
              height: MediaQuery.of(context).size.height / 4.5,
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Text('Pilih Kelompok', style: GoogleFonts.poppins()),
                          Container(
                            height: 40,
                            padding: const EdgeInsets.all(8),
                            margin: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey, width: 1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: DropdownButton(
                              underline: SizedBox(),
                              value: valueKelompok,
                              isExpanded: true,
                              hint: Text('-- Kelompok --'),
                              items: listKelompok.map((value) {
                                return DropdownMenuItem(
                                    child: Text(value['name']),
                                    value: value['value']);
                              }).toList(),
                              onChanged: (value) {
                                print(value);
                                setState(() {
                                  valueKelompok = value;
                                });
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Text('Pilih Mesin', style: GoogleFonts.poppins()),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: InkWell(
                              onTap: () async {
                                // var res = ModalCariMesin();
                                final res = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ModalCariMesin()),
                                );
                                setState(() {
                                  valuePilihMesin = TextEditingController(
                                      text: res == null ? '' : '$res');
                                });
                              },
                              child: TextFormField(
                                controller: valuePilihMesin,
                                enabled: false,
                                decoration: const InputDecoration(
                                  hintText: '',
                                  isDense: true, // Added this
                                  contentPadding: EdgeInsets.all(15),
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              )),
          SizedBox(
            height: MediaQuery.of(context).size.height / 4.5,
            child: Row(
              children: [
                Expanded(
                    flex: 2,
                    child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Column(children: [
                          Text('Tanggal Produksi',
                              style: GoogleFonts.poppins()),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: InkWell(
                              onTap: () {
                                _selectDate(context);
                              },
                              child: TextFormField(
                                enabled: false,
                                controller: valueDate,
                                decoration: const InputDecoration(
                                  hintText: '',
                                  isDense: true, // Added this
                                  contentPadding: EdgeInsets.all(15),
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                          )
                        ]))),
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Text('Pilih Shift', style: GoogleFonts.poppins()),
                        Container(
                          height: 40,
                          margin: const EdgeInsets.all(8),
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey, width: 1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: DropdownButton(
                            underline: SizedBox(),
                            value: valueShift,
                            isExpanded: true,
                            hint: Text('-- Shift --'),
                            items: shift.map((value) {
                              return DropdownMenuItem(
                                  child: Text(value['name']),
                                  value: value['value']);
                            }).toList(),
                            onChanged: (value) {
                              print(value);
                              setState(() {
                                valueShift = value;
                              });
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Text('Pilih Waktu', style: GoogleFonts.poppins()),
                        Container(
                          height: 40,
                          margin: const EdgeInsets.all(8),
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey, width: 1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: DropdownButton(
                            underline: SizedBox(),
                            value: valueWaktu,
                            isExpanded: true,
                            hint: Text('-- Waktu --'),
                            items: waktu.map((value) {
                              return DropdownMenuItem(
                                  child: Text(value['name']),
                                  value: value['value']);
                            }).toList(),
                            onChanged: (value) {
                              print(value);
                              setState(() {
                                valueWaktu = value;
                              });
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height / 4.5,
            child: Row(
              children: [
                Expanded(
                  flex: 5,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(children: [
                      Text('Woven (m)', style: GoogleFonts.poppins()),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          enabled: false,
                          controller: valueWoven,
                          decoration: const InputDecoration(
                            hintText: '',
                            isDense: true, // Added this
                            contentPadding: EdgeInsets.all(15),
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ]),
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(children: [
                      Text('Perkiraan Panjang Selesai (m)',
                          style: GoogleFonts.poppins()),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          enabled: false,
                          controller: valuePanjang,
                          decoration: const InputDecoration(
                            hintText: '',
                            isDense: true, // Added this
                            contentPadding: EdgeInsets.all(15),
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ]),
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(children: [
                      Text('Knitting (m)', style: GoogleFonts.poppins()),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          enabled: false,
                          controller: valueKnitting,
                          decoration: const InputDecoration(
                            hintText: '',
                            isDense: true, // Added this
                            contentPadding: EdgeInsets.all(15),
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ]),
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(children: [
                      Text('Pekiraan Berat Selesai (m)',
                          style: GoogleFonts.poppins()),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          enabled: false,
                          controller: valueBerat,
                          decoration: const InputDecoration(
                            hintText: '',
                            isDense: true, // Added this
                            contentPadding: EdgeInsets.all(15),
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ]),
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(children: [
                      Text('Total Batch (m)', style: GoogleFonts.poppins()),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          enabled: false,
                          controller: valueBatch,
                          decoration: const InputDecoration(
                            hintText: '',
                            isDense: true, // Added this
                            contentPadding: EdgeInsets.all(15),
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ]),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          showMyDialog(context);
        },
        label: const Text('Tambah Record'),
        icon: const Icon(Icons.add),
        backgroundColor: Colors.teal,
      ),
    );
  }
}
