import 'dart:developer';

import 'package:animated_flip_counter/animated_flip_counter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sysdev_suretti/pages/map.dart';
import 'package:sysdev_suretti/utils/db_provider.dart';
import 'package:sysdev_suretti/utils/favorite.dart';
import 'package:sysdev_suretti/utils/messages.dart';

class PostCard extends ConsumerStatefulWidget {
  final int selfUserId;
  final String iconpath;
  final String username;
  final String date;
  final int userid;
  final String message;
  final int messageId;
  final String recommend;
  final String address;
  final dynamic location;
  final bool isEditable;

  const PostCard({
    super.key,
    required this.selfUserId,
    required this.iconpath,
    required this.username,
    required this.date,
    required this.userid,
    required this.message,
    required this.messageId,
    required this.recommend,
    required this.address,
    required this.location,
    required this.isEditable,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PostCardState();
}

class _PostCardState extends ConsumerState<PostCard>
    with AutomaticKeepAliveClientMixin {
  // bool isLiked = false;

  @override
  bool get wantKeepAlive => true;

  List<PopupMenuEntry> _popupMenuItems() {
    final items = <PopupMenuEntry>[];
    if (widget.selfUserId == widget.userid) {
      items.add(
        PopupMenuItem(
          child: const Text('削除'),
          onTap: () {
            // 削除処理をここに追加
            showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text('削除確認'),
                    content: const Text('本当に削除しますか？'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('キャンセル'),
                      ),
                      TextButton(
                        onPressed: () async {
                          await Messages().deleteMessage(widget.messageId);

                          final db = ref.read(dbProvider).database;
                          final isBookmarked =
                              await db.isBookmarked(widget.messageId);
                          if (isBookmarked) {
                            await db.deleteBookmark(widget.messageId);
                          }
                          if (context.mounted) {
                            Navigator.of(context).pop();
                          }
                        },
                        child: const Text('削除'),
                      ),
                    ],
                  );
                });
          },
        ),
      );
    }
    if (widget.selfUserId != widget.userid) {
      items.add(
        PopupMenuItem(
          child: const Text('ブロック'),
          onTap: () {
            // ブロック処理をここに追加
          },
        ),
      );
      items.add(
        PopupMenuItem(
          textStyle: const TextStyle(color: Colors.red),
          onTap: () {
            // 通報処理をここに追加
          },
          child: const Text('通報'),
        ),
      );
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {
    final db = ref.watch(dbProvider).database;
    super.build(context);
    log('location: ${widget.location}');
    return Card(
        margin: const EdgeInsets.all(8.0),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start, // 上揃えにする
                children: [
                  CircleAvatar(
                    radius: 20,
                    foregroundImage: NetworkImage(
                        "https://jeluoazapxqjksdfvftm.supabase.co/storage/v1/object/public/${widget.iconpath}"),
                  ),
                  const SizedBox(width: 8), // 少し隙間を開ける
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                                child: Text(
                              widget.username,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                              overflow: TextOverflow.ellipsis,
                            )),
                            const SizedBox(width: 8),
                            Text(
                              widget.date,
                              style: const TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(widget.message),
                            const Divider(),
                            ListTile(
                              title: Text(widget.recommend,
                                  overflow: TextOverflow.ellipsis),
                              subtitle: Text(widget.address,
                                  overflow: TextOverflow.ellipsis),
                              onTap: () {
                                // 地図への遷移処理
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (context) => MapPage(
                                              location: {
                                                widget.location,
                                              },
                                              center: widget
                                                  .location['coordinates'])),
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // const Expanded(child: SizedBox()), // 右端に寄せる
                  PopupMenuButton(
                    itemBuilder: (BuildContext context) => _popupMenuItems(),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: StreamBuilder<bool>(
                          stream: isMessageLikedRealtime(
                              widget.messageId, widget.selfUserId),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return Icon(
                                Icons.thumb_up,
                                color:
                                    snapshot.data! ? Colors.pink : Colors.grey,
                              );
                            } else {
                              return const Icon(Icons.thumb_up,
                                  color: Colors.grey);
                            }
                          },
                        ),
                        onPressed: () async {
                          if (await isMessageLiked(
                              widget.messageId, widget.selfUserId)) {
                            await unlikeMessage(
                                widget.messageId, widget.selfUserId);
                          } else {
                            await likeMessage(
                                widget.messageId, widget.selfUserId);
                          }
                          // setState(() {
                          //   isLiked = !isLiked;
                          // });
                        },
                      ),
                      (widget.selfUserId == widget.userid)
                          ? StreamBuilder<int>(
                              stream: getFavCount(widget.messageId),
                              initialData: 0,
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  return AnimatedFlipCounter(
                                    value: snapshot.data!,
                                    duration: const Duration(milliseconds: 200),
                                    thousandSeparator: ",",
                                  );
                                } else {
                                  return const Text("...");
                                }
                              })
                          : const SizedBox(),
                    ],
                  ),
                  StreamBuilder(
                      stream: db.watchIsBookmarked(widget.messageId),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          if (snapshot.data!) {
                            return IconButton(
                              icon: const Icon(Icons.bookmark,
                                  color: Colors.orange),
                              onPressed: () async {
                                await db.deleteBookmark(widget.messageId);
                              },
                            );
                          } else {
                            return IconButton(
                              icon: const Icon(Icons.bookmark_border),
                              onPressed: () async {
                                await db.addBookmark(widget.messageId);
                              },
                            );
                          }
                        } else {
                          return IconButton(
                            icon: const Icon(Icons.bookmark_border),
                            onPressed: () async {
                              await db.addBookmark(widget.messageId);
                            },
                          );
                        }
                      }),
                  IconButton(
                    icon: const Icon(Icons.visibility),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: widget.isEditable
                        ? const Icon(Icons.edit_document)
                        : const SizedBox.shrink(),
                    onPressed: () {},
                  ),
                ],
              ),
            ],
          ),
        ));
  }
}
