import 'dart:developer';

import 'package:drift/drift.dart' as drift;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sysdev_suretti/utils/db_provider.dart';
import 'package:sysdev_suretti/utils/display_time.dart';
import 'package:sysdev_suretti/utils/enum_pages.dart';
import 'package:sysdev_suretti/utils/lifecycle.dart';
import 'package:sysdev_suretti/utils/notices_provider.dart';

class NotificationPage extends ConsumerStatefulWidget {
  const NotificationPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _NotificationPageState();
}

class _NotificationPageState extends ConsumerState<NotificationPage> {
  String _selectedFilter = "新しい順";
  final List<String> _filters = [
    '新しい順',
    '古い順',
  ];

  @override
  void didChangeDependencies() {
    log("NotificationPage: didChangeDependencies");
    final db = ref.watch(dbProvider).database;
    final noticesPrv = ref.read(noticesProvider);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      final title = message.notification?.title ?? "すれっちからのお知らせ";
      final body = message.notification?.body ?? "nullの通知";

      await db.addNotice(title, body);
    });

    db.watchUnreadNoticeCount().listen((count) {
      log("未読通知数: $count", name: "NotificationPage");
      noticesPrv.updateNoticeCount(Pages.notice, count);
    });
    super.didChangeDependencies();
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("フィルターを選択"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: _filters.map((filter) {
              return ListTile(
                title: Text(filter),
                onTap: () {
                  setState(() {
                    _selectedFilter = filter;
                  });
                  Navigator.pop(context);
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final db = ref.watch(dbProvider).database;

    ref.listen<AppLifecycleState>(appLifecycleProvider, (previous, next) {
      log("previous: ${previous.toString()}, next: ${next.toString()}",
          name: 'AppLifecycleState');
      if (next == AppLifecycleState.resumed) {
        db.notifyUpdates({
          for (final table in db.allTables) drift.TableUpdate.onTable(table)
        });
      }
    });

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text('通知'),
          centerTitle: true,
        ),
        body: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(_selectedFilter),
                IconButton(
                  icon: const Icon(Icons.filter_list),
                  onPressed: _showFilterDialog,
                ),
              ],
            ),
            Expanded(
              child: StreamBuilder(
                  stream: db.watchNotices(_selectedFilter),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    final notices = snapshot.data;
                    if (notices == null ||
                        snapshot.connectionState == ConnectionState.done &&
                            notices.isEmpty) {
                      return Container(
                        alignment: Alignment.center,
                        child: const Text('通知はありません'),
                      );
                    }
                    return ListView.builder(
                      itemCount: notices.length,
                      itemBuilder: (context, index) {
                        final notice = notices[index];
                        return Card(
                          color: notice.readAt != null
                              ? const Color(0xFFF4F6FF)
                              : const Color(0xFFBBE1FF),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  notice.title,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  notice.body,
                                  style: const TextStyle(
                                    fontSize: 12,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  formatDate(notice.createdAt.toString()),
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }),
            ),
          ],
        ));
  }
}
