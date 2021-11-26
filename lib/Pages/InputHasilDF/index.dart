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
  var valueKelompok, valueShift, valueWaktu;
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
              colorScheme: ColorScheme.dark(
                primary: Colors.deepPurple,
                onPrimary: Colors.white,
                surface: Colors.pink,
                onSurface: Colors.yellow,
              ),
              dialogBackgroundColor: Colors.green[900],
            ),
            child: picker!,
          );
        }).then((selectedDate) {
      //TODO: handle selected date
      if (selectedDate != null) {
        _selectedDate = selectedDate;
        valueDate
          ..text = DateFormat.yMd().format(selectedDate)
          ..selection = TextSelection.fromPosition(TextPosition(offset: valueDate.text.length, affinity: TextAffinity.upstream));
      }
    });
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
            icon: const Icon(MaterialIcons.chevron_left, color: Colors.white, size: 23)),
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
                                return DropdownMenuItem(child: Text(value['name']), value: value['value']);
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
                                  MaterialPageRoute(builder: (context) => ModalCariMesin()),
                                );
                                setState(() {
                                  valuePilihMesin = TextEditingController(text: res == null ? '' : '$res');
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
                          Text('Tanggal Produksi', style: GoogleFonts.poppins()),
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
                              return DropdownMenuItem(child: Text(value['name']), value: value['value']);
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
                              return DropdownMenuItem(child: Text(value['name']), value: value['value']);
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
                      Text('Perkiraan Panjang Selesai (m)', style: GoogleFonts.poppins()),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
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
                      Text('Pekiraan Berat Selesai (m)', style: GoogleFonts.poppins()),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
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
                      Text('Total Batch (m)', style: GoogleFonts.poppins()),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}
