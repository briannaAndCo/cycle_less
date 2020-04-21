import 'package:flutter/material.dart';
import '../app_defaults.dart' as AppConstants;

class LoadingDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SimpleDialog(children: <Widget>[
      Center(
        child: Column(children: [
          CircularProgressIndicator(),
          SizedBox(height: 20),
          Text("Loading")
        ]),
      )
    ]);
  }
}
