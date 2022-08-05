import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_produksi/source/data/Model/modelCariMesin.dart';
import 'package:flutter_produksi/source/data/network/api.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class ModalCariMesin extends StatefulWidget {
  // String value;
  const ModalCariMesin({Key? key}) : super(key: key);
  // ModalCariMesin({required this.value});

  @override
  _ModalCariMesinState createState() => _ModalCariMesinState();
}

class _ModalCariMesinState extends State<ModalCariMesin> {
  TextEditingController valueSelectMesin = TextEditingController();
  var listMesin = [];
  List<CariMesinModel> listMSN = <CariMesinModel>[];
  var loading = false;

  void cariMesin(var q) async {
    listMesin.clear();
    setState(() {
      loading = true;
    });
    var url = Uri.parse(API.apiCariMesin(q));
    try {
      var response = await http.get(url, headers: {
        'Accept': 'application/json',
        'Authorization': API.apiToken(),
      });
      setState(() {
        var json = convert.jsonDecode(response.body);
        if (json != null) {
          if (response.statusCode == 200) {
            setState(() {
              loading = false;
            });
            json.forEach((e) {
              var a = {
                "id": e['id'],
                "nama_mesin": e['nama_mesin'],
                "kelompok": e['kelompok'],
                "nama_lokasi": e['nama_lokasi'],
                "alias_msn": e['alias_msn'],
              };
              var b =
                  CariMesinModel(id: e['id'], nama_mesin: e['nama_mesin'], kelompok: e['kelompok'], nama_lokasi: e['nama_lokasi'], alias_msn: e['alias_msn']);
              listMSN.add(b);
              listMesin.add(a);
            });
          } else {
            setState(() {
              loading = false;
            });
          }
        } else {
          setState(() {
            loading = false;
          });
        }
      });
      // print('Cari Mesin: $listMSN');
    } catch (e) {
      print('Error: $e');
      setState(() {
        loading = false;
      });
    }
  }

  int _rowsPerPage = PaginatedDataTable.defaultRowsPerPage;
  int _rowsPerPage1 = PaginatedDataTable.defaultRowsPerPage;

  void kembali() {
    Navigator.pop(
      context,
    );
  }

  @override
  Widget build(BuildContext context) {
    var dts = DTS(listMesin, kembali);
    var tableItemsCount = dts.rowCount;
    var defaultRowsPerPage = PaginatedDataTable.defaultRowsPerPage;
    var isRowCountLessDefaultRowsPerPage = tableItemsCount < defaultRowsPerPage;
    _rowsPerPage = isRowCountLessDefaultRowsPerPage ? tableItemsCount : defaultRowsPerPage;
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Row(
                    children: [
                      Icon(MaterialIcons.chevron_left, size: 27, color: Colors.black),
                      Text('Kembali', style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w600))
                    ],
                  ))),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Silahkan Cari Mesin berdasarkan ID / Nama / Alias',
              style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w700),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Catatan : Kata Kunci minimal 2 karakter',
              style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w500),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: valueSelectMesin,
              onChanged: (value) {
                setState(() {
                  if (value.length == 0) {
                    listMesin.clear();
                  }
                  cariMesin(value);
                });
              },
              decoration: InputDecoration(
                  prefixIcon: Icon(MaterialIcons.search, size: 24),
                  hintText: 'Silahkan Masukan Kata Kunci',
                  isDense: true, // Added this
                  contentPadding: EdgeInsets.all(15),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(40.0))),
            ),
          ),
          Expanded(
            flex: 2,
            child: loading == true
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : listMesin.isEmpty
                    ? Center(
                        child: Text('Data Tidak ditemukan', style: GoogleFonts.poppins()),
                      )
                    : ListView.builder(
                        itemCount: listMesin.length,
                        itemBuilder: (BuildContext context, int index) {
                          final data = listMesin[index];
                          return Container(
                            margin: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(data['nama_mesin']),
                                Row(children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ElevatedButton(
                                        onPressed: () {
                                          Navigator.pop(context, data['nama_mesin']);
                                        },
                                        child: Text('PILIH', style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w700))),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(primary: Colors.green[700], onPrimary: Colors.green[400]),
                                        onPressed: () {},
                                        child: Text('DETAIL', style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w700))),
                                  ),
                                ])
                              ],
                            ),
                          );
                        }),
          )
        ],
      ),
    );
  }
}

class DTS extends DataTableSource {
  final List isi;
  final VoidCallback kembali;
  DTS(this.isi, this.kembali);
  // final list = List<CariMesinModel>.generate(
  //     13, (index) => CariMesinModel(index,1, 'nama msn', 'klmp', '', ''));
  @override
  DataRow getRow(int index) {
    return DataRow.byIndex(
      index: index,
      cells: [
        DataCell(Text(isi[index]['id'].toString())),
        DataCell(Text(isi[index]['nama_mesin'])),
        DataCell(Text(isi[index]['kelompok'])),
        DataCell(Text(isi[index]['nama_lokasi'])),
        DataCell(Text(isi[index]['alias_msn'].toString())),
        DataCell(ElevatedButton(
            onPressed: () {
              print(isi[index]['nama_mesin']);
              kembali();
            },
            child: Text('Pilih'))),
      ],
    );
  }

  @override
  int get rowCount => isi.length; // Manipulate this to which ever value you wish

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => 0;
}
