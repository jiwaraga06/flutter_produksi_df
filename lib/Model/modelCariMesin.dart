class CariMesinModel {
  final int id;
  final String nama_mesin;
  final String kelompok;
  final String nama_lokasi;
  final String alias_msn;

  CariMesinModel({required this.id,required this.nama_mesin,required this.kelompok,required this.nama_lokasi,required this.alias_msn});
  @override toString() => '{id: $id, nama_mesin: $nama_mesin, kelompok: $kelompok, nama_lokasi: $nama_lokasi, alias_msn: $alias_msn}';
  // factory CariMesinModel.fromJson(Map<String, dynamic> json){
  //  return CariMesinModel(id:json['id'], nama_mesin: json['nama_mesin'], kelompok: json['kelompok'], nama_lokasi: json['nama_lokasi'], alias_msn: json['alias_msn']);
  // }
}