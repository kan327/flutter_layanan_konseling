import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:layanan_konseling/network/api.dart';
import 'package:layanan_konseling/screen/response.dart';
import 'package:layanan_konseling/screen/updateJadwal.dart';
import 'package:layanan_konseling/utils/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DetailJadwal extends StatefulWidget {
  dynamic jadwal;
  DetailJadwal({super.key, this.jadwal});

  @override
  State<DetailJadwal> createState() => _DetailJadwalState();
}

class _DetailJadwalState extends State<DetailJadwal> {
  dynamic jadwal = null;
  bool isGuru = false;
  late int guru_id;
  late SharedPreferences sharedPreferences;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      jadwal = widget.jadwal;
      LoadisGuru();
    });
  }

  void LoadisGuru() async {
    sharedPreferences = await SharedPreferences.getInstance();
    String? role = sharedPreferences.getString('userRole');
    guru_id = sharedPreferences.getInt('userId')!;
    setState(() {
      isGuru = role == 'guru';
    });
    print(sharedPreferences.getString('userRole') == 'guru');
  }

  bool toolsupdate({except = false}) {
    if (except && isGuru) {
      if (jadwal['status'] == 'accept' || jadwal['status'] == 'pending') {
        return (jadwal['status'] == 'accept' || jadwal['status'] == 'pending');
      } else {
        return false;
      }
    }
    if (isGuru &&
        jadwal['status'] != 'accept' &&
        jadwal['status'] != 'pending' &&
        jadwal['status'] != 'done') {
      return true;
    }
    return false;
  }

  _showMsg(String content) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(content)));
  }

  void _terimaJadwal() async {
    setState(() {
      _isLoading = true;
    });
    var data = {
      'id': jadwal['id'],
      'guru_id': guru_id,
      // 'tgl': jadwal['tgl'],
      // 'tmpt': jadwal['tmpt'],
      'status': 'accept',
    };

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
                            "Lihat Jadwal",
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
                        child: jadwal != null
                            ? Column(children: [
                                Container(
                                  padding: EdgeInsets.symmetric(vertical: 5),
                                  decoration: const BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(
                                    color: accGrey,
                                    width: 2,
                                  ))),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            '${jadwal["tema"]}',
                                            style: GoogleFonts.nunito(
                                                fontSize: 20,
                                                color: bluePrimary,
                                                fontWeight: FontWeight.w700),
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Container(
                                                width: 35,
                                                height: 10,
                                                decoration: BoxDecoration(
                                                    color: jadwal['status'] ==
                                                            'done'
                                                        ? bluePrimary
                                                        : warningPrimary,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            100)),
                                              ),
                                              const SizedBox(
                                                width: 3,
                                              ),
                                              Text(
                                                "${jadwal['status']}"
                                                    .toUpperCase(),
                                                style: GoogleFonts.nunito(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w700,
                                                    color: bluePrimary),
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            "${jadwal['guru']['nama']}",
                                            style: const TextStyle(
                                              color: accGrey,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          Text(
                                            "${jadwal['tgl']}",
                                            style: const TextStyle(
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
                                Container(
                                  margin: EdgeInsets.only(top: 10),
                                  width: double.infinity,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "${jadwal['tmpt']}",
                                        textAlign: TextAlign.left,
                                        style: GoogleFonts.nunito(
                                            color: bluePrimary,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w700),
                                      ),
                                      const SizedBox(
                                        height: 2,
                                      ),
                                      Text(
                                        '${jadwal["deskripsi"]}',
                                        textAlign: TextAlign.left,
                                        style: GoogleFonts.nunito(
                                            fontSize: 12, color: accGrey),
                                      )
                                    ],
                                  ),
                                ),
                                // thanks card
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(15),
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 15),
                                  decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(20)),
                                      border: Border.all(
                                        color: bluePrimary,
                                        width: 2,
                                      )),
                                  child: DefaultTextStyle(
                                    style: TextStyle(color: bluePrimary),
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Terimakasih!",
                                            style: GoogleFonts.nunito(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            "Karena telah percaya pada kami. Tenang aja, data kamu dijamin kerahasiaannya",
                                            style: GoogleFonts.nunito(
                                              fontSize: 12,
                                            ),
                                          )
                                        ]),
                                  ),
                                ),
                                Center(
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Visibility(
                                            visible: toolsupdate(),
                                            child: Wrap(
                                              children: [
                                                GestureDetector(
                                                  onTap: () {
                                                    Get.to(() => UpdateJadwal(
                                                        jadwal: jadwal));
                                                  },
                                                  child: Container(
                                                    width: 100,
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 13,
                                                        vertical: 6),
                                                    margin: const EdgeInsets
                                                            .symmetric(
                                                        vertical: 20),
                                                    decoration: BoxDecoration(
                                                        border: Border.all(
                                                          color:
                                                              redPrimary, // Warna border
                                                          width:
                                                              2.0, // Lebar border
                                                        ),
                                                        borderRadius:
                                                            const BorderRadius
                                                                    .all(
                                                                Radius.circular(
                                                                    10000))),
                                                    child: const Center(
                                                      child: Text(
                                                        "Tunda",
                                                        style: TextStyle(
                                                          color: redPrimary,
                                                          fontSize: 12,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                GestureDetector(
                                                  onTap: () {
                                                    _terimaJadwal();
                                                  },
                                                  child: Container(
                                                    width: 100,
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 13,
                                                        vertical: 6),
                                                    margin: const EdgeInsets
                                                            .symmetric(
                                                        vertical: 20),
                                                    decoration: BoxDecoration(
                                                        border: Border.all(
                                                          color:
                                                              greenPrimary, // Warna border
                                                          width:
                                                              2.0, // Lebar border
                                                        ),
                                                        borderRadius:
                                                            const BorderRadius
                                                                    .all(
                                                                Radius.circular(
                                                                    10000))),
                                                    child: const Center(
                                                      child: Text(
                                                        "Terima",
                                                        style: TextStyle(
                                                          color: greenPrimary,
                                                          fontSize: 12,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      Visibility(
                                        visible: toolsupdate(except: true),
                                        child: GestureDetector(
                                          onTap: () {
                                            Get.to(() => UpdateJadwal(
                                                        jadwal: jadwal));
                                          },
                                          child: Container(
                                            width: 100,
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
                                                borderRadius: const BorderRadius
                                                        .all(
                                                    Radius.circular(10000))),
                                            child: const Center(
                                              child: Text(
                                                "Selesai ",
                                                style: TextStyle(
                                                  color: bluePrimary,
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          Get.back();
                                        },
                                        child: Container(
                                          width: 100,
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
                                              "Kembali ",
                                              style: TextStyle(
                                                color: bluePrimary,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ])
                            : const Center(
                                child: CircularProgressIndicator(),
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
