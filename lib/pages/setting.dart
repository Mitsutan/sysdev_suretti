import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:io';

import 'package:sysdev_suretti/pages/loading.dart';
// import 'package:sysdev_suretti/pages/password_reset.dart';
import 'package:sysdev_suretti/utils/csb.dart';
import 'package:sysdev_suretti/utils/provider.dart';
import 'package:uuid/uuid.dart';

/// 設定画面
class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final udp = ref.watch(userDataProvider);

    // File? _image;
    String name = "default name";
    // String _selectedNotificationFrequency = '1日or数日に一回';
    // String _selectedLocationInfo = '公開';

    final nameController = TextEditingController();

    // Future<void> _pickImage() async {
    //   final picker = ImagePicker();
    //   final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    //   setState(() {
    //     if (pickedFile != null) {
    //       _image = File(pickedFile.path);
    //     }
    //   });
    // }

    /// 端末のアルバム等から画像取得
    Future<XFile?> getImage() async {
      final pickedFile =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      return pickedFile;
    }

    /// プロフィール画像変更処理
    void changeavatar() async {
      final image = await getImage();
      if (image == null) {
        return;
      }

      // ファイル名重複を防ぐため、UUIDを作成
      final filenameUUID = const Uuid().v4();

      final supabase = Supabase.instance.client;
      try {
        // Supabaseストレージへ画像アップロード
        await supabase.storage
            .from('avatar')
            .upload('users/$filenameUUID', File(image.path));
        // ユーザーのプロフィール画像パスを上書き
        await supabase
            .from('users')
            .update({'icon': 'avatar/users/$filenameUUID'}).eq(
                'auth_id', supabase.auth.currentUser!.id);
      } catch (e) {
        log("avatar upload error", error: e);
        if (context.mounted) {
          Csb.showSnackBar(context, 'プロフィール画像の変更に失敗しました', CsbType.error);
        }
      }

      if (context.mounted) {
        // setState(() {});
        Csb.showSnackBar(context, 'プロフィール画像を変更しました', CsbType.nomal);
      }
    }

    /// ユーザー名変更処理
    Future<void> editName() async {
      log("name update start");
      final supabase = Supabase.instance.client;
      try {
        // usersテーブルのnicknameを変更
        await supabase
            .from('users')
            .update({'nickname': nameController.text}).eq(
                'auth_id', supabase.auth.currentUser!.id);
        // authテーブルのusernameを変更
        await supabase.auth.updateUser(
            UserAttributes(data: {'username': nameController.text}));
      } catch (e) {
        log("name update error", error: e);
        if (context.mounted) {
          Csb.showSnackBar(context, 'ユーザーネームの変更に失敗しました', CsbType.error);
        }
      }

      if (context.mounted) {
        // setState(() {
        name = nameController.text;
        // });
        Csb.showSnackBar(context, 'ユーザーネームを変更しました', CsbType.nomal);
      }
    }

    void showEditNameDialog() {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('名前を編集'),
            content: TextField(
              controller: nameController,
              decoration: const InputDecoration(
                hintText: '名前を入力してください',
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('キャンセル'),
              ),
              TextButton(
                onPressed: () {
                  editName();
                  Navigator.of(context).pop();
                },
                child: const Text('保存'),
              ),
            ],
          );
        },
      );
    }

    // void _navigateTo(String route) {
    //   Navigator.push(
    //     context,
    //     MaterialPageRoute(builder: (context) => PlaceholderPage(route)),
    //   );
    // }

    /// ログアウト処理
    void logout() {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('ログアウト'),
            content: const Text('ログアウトしました。'),
            actions: [
              TextButton(
                onPressed: () async {
                  // userData.updateIsGotUserData(false);
                  Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) {
                    return const Loading();
                  }), (route) => false);
                  // Navigator.of(context).pop();

                  Csb.showSnackBar(context, 'ログアウトしました', CsbType.nomal);

                  try {
                    Supabase.instance.client.auth.signOut();

                    final SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    await prefs.remove('major');
                    await prefs.remove('minor');
                  } catch (e) {
                    log("logout error", error: e);
                  }
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }

    final supabase = Supabase.instance.client;
    final metadata = supabase.auth.currentUser!.userMetadata;

    if (metadata == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    // Future<List<Map<String, dynamic>>> getUserData() async {
    //   final userdata = await supabase
    //       .from('users')
    //       .select()
    //       .eq('auth_id', supabase.auth.currentUser!.id);

    //   userdata.add(metadata);
    //   return userdata;
    // }

    // log(const String.fromEnvironment("IBEACON_UUID"));

    // // usersテーブルからuser.auth_idをキーにしてユーザー情報を取得
    // Future<void> getUserData() async {
    //   final SharedPreferences prefs = await SharedPreferences.getInstance();

    //   try {
    //     await supabase
    //         .from('users')
    //         .select()
    //         .eq('auth_id', supabase.auth.currentUser!.id)
    //         .then((value) {
    //       log(value.toString());
    //       userData.updateUserData(value.first);
    //       String userId =
    //           value.first['user_id'].toRadixString(16).padLeft(8, '0');
    //       // set to shared preference
    //       prefs.setInt('major', int.parse(userId.substring(0, 4), radix: 16));
    //       prefs.setInt('minor', int.parse(userId.substring(4, 8), radix: 16));

    //       userData.updateIsGotUserData(true);
    //     }, onError: (error) {
    //       debugPrint('getUserData error: $error');
    //       throw error;
    //     });
    //     // log(user.toString());
    //     // userData.updateUserData(user.first);
    //     // String userId = user.first['user_id'].toRadixString(16).padLeft(8, '0');
    //     // beacon.major = int.parse(userId.substring(0, 4), radix: 16);
    //     // beacon.minor = int.parse(userId.substring(4, 8), radix: 16);
    //   } catch (e) {
    //     log('getUserData error', error: e);
    //     return;
    //   }
    // }

    if (!udp.isGotUserData) {
      try {
        udp.getUserData();
      } catch (e) {
        log('getUserData error. try transfer loading page.', error: e);
        Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) {
          return const Loading();
        }), (route) => false);
      }
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      name = udp.userData['nickname'];
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text('設定'),
          centerTitle: true,
          // leading: IconButton(
          //   icon: const Icon(Icons.arrow_back),
          //   onPressed: () {
          //     // 戻る処理をここに追加
          //   },
          // ),
          actions: [
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () {
                // 設定アイコンの処理をここに追加
              },
            ),
          ],
        ),
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // プロフィールアイコンと名前を横並びにする
                Row(
                  children: [
                    GestureDetector(
                      // onTap: _pickImage,
                      // child: CircleAvatar(
                      //   radius: 40,
                      //   backgroundImage:
                      //       _image != null ? FileImage(_image!) : null,
                      //   child: _image == null
                      //       ? const Icon(Icons.camera_alt, size: 40)
                      //       : null,
                      // ),
                      onTap: changeavatar,
                      child: CircleAvatar(
                        foregroundImage: NetworkImage(
                            "https://jeluoazapxqjksdfvftm.supabase.co/storage/v1/object/public/${udp.userData['icon']}"),
                      ),
                    ),
                    const SizedBox(width: 16.0), // アイコンと名前の間の余白
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: showEditNameDialog,
                    ),
                  ],
                ),
                // const SizedBox(height: 16.0),
                // const Text('210****@********.ac.jp'),
                // const SizedBox(height: 8.0),
                // GestureDetector(
                //   // onTap: () => _navigateTo('メールアドレス再設定'),
                //   child: RichText(
                //     text: const TextSpan(
                //       text: 'メールアドレス再設定は',
                //       style: TextStyle(fontSize: 16.0, color: Colors.black),
                //       children: [
                //         TextSpan(
                //           text: 'こちら',
                //           style: TextStyle(color: Colors.red, fontSize: 16.0),
                //         ),
                //       ],
                //     ),
                //   ),
                // ),
                // const SizedBox(height: 16.0),
                // const Text('**********xzy'),
                // const SizedBox(height: 8.0),
                // GestureDetector(
                //   onTap: () {
                //     Navigator.of(context)
                //         .push(MaterialPageRoute(builder: (context) {
                //       return const PasswordResetPage();
                //     }));
                //   },
                //   child: RichText(
                //     text: const TextSpan(
                //       text: 'パスワード再設定は',
                //       style: TextStyle(fontSize: 16.0, color: Colors.black),
                //       children: [
                //         TextSpan(
                //           text: 'こちら',
                //           style: TextStyle(color: Colors.red, fontSize: 16.0),
                //         ),
                //       ],
                //     ),
                //   ),
                // ),
                // const SizedBox(height: 16.0),
                // const Text('通知頻度'),
                // DropdownButton<String>(
                //   value: _selectedNotificationFrequency,
                //   items: const [
                //     DropdownMenuItem(
                //       value: '1日or数日に一回',
                //       child: Text('1日or数日に一回'),
                //     ),
                //     DropdownMenuItem(
                //       value: 'ユーザーが指定した時間帯に',
                //       child: Text('ユーザーが指定した時間帯に'),
                //     ),
                //     DropdownMenuItem(
                //       value: '何人か毎に',
                //       child: Text('何人か毎に'),
                //     ),
                //   ],
                //   onChanged: (value) {
                //     setState(() {
                //       _selectedNotificationFrequency = value!;
                //     });
                //   },
                //   hint: const Text('選択してください'),
                // ),
                // const SizedBox(height: 16.0),
                // const Text('位置情報'),
                // DropdownButton<String>(
                //   value: _selectedLocationInfo,
                //   items: const [
                //     DropdownMenuItem(
                //       value: '公開',
                //       child: Text('公開'),
                //     ),
                //     DropdownMenuItem(
                //       value: '非公開',
                //       child: Text('非公開'),
                //     ),
                //   ],
                //   onChanged: (value) {
                //     setState(() {
                //       _selectedLocationInfo = value!;
                //     });
                //   },
                //   hint: const Text('選択してください'),
                // ),
                // const SizedBox(height: 16.0),
                // GestureDetector(
                //   // onTap: () => _navigateTo('投稿の編集'),
                //   child: RichText(
                //     text: const TextSpan(
                //       text: '投稿の編集は',
                //       style: TextStyle(fontSize: 16.0, color: Colors.black),
                //       children: [
                //         TextSpan(
                //           text: 'こちら',
                //           style: TextStyle(color: Colors.red, fontSize: 16.0),
                //         ),
                //       ],
                //     ),
                //   ),
                // ),
                // const SizedBox(height: 16.0),
                // GestureDetector(
                //   // onTap: () => _navigateTo('アカウントの切り替え'),
                //   child: RichText(
                //     text: const TextSpan(
                //       text: 'アカウントの切り替えは',
                //       style: TextStyle(fontSize: 16.0, color: Colors.black),
                //       children: [
                //         TextSpan(
                //           text: 'こちら',
                //           style: TextStyle(color: Colors.red, fontSize: 16.0),
                //         ),
                //       ],
                //     ),
                //   ),
                // ),
                const SizedBox(height: 16.0),
                GestureDetector(
                  onTap: logout,
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.logout, color: Colors.black),
                      SizedBox(width: 8.0),
                      Text(
                        'ログアウト',
                        style: TextStyle(color: Colors.red, fontSize: 16.0),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32.0), // ログアウトと＋ボタンの間隔を開ける
              ],
            ),
          ),
        ),
        // bottomNavigationBar: BottomAppBar(
        //   shape: const CircularNotchedRectangle(),
        //   notchMargin: 6.0,
        //   child: Row(
        //     mainAxisSize: MainAxisSize.max,
        //     mainAxisAlignment: MainAxisAlignment.spaceAround,
        //     children: <Widget>[
        //       IconButton(
        //         icon: const Icon(Icons.home),
        //         onPressed: () {},
        //       ),
        //       IconButton(
        //         icon: const Icon(Icons.search),
        //         onPressed: () {},
        //       ),
        //       const SizedBox(width: 40.0), // 真ん中の余白
        //       IconButton(
        //         icon: const Icon(Icons.notifications),
        //         onPressed: () {},
        //       ),
        //       IconButton(
        //         icon: const Icon(Icons.person),
        //         onPressed: () {},
        //       ),
        //     ],
        //   ),
        // ),
        // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        // floatingActionButton: FloatingActionButton(
        //   onPressed: () {
        //     // 投稿ボタンの処理をここに追加
        //   },
        //   backgroundColor: Colors.blue,
        //   child: const Icon(Icons.add),
        // ),
      );
    }
  }
}

// class PlaceholderPage extends StatelessWidget {
//   final String title;
//   const PlaceholderPage(this.title, {super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(title),
//       ),
//       body: Center(
//         child: Text('ここに$titleページの内容が表示されます'),
//       ),
//     );
//   }
// }
