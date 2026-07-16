class ApiConfig {
  // Base URL (ubah di sini aja kalau pindah server / ganti domain)
  static const String baseUrl = "https://herisusanta.my.id/";

  // Endpoint (biar lebih mudah dipanggil di banyak file)
  static const String login = "$baseUrl/login/login.php";
  static const String register = "$baseUrl/login/tambahdata.php";
  static const String ubahData = "$baseUrl/login/ubahdata.php";
  static const String ubahUser = "$baseUrl/login/ubahuser.php";
  static const String hapusUser = "$baseUrl/login/hapususer.php";
  //static const String deleteUser = "$baseUrl/login/ambildata.php";
  static const String ambilData = "$baseUrl/login/ambildata.php";
  static const String ambilUser = "$baseUrl/login/ambiluser.php";
  static const String gambar = "$baseUrl/images/profile/halaman_delayota.jpeg";
}

class Api {
  static const String baseUrl = "https://herisusanta.my.id/";
  static const String imageUrl = "${baseUrl}images/";

  static String getImage(String filename) {
    return "$imageUrl$filename";
  }
}
