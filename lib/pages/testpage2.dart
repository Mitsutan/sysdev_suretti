import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:sysdev_suretti/utils/enum_pages.dart';
import 'package:sysdev_suretti/utils/page_notifier.dart';

class TestPage2 extends StatefulWidget {
  const TestPage2({super.key});

  final String title = 'Page 2';

  @override
  State<TestPage2> createState() => _TestPage2State();
}

class _TestPage2State extends State<TestPage2> {
  Future<int>? totalPriceFuture;
  late PageNotifier pageNotifier;

  @override
  void initState() {
    pageNotifier = PageNotifier();
    super.initState();
  }

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
                    'ぺーじ２',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
            ),
            ElevatedButton(
                onPressed: () {
                  pageNotifier.updateCount(
                      Pages.notice, pageNotifier.getCount(Pages.notice) + 1);
                },
                child: const Text('add')),
          ],
        ),
      ),
    );
  }
}
