import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sysdev_suretti/pages/login.dart';
import 'testpage3.dart';
import 'package:sysdev_suretti/pages/sign_up.dart';
import 'package:sysdev_suretti/map.dart';


class TestPage1 extends StatefulWidget {
  const TestPage1({super.key});

  final String title = 'Page 1';

  @override
  State<TestPage1> createState() => _TestPage1State();
}

class _TestPage1State extends State<TestPage1> {
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
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Card(
              elevation: 5,
              margin: EdgeInsets.all(10),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  SizedBox(
                    width: double.infinity,
                  ),
                  Text(
                    'ぺーじ１',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
            ),
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) {
                    return const TestPage3(title: 'Page 3');
                  }));
                },
                child: const Text('Go to Page 3')),
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) {
                    return LoginPage(); // LoginPageに遷移
                  }));
                },
                child: const Text('Go to Login')),
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) {
                    return SignupPage(); // SignUpPageに遷移
                  }));
                },
                child: const Text('Go to Sign Up')),
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) {
                    return MapPage(); // MapPageに遷移
                  }));
                },
                child: const Text('Go to Map')), // 新しいボタンを追加
          ],
        ),
      ),
    );
  }
}
