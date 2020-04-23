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

LoadingDialog _loadingDialog;

showLoading(context) {
  if (_loadingDialog == null) {
    // set up the dialog to update the number
    _loadingDialog = LoadingDialog();
    // show the dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return _loadingDialog;
      },
    );
  }
}

hideLoading(context) {
  if (_loadingDialog != null) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      Navigator.pop(context);
    });
    _loadingDialog = null;
  }
}
