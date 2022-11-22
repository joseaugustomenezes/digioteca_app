import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EmptyScreen extends GetView {
  final String message;

  EmptyScreen({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            'assets/img/download.png',
            color: Colors.teal,
            scale: 2,
          ),
          Container(
            child: Text(
              message,
              style: TextStyle(
                  fontSize: 18,
                  color: Colors.blueGrey,
                  fontWeight: FontWeight.bold),
            ),
          )
        ],
      ),
    );
  }
}
