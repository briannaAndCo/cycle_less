library app_defaults;

import 'package:flutter/material.dart';

import 'widgets/loading_dialog.dart';

Color getPrimarySwatchColor() {
  return Colors.blueGrey;
}

Color getCanvasColor() {
  return Colors.blueGrey[700];
}

Color getIconColor() {
  return Colors.white70;
}

Color getPrimaryTextColor() {
  return Colors.white70;
}

Color getDialogBackgroundColor() {
  return Colors.black54;
}

Color getCardColor() {
  return Colors.black26;
}

double getPrimaryFontSize() {
  return 18;
}

double getSecondaryFontSize() {
  return 14;
}

showLoading(context) async {
  // show the dialog
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return LoadingDialog();
    },
  );
}

hideLoading(context) {
  WidgetsBinding.instance.addPostFrameCallback((_) async {
    Navigator.pop(context);
  });
}
