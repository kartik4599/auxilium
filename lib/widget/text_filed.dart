import 'package:flutter/material.dart';
import 'package:instagram_demo/utils/color.dart';

class TextFormInput extends StatelessWidget {
  final TextEditingController textEditingController;
  final bool obscure;
  final String hintText;
  final String lableText;
  final TextInputType textInputType;
  const TextFormInput(
      {Key? key,
      required this.textEditingController,
      this.obscure = false,
      required this.hintText,
      required this.lableText,
      required this.textInputType})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final inputBorder = OutlineInputBorder(
        borderSide: Divider.createBorderSide(context),
        borderRadius: BorderRadius.circular(20));
    return TextField(
      controller: textEditingController,
      decoration: InputDecoration(
          // fillColor: Colors.grey,
          labelStyle: const TextStyle(
              color: darkGreenColor, fontWeight: FontWeight.bold, fontSize: 17),
          hintStyle: const TextStyle(color: lightGreenColor, fontSize: 14),
          labelText: lableText,
          hintText: hintText,
          border: inputBorder,
          focusedBorder: inputBorder,
          enabledBorder: inputBorder,
          filled: true,
          contentPadding: const EdgeInsets.all(15)),
      keyboardType: textInputType,
      obscureText: obscure,
    );
  }
}
