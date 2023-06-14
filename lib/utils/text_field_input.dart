import 'package:flutter/material.dart';
import 'package:layanan_konseling/utils/colors.dart';

class TextFieldInput extends StatelessWidget {
  final TextEditingController textEditingController;
  final bool isPass;
  final String hintText;
  final TextInputType textInputType;

  const TextFieldInput({
    Key? key,
    required this.hintText,
    required this.textInputType,
    required this.textEditingController,
    this.isPass = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(11),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            offset: Offset(0, 2),
            blurRadius: 12,
          ),
        ],
      ),
      child: TextField(
        controller: textEditingController,
        cursorColor: bluePrimary,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(
            color: accGrey,
            fontWeight: FontWeight.normal,
          ),
          filled: true,
          fillColor: Colors.white, // Warna latar belakang
          contentPadding:
              const EdgeInsets.fromLTRB(12, 8, 8, 8), // Padding sebelah kiri
          border: InputBorder.none, // Menghilangkan border
          suffixIcon: textInputType == TextInputType.emailAddress
              ? Icon(
                  Icons.email,
                  color: accGrey,
                )
              : Icon(
                  Icons.lock,
                  color: accGrey,
                ),
        ),
        keyboardType: textInputType,
        obscureText: isPass,
      ),
    );
  }
}
