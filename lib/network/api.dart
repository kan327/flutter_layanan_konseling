import 'dart:convert';
import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';

class Network {
  final String _url =
      'http://127.0.0.1:8005/api'; // URL server API...  jika menggunakan port selain 8001 ubah disini linknyaa, pastikan menambahkan [ /api ] walaupun di chromenya gaada contoh https://localhost:8000/api
  var token; // variabel untuk menyimpan token dari server

  // method untuk membuat header request HTTP
  _header(token) => {
        'Content-Type': 'application/json', // jenis konten yang dikirimkan
        'Accept': 'application/json', // jenis konten yang diterima
        'Authorization': 'Bearer $token',
      };

  // method untuk melakukan request HTTP dengan metode POST
  postRequest({
    required String route, // alamat endpoint di server
    required Map<String, dynamic> data, // data yang dikirimkan dalam format Map
    String token = '',
  }) async {
    String url = _url + route; // menggabungkan URL server dan alamat endpoint
    return await http.post(
      // melakukan request HTTP POST menggunakan library http
      Uri.parse(url), // mengubah URL ke Uri object
      body: jsonEncode(data), // meng-encode data ke dalam bentuk JSON
      headers: _header(token), // menambahkan header pada request
    );
  }
}
