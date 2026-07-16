class BarangData {
  final String nama;
  final int harga;
  final int jumlah;

  BarangData(this.nama, this.harga, this.jumlah);

  factory BarangData.fromJson(Map<String, dynamic> json) {
    return BarangData(
      json['nama'],
      int.parse(json['harga'].toString()),
      int.parse(json['jumlah'].toString()),
    );
  }
}
