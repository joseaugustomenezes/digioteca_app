import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Loading extends GetView {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 20,
      height: 20,
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        strokeWidth: 2,
      ),
    );
  }
}
