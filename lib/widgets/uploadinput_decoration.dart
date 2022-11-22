import 'package:cnc_shop/themes/color.dart';
import 'package:flutter/material.dart';

InputDecoration UploadInputDecorationWidget(context, labelText) {
  return InputDecoration(
      filled: true,
      fillColor: Colors.white,
      labelText: labelText,
      labelStyle: TextStyle(
          fontSize: 16.0, fontWeight: FontWeight.w600, color: kColorsBlack),
      contentPadding: new EdgeInsets.symmetric(vertical: 50, horizontal: 90),
      enabledBorder: new OutlineInputBorder(
        borderRadius: new BorderRadius.circular(10),
        borderSide: BorderSide(color: kColorsWhite, width: 1),
      ),
      focusedBorder: new OutlineInputBorder(
        borderRadius: new BorderRadius.circular(10),
        borderSide: BorderSide(color: kColorsWhite, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: new BorderRadius.circular(10),
        borderSide: BorderSide(color: kColorsRed, width: 1),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: new BorderRadius.circular(10),
        borderSide: BorderSide(color: kColorsRed, width: 2),
      ),
      errorStyle: Theme.of(context).textTheme.bodyText1);
}
