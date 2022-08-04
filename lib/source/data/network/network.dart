import 'package:flutter_produksi/source/data/network/api.dart';

import 'package:http/http.dart' as http;

class MyNetwork {
  Future login(body) async {
    try {
      var url = Uri.parse(API.apiLogin());
      var response = await http.post(
        url,
        headers: {
          'Accept': 'application/json',
          'Authorization': API.apiToken(),
        },
        body: body
      );
      return response;
    } catch (e) {
      print("Error login network");
    }
  }
}
