import 'package:flutter/material.dart';
import 'package:layanan_konseling/utils/colors.dart';
import 'package:dropdown_search/dropdown_search.dart';

class TextFieldInput extends StatelessWidget {
  final TextEditingController textEditingController;
  final bool isPass;
  final String hintText;
  final dynamic enabled;
  final TextInputType textInputType;
  final Icon icon;
  dynamic callback;

  TextFieldInput({
    Key? key,
    required this.hintText,
    required this.textInputType,
    required this.textEditingController,
    required this.icon,
    this.isPass = false,
    this.enabled = true,
    this.callback = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (callback == false) {
      callback = () {
        return;
      };
    }
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        color: whiteBg,
        borderRadius: BorderRadius.circular(11),
        boxShadow: [
          BoxShadow(
            color: blackFont.withOpacity(0.12),
            offset: const Offset(0, 2),
            blurRadius: 12,
          ),
        ],
      ),
      child: TextField(
        onTap: callback,
        enabled: enabled,
        controller: textEditingController,
        cursorColor: bluePrimary,
        style: const  TextStyle(color: blackFont),
        decoration: InputDecoration(
            hintText: hintText,
            hintStyle: const TextStyle(
              color: blackFont,
              fontWeight: FontWeight.normal,
            ),
            filled: true,
            fillColor: whiteBg, // Warna latar belakang
            contentPadding:
                const EdgeInsets.fromLTRB(12, 8, 8, 8), // Padding sebelah kiri
            border: InputBorder.none, // Menghilangkan border
            suffixIcon: icon),
        keyboardType: textInputType,
        obscureText: isPass,
      ),
    );
  }
}

class DropdownInput extends StatelessWidget {
  final String? value;
  final List<String> items;
  final String hintText;
  final ValueChanged<String?> onChanged;
  final dynamic enabled;

  const DropdownInput({
    Key? key,
    this.value,
    required this.items,
    required this.hintText,
    required this.onChanged,
    this.enabled = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        color: whiteBg,
        borderRadius: BorderRadius.circular(11),
        boxShadow: [
          BoxShadow(
            color: blackFont.withOpacity(0.12),
            offset: const Offset(0, 2),
            blurRadius: 12,
          ),
        ],
      ),
      child: DropdownButtonFormField<String>(
        value: value,
        items: items.map((item) {
          return DropdownMenuItem<String>(
            value: item,
            child: Text(item),
          );
        }).toList(),
        onChanged: enabled ? onChanged : null,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(
            color: blackFont,
            fontWeight: FontWeight.normal,
          ),
          filled: true,
          fillColor: whiteBg,
          contentPadding: const EdgeInsets.fromLTRB(12, 8, 8, 8),
          border: InputBorder.none,
        ),
      ),
    );
  }
}