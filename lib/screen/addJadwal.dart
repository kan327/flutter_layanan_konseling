import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:layanan_konseling/network/api.dart';
import 'package:layanan_konseling/screen/login.dart';
import 'package:layanan_konseling/screen/response.dart';
import 'package:layanan_konseling/utils/colors.dart';
import 'package:layanan_konseling/utils/text_field_input.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class addJadwal extends StatefulWidget {
  const addJadwal({super.key});

  @override
  State<addJadwal> createState() => _addJadwalState();
}

class _addJadwalState extends State<addJadwal> {
  bool isPage1 = true;
  late TextEditingController _usernameController = TextEditingController();
  final TextEditingController _deskripsiController = TextEditingController();
  final TextEditingController _tempatController = TextEditingController();
  final TextEditingController _tanggalController = TextEditingController();
  final TextEditingController _waktuController = TextEditingController();
  final List<String> temaItems = [
    'Bimbingan Karir',
    'Bimbingan Sosial',
    'Bimbingan Pribadi',
    'Bimbingan Belajar'
  ];
  final List<String> karirItems = [
    'Bekerja',
    'Kuliah',
    'Wirausaha',
  ];
  String? temaValue;
  String? karirValue;
  late String? username;
  DateTime _dateTime = DateTime.now();
  TimeOfDay _timeOfDay = TimeOfDay(hour: 8, minute: 30);
  late SharedPreferences sharedPreferences;
  late int user_id;
  bool isAuth = false;
  bool _isLoading = false;
  @override
  void _checkIfLoggedIn() async {
    sharedPreferences = await SharedPreferences.getInstance();
    var token = sharedPreferences.getString('token');
    if (token != null) {
      if (mounted) {
        setState(() {
          isAuth = true;
          username = sharedPreferences.getString('userName');
          user_id = sharedPreferences.getInt('userId')!;
          _usernameController = TextEditingController(text: username);
        });
      }
    }
    if (!isAuth) {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => Login(),
      ));
    }
  }

  _showMsg(String content) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(content)));
  }

  void _togglePage() {
    if (isPage1) {
      if (_deskripsiController.text.isEmpty || temaValue == null) {
        _showMsg("Tolong isi semua form yang dibutuhkan sebelum melanjutkan");
        return;
      } else {
        setState(() {
          isPage1 = !isPage1;
        });
        return;
      }
    }
    setState(() {
      isPage1 = !isPage1;
    });
  }

  void _sendJadwal() async {
    setState(() {
      _isLoading = true;
    });
    final tema = temaValue!;
    final tgl = "${_tanggalController.text} ${_waktuController.text}";
    final tmpt = _tempatController.text;
    final deskripsi = _deskripsiController.text;
    final jenisKarir = karirValue ?? "";
    if (tema == "Bimbingan Karir" && jenisKarir.isEmpty) {
      _showMsg(
          "Jika Anda Memilih Bimbingan Karir Sebagai Tema, Pastikan Mengisi Field Jenis Karir");
      return;
    }
    if (_tanggalController.text.isEmpty ||
        _waktuController.text.isEmpty ||
        tmpt.isEmpty ||
        deskripsi.isEmpty ||
        tema.isEmpty) {
      _showMsg("pastikan telah mengisi field yang diperlukan sebelum mengirim");
      return;
    }
    var data = {
      'user_id': user_id,
      'tema': tema,
      'tgl': tgl,
      'tmpt': tmpt,
      'deskripsi': deskripsi,
      'jenis_karir': jenisKarir,
    };

    final res = await Network().postRequest(
      route: '/store_pertemuan',
      data: data,
    );

    final response = jsonDecode(res.body);

    if (response['status'] == 200) {
      Get.offAll(() => ResponseView(data: response));
    } else {
      Get.offAll(() => ResponseView(data: response));
    }
  }

  _showDatePicker(TextEditingController controller) {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2022),
      lastDate: DateTime(2024),
    ).then((value) {
      setState(() {
        _dateTime = value!;
        String onlyDate =
            '${_dateTime.year}-${_dateTime.month.toString().padLeft(2, '0')}-${_dateTime.day.toString().padLeft(2, '0')}';
        controller.text = onlyDate;
      });
    });
  }

  _showTimePicker(TextEditingController controller) {
    showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    ).then((value) {
      setState(() {
        var df = DateFormat("h:mma");
        _timeOfDay = value!;
        String formattedTime12 = _timeOfDay
            .format(context)
            .toString(); // Format waktu dengan format 24 jam
        formattedTime12 = formattedTime12.replaceAll(" ", "");
        var dt = df.parse(formattedTime12);
        controller.text = DateFormat('HH:mm').format(dt);
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _checkIfLoggedIn();
    // print(pertemuanStream);
  }

  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            body: ListView(
      children: [
        Container(
          height: 720,
          child: Stack(
            children: [
              Container(
                height: MediaQuery.of(context).size.height / 2,
                padding:
                    const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
                decoration: const BoxDecoration(
                  color: bluePrimary,
                  borderRadius:
                      BorderRadius.vertical(bottom: Radius.circular(50)),
                ),
                child: DefaultTextStyle(
                  style: TextStyle(color: whiteFont),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Buat Jadwal",
                            textAlign: TextAlign.left,
                            style: GoogleFonts.nunito(
                                fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10000),
                            ),
                            child: const Image(
                              image: AssetImage('img/Profile.png'),
                              width: 50,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                height: MediaQuery.of(context).size.height,
                top: 140,
                child: Container(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    child: Container(
                      width: MediaQuery.of(context).size.width - 45,
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 25, vertical: 20),
                      decoration: const BoxDecoration(
                          color: whiteBg,
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                      child: Theme(
                        data: Theme.of(context).copyWith(
                          iconTheme: const IconThemeData(
                            size: 14, // Ukuran ikon
                            weight: 0.1,
                            color: bluePrimary, // Warna ikon
                          ),
                        ),
                        child: Column(
                          children: [
                            // =================================================================
                            Visibility(
                              visible: isPage1,
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Ceritakan Masalahmu",
                                        style: GoogleFonts.nunito(
                                            fontSize: 20,
                                            color: bluePrimary,
                                            fontWeight: FontWeight.w700),
                                      ),
                                      const Icon(
                                        Icons.info,
                                        color: bluePrimary,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Padding(
                                        padding:
                                            EdgeInsets.only(left: 10, top: 5),
                                        child: Text(
                                          "Kamu Sebagai",
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: bluePrimary,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                      TextFieldInput(
                                        hintText: "username",
                                        textInputType: TextInputType.text,
                                        textEditingController:
                                            _usernameController,
                                        enabled: false,
                                        icon: const Icon(Icons.person),
                                      ),
                                      const Padding(
                                        padding:
                                            EdgeInsets.only(left: 10, top: 5),
                                        child: Text(
                                          "Tema",
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: bluePrimary,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                      DropdownInput(
                                        value: temaValue,
                                        items: temaItems,
                                        hintText: 'Select an option',
                                        onChanged: (value) {
                                          temaValue = value;
                                        },
                                      ),
                                      const Padding(
                                        padding:
                                            EdgeInsets.only(left: 10, top: 5),
                                        child: Text(
                                          "Deskripsi",
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: bluePrimary,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                      TextFieldInput(
                                        hintText: "masalah kamu",
                                        textInputType: TextInputType.text,
                                        textEditingController:
                                            _deskripsiController,
                                        icon: const Icon(
                                            Icons.library_books_sharp),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              Get.back();
                                            },
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 13,
                                                      vertical: 6),
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 20),
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                    color:
                                                        bluePrimary, // Warna border
                                                    width: 2.0, // Lebar border
                                                  ),
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                          Radius.circular(
                                                              10000))),
                                              child: const Center(
                                                child: Text(
                                                  "Batalkan ",
                                                  style: TextStyle(
                                                    color: bluePrimary,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              _togglePage();
                                            },
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 15,
                                                      vertical: 8),
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 20),
                                              decoration: const BoxDecoration(
                                                  color: bluePrimary,
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(
                                                              10000))),
                                              child: const Center(
                                                child: Text(
                                                  "Berikutnya",
                                                  style: TextStyle(
                                                    color: whiteFont,
                                                    fontSize: 13,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const Text(
                                        "01/02 Pages",
                                        style: TextStyle(
                                          color: accGrey,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            //  ================================================================
                            Visibility(
                              visible: !isPage1,
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Tinggal satu langkah lagi",
                                        style: GoogleFonts.nunito(
                                            fontSize: 20,
                                            color: bluePrimary,
                                            fontWeight: FontWeight.w700),
                                      ),
                                      const Icon(
                                        Icons.info,
                                        color: bluePrimary,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Padding(
                                        padding:
                                            EdgeInsets.only(left: 10, top: 5),
                                        child: Text(
                                          "Tempat Ketemuan",
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: bluePrimary,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                      TextFieldInput(
                                        hintText: "kamu nyaman dimana?",
                                        textInputType: TextInputType.text,
                                        textEditingController:
                                            _tempatController,
                                        icon: const Icon(Icons.location_on),
                                      ),
                                      Visibility(
                                        visible: temaValue == 'Bimbingan Karir',
                                        child: SizedBox(
                                          width: double.infinity,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const Padding(
                                                padding: EdgeInsets.only(
                                                    left: 10, top: 5),
                                                child: Text(
                                                  "Jenis Karir",
                                                  textAlign: TextAlign.start,
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    color: bluePrimary,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ),
                                              DropdownInput(
                                                value: karirValue,
                                                items: karirItems,
                                                hintText: 'pilih jenis karir',
                                                onChanged: (value) {
                                                  karirValue = value;
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      const Padding(
                                        padding:
                                            EdgeInsets.only(left: 10, top: 5),
                                        child: Text(
                                          "Tanggal",
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: bluePrimary,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          if (!isPage1) {
                                            _showDatePicker(_tanggalController);
                                          }
                                        },
                                        child: TextFieldInput(
                                          hintText: "pilih tanggal yang sesuai",
                                          textInputType: TextInputType.text,
                                          enabled: false,
                                          textEditingController:
                                              _tanggalController,
                                          icon: const Icon(
                                              Icons.date_range_outlined),
                                        ),
                                      ),
                                      const Padding(
                                        padding:
                                            EdgeInsets.only(left: 10, top: 5),
                                        child: Text(
                                          "Waktu",
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: bluePrimary,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          if (!isPage1) {
                                            _showTimePicker(_waktuController);
                                          }
                                        },
                                        child: TextFieldInput(
                                          hintText: "pilih jam yang sesuai",
                                          textInputType: TextInputType.text,
                                          enabled: false,
                                          textEditingController:
                                              _waktuController,
                                          icon:
                                              const Icon(Icons.timelapse_sharp),
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              _togglePage();
                                            },
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 13,
                                                      vertical: 6),
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 20),
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                    color:
                                                        bluePrimary, // Warna border
                                                    width: 2.0, // Lebar border
                                                  ),
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                          Radius.circular(
                                                              10000))),
                                              child: const Center(
                                                child: Text(
                                                  "Kembali",
                                                  style: TextStyle(
                                                    color: bluePrimary,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              _sendJadwal();
                                            },
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 15,
                                                      vertical: 8),
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 20),
                                              decoration: const BoxDecoration(
                                                  color: bluePrimary,
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(
                                                              10000))),
                                              child: const Center(
                                                child: Text(
                                                  "Kirim",
                                                  style: TextStyle(
                                                    color: whiteFont,
                                                    fontSize: 13,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const Text(
                                        "02/02 Pages",
                                        style: TextStyle(
                                          color: accGrey,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Text(
                                        "Ini akan dikirimkan ke guru bk yang terdaftar di kelasmu",
                                        style: GoogleFonts.nunito(
                                          color: accGrey,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Text(
                                        "Cek profil akun",
                                        textAlign: TextAlign.left,
                                        style: GoogleFonts.nunito(
                                            color: bluePrimary,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w700),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    )),
              ),
            ],
          ),
        ),
      ],
    )));
  }
}
