import 'package:flutter/material.dart';

class CodiaPage extends StatefulWidget {
  CodiaPage({super.key});

  @override
  State<StatefulWidget> createState() => _CodiaPage();
}

class _CodiaPage extends State<CodiaPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Container(
        width: 390,
        height: 844,
        decoration: BoxDecoration(
          color: const Color(0xffffffff),
        ),
        child: Stack(
          children: [
            Positioned(
              left: 161,
              width: 67,
              top: 754,
              height: 65,
              child: Image.asset('images/image1_1982635.png', width: 67, height: 65,),
            ),
            Positioned(
              left: -1,
              width: 391,
              top: 781,
              height: 63,
              child: Image.asset('images/image2_1982637.png', width: 391, height: 63,),
            ),
            Positioned(
              left: 0,
              width: 390,
              top: 127,
              height: 2.08,
              child: Image.asset('images/image3_1982642.png', width: 390, height: 2.08,),
            ),
            Positioned(
              left: 21,
              width: 320,
              top: 76,
              height: 35,
              child: Container(
                width: 320,
                height: 35,
                decoration: BoxDecoration(
                  color: const Color(0xffd9d9d9),
                  border: Border.all(color: const Color(0xff8491ae), width: 1),
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
            ),
            Positioned(
              left: 27,
              width: 23,
              top: 82,
              height: 23,
              child: Image.asset('images/image4_1982676.png', width: 23, height: 23,),
            ),
            Positioned(
              left: 350,
              width: 24,
              top: 82,
              height: 24,
              child: Image.asset('images/image5_1982704.png', width: 24, height: 24,),
            ),
            Positioned(
              left: 55,
              width: 1,
              top: 83,
              height: 22,
              child: Image.asset('images/image6_2133633.png', width: 1, height: 22,),
            ),
            Positioned(
              left: 62,
              top: 140,
              child: Text(
                '検索したいキーワードを入力してください',
                textAlign: TextAlign.center,
                style: TextStyle(decoration: TextDecoration.none, fontSize: 14, color: const Color(0xff8e9099), fontFamily: 'Roboto-Regular', fontWeight: FontWeight.normal),
                maxLines: 9999,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Positioned(
              left: 0,
              width: 390,
              top: 0,
              height: 60,
              child: Stack(
                children: [
                  Positioned(
                    left: 0,
                    width: 390,
                    top: 0,
                    height: 60,
                    child: Container(
                      width: 390,
                      height: 60,
                      decoration: BoxDecoration(
                        color: const Color(0xff1a73e8),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 50,
                    width: 290,
                    top: 0,
                    height: 59,
                    child: Text(
                      '検索',
                      textAlign: TextAlign.center,
                      style: TextStyle(decoration: TextDecoration.none, fontSize: 32, color: const Color(0xffffffff), fontFamily: 'Roboto-Regular', fontWeight: FontWeight.normal),
                      maxLines: 9999,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              left: 333,
              width: 40,
              top: 10,
              height: 40,
              child: Image.asset('images/image7_2703432.png', width: 40, height: 40,),
            ),
            Positioned(
              left: 5,
              width: 40,
              top: 10,
              height: 40,
              child: Image.asset('images/image8_2703434.png', width: 40, height: 40,),
            ),
          ],
        ),
      ),
    );
  }
}