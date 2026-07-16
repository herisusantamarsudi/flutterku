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

class UserData {
  final int id;
  final String user;
  final String namalengkap;
  final String email;
  final String telpon;
  final String profile;
  final String level;
  final String password;
  // Constructor
  UserData(
    this.id,
    this.user,
    this.namalengkap,
    this.email,
    this.telpon,
    this.profile,
    this.level,
    this.password,
  );

  // Factory constructor untuk parsing dari JSON
  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      int.tryParse(json['id'].toString()) ?? 0, // ambil id dari JSON
      json['username'], // ambil user
      json['namalengkap'],
      json['email'],
      json['telpon'],
      json['profile'],
      json['level'],
      json['password'],
    );
  }
}
