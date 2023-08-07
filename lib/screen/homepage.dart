import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:layanan_konseling/screen/addJadwal.dart';
import 'package:layanan_konseling/screen/detailJadwal.dart';
import 'package:layanan_konseling/screen/login.dart';
import 'package:layanan_konseling/utils/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:layanan_konseling/network/api.dart';
import 'package:dropdown_search/dropdown_search.dart';

class HomepageController extends GetxController {
  bool isAuth = false;
  dynamic user = {
    'id': 1,
    'nama': '...',
    'nip': 000,
    'jk': 'L',
    'email': '...',
    'profile': 'http://127.0.0.1:8005/img/profile.png',
    'ket': null,
    'role': '...',
    'created_at': '...',
    'updated_at': '...',
  }.obs;

  Rx<Stream<List<dynamic>>?> pertemuanStream = Rx<Stream<List<dynamic>>?>(null);
  late SharedPreferences sharedPreferences;
  dynamic fetchData() async {
    sharedPreferences = await SharedPreferences.getInstance();
    dynamic pertemuanList;
    final res = await Network().postRequest(
      route: '/pertemuan',
      data: {
        'id': sharedPreferences.getInt('userId'),
      },
    );
    final responseData = jsonDecode(res.body);

    if (responseData['status'] == 200) {
      dynamic data = responseData['data'] as Map<String, dynamic>;
      user = data['user'];
      pertemuanList = (data['data'] as List<dynamic>).toList();
      pertemuanStream.value = Stream.value(pertemuanList);
    } else {
      pertemuanStream.value = Stream.value([]);
    }
    return pertemuanList;
  }

  void _checkIfLoggedIn() async {
    sharedPreferences = await SharedPreferences.getInstance();
    var token = sharedPreferences.getString('token');
    if (token != null) {
      isAuth = true;
    }
    if (!isAuth) {
      Get.offAll(() => Login());
    }
  }
  void cancelStream() {
    pertemuanStream.close();
  }

  @override
  void onClose() {
    cancelStream(); // Pastikan stream di-cancel saat controller ditutup
    super.onClose();
  }

  @override
  void onInit() {
    super.onInit();
    fetchData();
  }
}

class Homepage extends StatefulWidget {
  Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final HomepageController _controller = Get.put(HomepageController());
  dynamic lastData;
//  void loadData() async {
//       dynamic newdata = await _controller.fetchData();
//       _controller._checkIfLoggedIn();
//       setState(() {
//         _controller.pertemuanStream.value = Stream.value(newdata); ////////////////// whyrhhhhhh?????????????? DO NOT DEAL WITH ME ABOUT THIS
//       });
//  }
  @override
  void initState() {
    super.initState();
    // loadData();
    // Timer(Duration(seconds: 5), () async {
    //   // Tindakan yang ingin Anda lakukan setelah 5 detik
    //   dynamic newdata = await _controller.fetchData();
    //   _controller._checkIfLoggedIn();
    //   setState(() {
    //     _controller.pertemuanStream.value = Stream.value(newdata); ////////////////// whyrhhhhhh?????????????? DO NOT DEAL WITH ME ABOUT THIS
    //   });
    // });
    Timer.periodic(Duration(seconds: 5), (timer) async {
      dynamic newdata = await _controller.fetchData();
      _controller._checkIfLoggedIn();
      setState(() {
        _controller.pertemuanStream.value = Stream.value(newdata); ////////////////// whyrhhhhhh?????????????? DO NOT DEAL WITH ME ABOUT THIS
      });
    });
    // print(pertemuanStream);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: ListView(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
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
                          "Homepage",
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
                          // child: Image.network(
                          //   "${user['profile']}",
                          //   width: 50,
                          //   fit: BoxFit.contain,
                          // ),
                          child: const Image(
                            image: AssetImage('img/Profile.png'),
                            width: 50,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(0, 30, 0, 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text.rich(
                            TextSpan(
                                text: 'Hai, ',
                                style: GoogleFonts.nunito(
                                  fontSize: 20,
                                ),
                                children: [
                                  TextSpan(
                                    text: "${_controller.user['nama']}",
                                    style: GoogleFonts.nunito(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w700),
                                  ),
                                ]),
                            textAlign: TextAlign.left,
                          ),
                          const Text(
                            "Have a nice day!",
                            style: TextStyle(
                              color: accGrey,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    // width: 300,
                    decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(20)),
                        border: Border.all(
                          color: bluePrimary,
                          width: 2,
                        )),
                    child: DefaultTextStyle(
                      style: TextStyle(color: bluePrimary),
                      child: Stack(
                        // alignment: Alignment.centerRight,
                        children: [
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(20),
                            child: const Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Welcome!",
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    "Let’s see your schedule your \nAppointment.",
                                    style: TextStyle(
                                      fontSize: 12,
                                    ),
                                  )
                                ]),
                          ),
                          const Positioned(
                            right: 5,
                            top: 8,
                            child: Image(
                              image: AssetImage('img/side_img.png'),
                              width: 110,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          _controller.isAuth
                              ? Get.to(() => addJadwal())
                              : Get.to(() => const Login());
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 13, vertical: 6),
                          margin: const EdgeInsets.symmetric(vertical: 20),
                          decoration: BoxDecoration(
                              border: Border.all(
                                color: bluePrimary, // Warna border
                                width: 2.0, // Lebar border
                              ),
                              borderRadius: const BorderRadius.all(
                                  Radius.circular(10000))),
                          child: Theme(
                            data: Theme.of(context).copyWith(
                              iconTheme: const IconThemeData(
                                size: 12, // Ukuran ikon
                                weight: 0.1,
                                color: bluePrimary, // Warna ikon
                              ),
                            ),
                            child: const Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Add jadwal",
                                  style: TextStyle(
                                    color: bluePrimary,
                                    fontSize: 12,
                                  ),
                                ),
                                SizedBox(
                                  width: 3,
                                ),
                                Icon(
                                  Icons.add,
                                  color: bluePrimary,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 8),
                        margin: const EdgeInsets.symmetric(vertical: 20),
                        decoration: const BoxDecoration(
                            color: bluePrimary,
                            borderRadius:
                                BorderRadius.all(Radius.circular(10000))),
                        child: Theme(
                          data: Theme.of(context).copyWith(
                            iconTheme: const IconThemeData(
                              size: 12, // Ukuran ikon
                              weight: 0.1,
                              color: whiteFont, // Warna ikon
                            ),
                          ),
                          child: const Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Date",
                                style: TextStyle(
                                  color: whiteFont,
                                  fontSize: 13,
                                ),
                              ),
                              SizedBox(
                                width: 3,
                              ),
                              Icon(
                                Icons.date_range_sharp,
                                color: whiteFont,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Schedule Draft",
                        textAlign: TextAlign.left,
                        style: GoogleFonts.nunito(
                            color: bluePrimary,
                            fontSize: 14,
                            fontWeight: FontWeight.w700),
                      ),
                      Text(
                        "view all",
                        textAlign: TextAlign.left,
                        style: GoogleFonts.nunito(
                            color: accGrey,
                            fontSize: 14,
                            fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 15),
                    height: 400,
                    child: StreamBuilder<List<dynamic>>(
                      stream: _controller.pertemuanStream.value,
                      builder: (context, snapshot) {
                        print(
                            "=====================================================================================");
                        print(_controller.user['nama']);
                        print(
                            "=====================================================================================");
                        print(_controller.pertemuanStream);
                        // print(snapshot);
                        if (snapshot.hasData) {
                          final pertemuanList = snapshot.data!;
                          return GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 15,
                              mainAxisSpacing: 15,
                            ),
                            itemCount: pertemuanList.length,
                            itemBuilder: (_, int i) {
                              final pertemuan = pertemuanList[i];
                              // print(pertemuan);
                              return DefaultTextStyle(
                                style: TextStyle(color: blackFont),
                                child: InkWell(
                                  onTap: () => Get.to(
                                      () => DetailJadwal(jadwal: pertemuan)),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 15, horizontal: 12),
                                    decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(20)),
                                      border: Border.all(
                                          color: bluePrimary, width: 2),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "${pertemuan['tgl'].substring(0, 10)}",
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            Icon(
                                              Icons.more_vert_sharp,
                                              color: blackFont,
                                            ),
                                          ],
                                        ),
                                        Flexible(flex: 1, child: Container()),
                                        Text(
                                          "${pertemuan['tema']}",
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        Text(
                                          "${pertemuan['status']}",
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        Flexible(flex: 2, child: Container()),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Text(
                                              "Details",
                                              style: TextStyle(
                                                fontSize: 10,
                                                color: mateGrey,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        } else if (snapshot.hasError) {
                          return Text("Error: ${snapshot.error}");
                        } else {
                          return Center(
                              child: Text(
                                  "tidak ada data, atau tunggu sebentar :3"));
                        }
                      },
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
