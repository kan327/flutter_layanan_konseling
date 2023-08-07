import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:layanan_konseling/screen/homepage.dart';
import 'package:layanan_konseling/utils/colors.dart';

class ResponseView extends StatelessWidget {
  dynamic data;
  ResponseView({super.key, required this.data});

  // final HomepageController _acontroller = Get.find();

  @override
  Widget build(BuildContext context) {
    bool success = data['status'] == 200;
    return SafeArea(
        child: Scaffold(
            body: ListView(
      children: [
        Container(
          height: 700,
          child: Stack(
            children: [
              Container(
                height: MediaQuery.of(context).size.height / 2,
                width: MediaQuery.of(context).size.width,
                padding:
                    const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
                decoration: const BoxDecoration(
                  color: bluePrimary,
                  borderRadius:
                      BorderRadius.vertical(bottom: Radius.circular(50)),
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
                          horizontal: 25, vertical: 50),
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
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // Flexible(flex: 1, child: Container()),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 30,
                                    height: 10,
                                    decoration: BoxDecoration(
                                        color: success
                                            ? bluePrimary
                                            : warningPrimary,
                                        borderRadius:
                                            BorderRadius.circular(100)),
                                  ),
                                  const SizedBox(
                                    width: 3,
                                  ),
                                  Text(
                                    "${data['messages']}".toUpperCase(),
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.nunito(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700,
                                        color: bluePrimary),
                                  )
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Image(
                                image: AssetImage(success
                                    ? 'img/success.png'
                                    : 'img/failed.png'),
                                fit: BoxFit.contain,
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                              Container(
                                width: 250,
                                child: Column(
                                  children: [
                                    Text(
                                      "${data['data']['head_response']}",
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.nunito(
                                          fontSize: 20,
                                          color: bluePrimary,
                                          fontWeight: FontWeight.w700),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      "${data['data']['body_response']}",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: accGrey,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 50,
                              ),
                              GestureDetector(
                                onTap: () {
                                  Get.offAll(() => Homepage());
                                },
                                child: Container(
                                  width: 100,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 13, vertical: 6),
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 20),
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                        color: bluePrimary, // Warna border
                                        width: 2.0, // Lebar border
                                      ),
                                      borderRadius: const BorderRadius.all(
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
                              Flexible(flex: 2, child: Container()),
                            ],
                          )),
                    )),
              ),
            ],
          ),
        ),
      ],
    )));
  }
}
