import 'dart:async';
import 'package:flutter/material.dart';

class TestPage3 extends StatefulWidget {
  const TestPage3({super.key, required this.title});

  final String title;

  @override
  State<TestPage3> createState() => _TestPage3State();
}

class _TestPage3State extends State<TestPage3> {
  Future<int>? totalPriceFuture;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Container(
        alignment: Alignment.center,
        child: const Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Card(
              elevation: 5,
              margin: EdgeInsets.all(10),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  SizedBox(
                    width: double.infinity,
                  ),
                  Text(
                    'ぺーじ3',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
