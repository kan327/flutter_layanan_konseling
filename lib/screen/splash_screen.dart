import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:layanan_konseling/screen/login.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:layanan_konseling/utils/colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  int activeIndex = 0;
  final widgets = [
    Container(
      padding: EdgeInsets.symmetric(horizontal: 50),
      child: Center(
        child: Column(
          children: [
            Text(
              "Welcome back!",
              textAlign: TextAlign.center,
              style: GoogleFonts.nunito(
                  color: bluePrimary,
                  fontSize: 20,
                  fontWeight: FontWeight.w600),
            ),
            Text.rich(
              TextSpan(
                text: 'Login with your account ',
                style: GoogleFonts.nunito(
                  color: accGrey,
                  fontSize: 14,
                ),
                children: [
                  TextSpan(
                    text: 'Layanan-Konseling',
                    style: GoogleFonts.nunito(
                        color: accGrey,
                        fontSize: 14,
                        fontWeight: FontWeight.w800),
                  ),
                  TextSpan(
                    text: ' make you know the notification',
                    style: GoogleFonts.nunito(
                      color: accGrey,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            )
          ],
        ),
      ),
    ),
    Container(
      padding: EdgeInsets.symmetric(horizontal: 50),
      child: Center(
        child: Column(
          children: [
            Text(
              "Check Your \n Appointment Today!",
              textAlign: TextAlign.center,
              style: GoogleFonts.nunito(
                  color: bluePrimary,
                  fontSize: 20,
                  fontWeight: FontWeight.w600),
            ),
            Text.rich(
              TextSpan(
                text: 'Login with your account ',
                style: GoogleFonts.nunito(
                  color: accGrey,
                  fontSize: 14,
                ),
                children: [
                  TextSpan(
                    text: 'NameApp',
                    style: GoogleFonts.nunito(
                        color: accGrey,
                        fontSize: 14,
                        fontWeight: FontWeight.w800),
                  ),
                  TextSpan(
                    text: ' make you know the notification',
                    style: GoogleFonts.nunito(
                      color: accGrey,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            )
          ],
        ),
      ),
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Flexible(flex: 2, child: Container()),
            Center(
              child: Image(
                image: AssetImage('img/splash_screen.png'),
                width: MediaQuery.of(context).size.width / 2 > 320
                    ? 400
                    : MediaQuery.of(context).size.width / 2,
                fit: BoxFit.contain,
              ),
            ),
            Flexible(flex: 1, child: Container()),
            Container(
              // margin: EdgeInsets.symmetric(vertical: 40),
              child: CarouselSlider.builder(
                itemCount: widgets.length,
                options: CarouselOptions(
                  viewportFraction: 1,
                  aspectRatio: 30 / 15, // Atur rasio aspek sesuai kebutuhan
                  autoPlay: true,
                  enlargeCenterPage: true,
                  enableInfiniteScroll: false,
                  autoPlayInterval: Duration(seconds: 3),
                  onPageChanged: (index, reason) {
                    setState(() {
                      activeIndex = index;
                    });
                  },
                ),
                itemBuilder: (_, index, realIndex) {
                  final widget = widgets[index];

                  return buildImage(widget, index);
                },
              ),
            ),
            Flexible(flex: 1, child: Container()),
            Flexible(
              flex: 2,
              child: buildIndicator(),
            ),
            Flexible(flex: 3, child: Container()),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 50),
              child: Ink(
                decoration: BoxDecoration(
                  color: bluePrimary,
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                ),
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => Login(),
                    ));
                  },
                  splashColor: accGrey, // Warna animasi saat ditap
                  child: Container(
                    padding: EdgeInsets.fromLTRB(20, 8, 12, 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Next",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.nunito(
                            color: whiteFont,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const Icon(
                          Icons.arrow_forward_rounded,
                          color: whiteFont,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildImage(Widget widget, int index) {
    return Container(
      // margin: EdgeInsets.symmetric(horizontal: 15),
      width: double.infinity,
      child: widget,
    );
  }

  Widget buildIndicator() => AnimatedSmoothIndicator(
        activeIndex: activeIndex,
        count: widgets.length,
        effect: const WormEffect(
          activeDotColor: bluePrimary, // Warna indikator aktif
          dotColor: accGrey, // Warna indikator tidak aktif
          dotWidth: 10,
          dotHeight: 10,
        ),
      );
}
