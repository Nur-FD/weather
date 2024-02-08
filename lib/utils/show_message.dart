import 'package:flutter/material.dart';

showMg(BuildContext context, String msg) {
  return ScaffoldMessenger.of(context)
      .showSnackBar(SnackBar(content: Text(msg)));
}
