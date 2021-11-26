import 'package:flutter/material.dart';
import 'package:flutter_produksi/API/index.dart';
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
        if(json != null){
          json.forEach((e) {
          var a = {
            "id": e['id'],
            "nama_mesin": e['nama_mesin'],
            "kelompok": e['kelompok'],
            "nama_lokasi": e['nama_lokasi'],
            "alias_msn": e['alias_msn'],
          };
          // print(a);
          listMesin.add(a);
        });
        } else {
          
        }
      });
      print('Cari Mesin: $listMesin');
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Kembali'))),
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
              decoration: const InputDecoration(
                  hintText: 'Cari Mesin (ID / NAMA / ALIAS) *Kata minimal 2 karakter',
                  isDense: true, // Added this
                  contentPadding: EdgeInsets.all(15),
                  border: OutlineInputBorder()),
            ),
          ),
          Text(valueSelectMesin.text.toString()),
          SizedBox(
            height: MediaQuery.of(context).size.height / 1.5,
            child: listMesin.length == 0
                ? Center(
                    child: Text('Data Tidak ditemukan', style: GoogleFonts.poppins()),
                  )
                : ListView.builder(
                    itemCount: listMesin.length,
                    itemBuilder: (BuildContext context, int index) {
                      final data = listMesin[index];
                      return Container(
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              Navigator.pop(context, data['nama_mesin']);
                            });
                          },
                          child: Text(data['nama_mesin']),
                        ),
                      );
                    }),
          )
        ],
      ),
    );
  }
}
