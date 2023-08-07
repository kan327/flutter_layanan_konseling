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

class UpdateJadwal extends StatefulWidget {
  dynamic jadwal;
  UpdateJadwal({super.key, required this.jadwal});

  @override
  State<UpdateJadwal> createState() => _UpdateJadwalState();
}

class _UpdateJadwalState extends State<UpdateJadwal> {

  dynamic jadwal;
  bool isAccept = false;
  final TextEditingController _kesimpulanController = TextEditingController();
  final TextEditingController _tempatController = TextEditingController();
  final TextEditingController _tanggalController = TextEditingController();
  final TextEditingController _waktuController = TextEditingController();

  DateTime _dateTime = DateTime.now();
  TimeOfDay _timeOfDay = TimeOfDay(hour: 8, minute: 30);
  late SharedPreferences sharedPreferences;
  bool isAuth = false;
  bool _isLoading = false;
  late int guru_id;
  @override
  void _checkIfLoggedIn() async {
    sharedPreferences = await SharedPreferences.getInstance();
    var token = sharedPreferences.getString('token');
    if (token != null) {
      if (mounted) {
        setState(() {
          jadwal = widget.jadwal;
          if(jadwal['status'] == 'pending' || jadwal['status'] == 'accept'){
            isAccept = true;
          }
          isAuth = true;
          guru_id = sharedPreferences.getInt('userId')!;
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

  void _tundaJadwal() async {
    setState(() {
      _isLoading = true;
    });
    final tgl = "${_tanggalController.text} ${_waktuController.text}";
    final tmpt = _tempatController.text;
    final kesimpulan = _kesimpulanController.text;
    if (_tanggalController.text.isEmpty ||
        _waktuController.text.isEmpty ||
        tmpt.isEmpty) {
        if(jadwal['status'] != 'pending' && jadwal['status'] != 'accept'){
          _showMsg("pastikan telah mengisi field yang diperlukan sebelum mengirim ${jadwal['status'] }");
          return;

        }
    }
    if(kesimpulan.isEmpty && jadwal['status'] == 'pending' || kesimpulan.isEmpty && jadwal['status'] == 'accept'){
      _showMsg("pastikan telah mengisi field kesimpulan sebelum mengirim");
      return;
    }
    var data = {
      'id': jadwal['id'],
      'guru_id': guru_id,
      'tgl': tgl,
      'tmpt': tmpt,
      'status': 'pending',
    };
    if(jadwal['status'] == 'pending' || jadwal['status'] == 'accept'){
      data['kesimpulan'] = kesimpulan;
      data['status'] = 'done';
    }
    

    final res = await Network().postRequest(
      route: '/update_pertemuan',
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
                            "Update Jadwal",
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
                        child: isAccept
                        ? Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Masukan Hasil Pertemuan",
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
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.only(left: 10, top: 5),
                                  child: Text(
                                    "Kesimpulan",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: bluePrimary,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                TextFieldInput(
                                  hintText: "kesimpulan dari pertemuan tersebut",
                                  textInputType: TextInputType.text,
                                  textEditingController: _kesimpulanController,
                                  icon: const Icon(Icons.menu_book),
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
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 13, vertical: 6),
                                        margin: const EdgeInsets.symmetric(
                                            vertical: 20),
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                              color:
                                                  bluePrimary, // Warna border
                                              width: 2.0, // Lebar border
                                            ),
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(10000))),
                                        child: const Center(
                                          child: Text(
                                            "Batalkan",
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
                                        _tundaJadwal();
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 15, vertical: 8),
                                        margin: const EdgeInsets.symmetric(
                                            vertical: 20),
                                        decoration: const BoxDecoration(
                                            color: greenPrimary,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10000))),
                                        child: const Center(
                                          child: Text(
                                            "Selesaikan Jadwal",
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
                                  "01/01 Pages",
                                  style: TextStyle(
                                    color: accGrey,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  "Anda akan menyelesaikan jadwal ini, pastikan untuk memberikan kesimpulan yang tepat",
                                  style: GoogleFonts.nunito(
                                    color: accGrey,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        )
                        : Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Masukan Jadwal Baru",
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
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.only(left: 10, top: 5),
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
                                  hintText: "pastikan tempat ini dapat dikunjungi",
                                  textInputType: TextInputType.text,
                                  textEditingController: _tempatController,
                                  icon: const Icon(Icons.location_on),
                                ),
                                const Padding(
                                  padding: EdgeInsets.only(left: 10, top: 5),
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
                                    _showDatePicker(_tanggalController);
                                  },
                                  child: TextFieldInput(
                                    hintText: "pilih tanggal yang sesuai",
                                    textInputType: TextInputType.text,
                                    enabled: false,
                                    textEditingController: _tanggalController,
                                    icon: const Icon(Icons.date_range_outlined),
                                  ),
                                ),
                                const Padding(
                                  padding: EdgeInsets.only(left: 10, top: 5),
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
                                    _showTimePicker(_waktuController);
                                  },
                                  child: TextFieldInput(
                                    hintText: "pilih jam yang sesuai",
                                    textInputType: TextInputType.text,
                                    enabled: false,
                                    textEditingController: _waktuController,
                                    icon: const Icon(Icons.timelapse_sharp),
                                  ),
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
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 13, vertical: 6),
                                        margin: const EdgeInsets.symmetric(
                                            vertical: 20),
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                              color:
                                                  bluePrimary, // Warna border
                                              width: 2.0, // Lebar border
                                            ),
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(10000))),
                                        child: const Center(
                                          child: Text(
                                            "Batalkan",
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
                                        _tundaJadwal();
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 15, vertical: 8),
                                        margin: const EdgeInsets.symmetric(
                                            vertical: 20),
                                        decoration: const BoxDecoration(
                                            color: redPrimary,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10000))),
                                        child: const Center(
                                          child: Text(
                                            "Tunda Jadwal",
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
                                  "01/01 Pages",
                                  style: TextStyle(
                                    color: accGrey,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  "Anda akan menunda jadwal murid, pastikan untuk memberikan jadwal yang tepat dengan waktu anda",
                                  style: GoogleFonts.nunito(
                                    color: accGrey,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
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
