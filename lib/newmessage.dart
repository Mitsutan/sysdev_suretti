import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'newmessageconfirm.dart'; // newmessageconfirm.dartをインポート

class NewMessagePage extends StatefulWidget {
  final String category;
  final String recommendedPlace;
  final String address;
  final String messageText;
  final LatLng location;

  const NewMessagePage({
    super.key,
    this.category = '',
    this.recommendedPlace = '',
    this.address = '',
    this.messageText = '',
    this.location = const LatLng(35.681236, 139.767125), // 初期値として東京駅の座標を設定
  });

  @override
  _NewMessagePageState createState() => _NewMessagePageState();
}

class _NewMessagePageState extends State<NewMessagePage> {
  final _formKey = GlobalKey<FormState>();
  late String _category;
  late String _recommendedPlace;
  late String _address;
  late String _messageText;
  late LatLng _location;

  @override
  void initState() {
    super.initState();
    _category = widget.category;
    _recommendedPlace = widget.recommendedPlace;
    _address = widget.address;
    _messageText = widget.messageText;
    _location = widget.location;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Message'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: <Widget>[
            TextFormField(
              initialValue: _category,
              decoration: const InputDecoration(
                labelText: 'カテゴリー',
                hintText: 'カテゴリーを入力してください',
              ),
              onChanged: (value) => setState(() => _category = value),
              validator: (value) => value!.isEmpty ? 'カテゴリーを入力してください' : null,
            ),
            TextFormField(
              initialValue: _recommendedPlace,
              decoration: const InputDecoration(
                labelText: 'おすすめの場所',
                hintText: 'おススメの場所を共有してみましょう',
              ),
              onChanged: (value) => setState(() => _recommendedPlace = value),
              validator: (value) => value!.isEmpty ? 'おすすめの場所を入力してください' : null,
            ),
            TextFormField(
              initialValue: _address,
              decoration: const InputDecoration(
                labelText: '住所',
                hintText: '住所を入力してください',
              ),
              onChanged: (value) => setState(() => _address = value),
              validator: (value) => value!.isEmpty ? '住所を入力してください'  : null,
            ),
            TextFormField(
              initialValue: _messageText,
              decoration: const InputDecoration(
                labelText: 'メッセージ',
                hintText: '皆に言いたい事を書いてみましょう',
              ),
              onChanged: (value) => setState(() => _messageText = value),
              validator: (value) => value!.isEmpty ? 'メッセージを入力してください' : null,
            ),
            // SizedBox(
            //   height: 200,
            //   child: GoogleMap(
            //     initialCameraPosition: CameraPosition(
            //       target: _location,
            //       zoom: 14.0,
            //     ),
            //     onTap: (position) {
            //       setState(() => _location = position);
            //       // モーダルを表示して位置情報を取得
            //       showDialog(
            //         context: context,
            //         builder: (context) => AlertDialog(
            //           content: SizedBox(
            //             height: 400,
            //             child: GoogleMap(
            //               initialCameraPosition: CameraPosition(
            //                 target: position,
            //                 zoom: 14.0,
            //               ),
            //               markers: {
            //                 Marker(
            //                   markerId: const MarkerId('selected-location'),
            //                   position: position,
            //                 ),
            //               },
            //             ),
            //           ),
            //         ),
            //       );
            //     },
            //   ),
            // ),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => MessageConfirmPage(
                      category: _category,
                      recommendedPlace: _recommendedPlace,
                      address: _address,
                      messageText: _messageText,
                      location: _location,
                    ),
                  ));
                }
              },
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}