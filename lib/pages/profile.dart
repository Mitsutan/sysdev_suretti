import 'dart:async';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  final String title = 'プロフィール';

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Future<int>? totalPriceFuture;

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
              ],
            ),
          ),
        );
      },
    );
  }
}
