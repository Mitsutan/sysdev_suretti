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
      await supabase
          .from('users')
          .update({'icon': 'avatar/users/$filenameUUID'}).eq(
              'auth_id', supabase.auth.currentUser!.id);
    } catch (e) {
      log("avatar upload error", error: e);
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final supabase = Supabase.instance.client;
    final metadata = supabase.auth.currentUser!.userMetadata;

    if (metadata == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    Future<List<Map<String, dynamic>>> getUserData() async {
      final userdata = await supabase
          .from('users')
          .select()
          .eq('auth_id', supabase.auth.currentUser!.id);

      userdata.add(metadata);
      return userdata;
    }

    return FutureBuilder(
      future: getUserData(),
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
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
                Expanded(
                    child: ListView(
                  children: [
                    ListTile(
                      leading: Stack(
                        children: [
                          CircleAvatar(
                            foregroundImage: NetworkImage(
                                "https://jeluoazapxqjksdfvftm.supabase.co/storage/v1/object/public/${userdata.first['icon']}"),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            left: 0,
                            child: IconButton(
                              onPressed: changeavatar,
                              icon: const Icon(Icons.camera_alt_outlined),
                            ),
                          ),
                        ],
                      ),
                      title: Text(userdata.first['nickname']),
                      trailing: IconButton(
                        onPressed: () {
                          // ここに編集画面への遷移処理を書く
                          log('編集');
                        },
                        icon: const Icon(Icons.edit),
                      ),
                    ),
                    ListTile(
                      leading: const Icon(Icons.email),
                      title: const Text('メールアドレス'),
                      subtitle: Text(userdata[1]['email']),
                      trailing: IconButton(
                        onPressed: () {
                          // ここに編集画面への遷移処理を書く
                          log('編集');
                        },
                        icon: const Icon(Icons.edit),
                      ),
                    ),
                    ListTile(
                      leading: const Icon(Icons.lock),
                      title: const Text('パスワード変更'),
                      trailing: IconButton(
                          onPressed: () {
                            // ここに編集画面への遷移処理を書く
                            log('編集');
                          },
                          icon: const Icon(Icons.edit)),
                    )
                  ],
                ))
              ],
            ),
          ),
        );
      },
    );
  }
}
