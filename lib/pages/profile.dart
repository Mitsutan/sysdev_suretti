import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  final String title = 'プロフィール';

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Future<int>? totalPriceFuture;

  Future<XFile?> _getImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    return pickedFile;
  }

  void changeavatar() async {
    final image = await _getImage();
    if (image == null) {
      return;
    }

    final filenameUUID = const Uuid().v4();

    final supabase = Supabase.instance.client;
    try {
      await supabase.storage
          .from('avatar')
          .upload('users/$filenameUUID', File(image.path));
      await supabase.from('users').update({'icon': 'avatar/users/$filenameUUID'}).eq(
          'auth_id', supabase.auth.currentUser!.id);
    } catch (e) {
      log("avatar upload error", error: e);
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final supabase = Supabase.instance.client;

    Future<List<Map<String, dynamic>>> getUserData() async {
      final userdata = await supabase
          .from('users')
          .select()
          .eq('auth_id', supabase.auth.currentUser!.id);
      return userdata;
    }

    return FutureBuilder(
      future: getUserData(),
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }
        final userdata = snapshot.data;
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            title: Text(widget.title),
          ),
          body: Container(
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.network(
                    "https://jeluoazapxqjksdfvftm.supabase.co/storage/v1/object/public/${userdata.first['icon']}"),
                ElevatedButton(
                    onPressed: changeavatar, child: const Text('アイコン変更')),
              ],
            ),
          ),
        );
      },
    );
  }
}
