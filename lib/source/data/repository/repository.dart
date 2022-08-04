import 'package:flutter_produksi/source/data/network/network.dart';

class MyRepository {
  final MyNetwork? myNetwork;

  MyRepository({this.myNetwork});

  Future login(email, password) async {
    var body = {'email': email, 'password': password};
    var json = await myNetwork!.login(body);
    return json;
  }
}
