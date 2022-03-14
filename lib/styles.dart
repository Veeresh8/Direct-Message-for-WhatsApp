import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ButtonStyle buildPrimaryButton() {
  return ElevatedButton.styleFrom(
    primary: Colors.black,
    onPrimary: Colors.white,
    shadowColor: Colors.grey,
    elevation: 4,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.0)),
    minimumSize: const Size(300, 50),
  );
}

ButtonStyle buildDialogButton() {
  return ElevatedButton.styleFrom(
    primary: Colors.black,
    onPrimary: Colors.white,
    shadowColor: Colors.grey,
    elevation: 4,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.0)),
    minimumSize: const Size(100, 50),
  );
}

TextStyle buildMontserrat(
    BuildContext context,
    Color color,
    FontWeight fontWeight,
    TextStyle? textStyle,
    ) {
  return GoogleFonts.montserrat(
      textStyle: textStyle, fontWeight: fontWeight, color: color);
}

TextStyle buildMontserratUnderline(
    BuildContext context,
    Color color,
    FontWeight fontWeight,
    TextStyle? textStyle,
    ) {
  return GoogleFonts.montserrat(
      textStyle: textStyle, fontWeight: fontWeight, color: color, decoration: TextDecoration.underline);
}