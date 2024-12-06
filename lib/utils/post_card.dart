import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:sysdev_suretti/pages/map.dart';
import 'package:sysdev_suretti/utils/favorite.dart';

class PostCard extends StatefulWidget {
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
  _PostCardState createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  // bool isLiked = false;

  List<PopupMenuEntry> _popupMenuItems() {
    final items = <PopupMenuEntry>[];
    if (widget.isEditable && (widget.selfUserId == widget.userid)) {
      items.add(
        PopupMenuItem(
          child: const Text('削除'),
          onTap: () {
            // 削除処理をここに追加
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
                            Text(
                              widget.username,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
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
                  IconButton(
                    icon: StreamBuilder<bool>(
                      stream: isMessageLikedRealtime(
                          widget.messageId, widget.selfUserId),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Icon(
                            Icons.thumb_up,
                            color: snapshot.data! ? Colors.pink : Colors.grey,
                          );
                        } else {
                          return const Icon(Icons.thumb_up, color: Colors.grey);
                        }
                      },
                    ),
                    onPressed: () async {
                      if (await isMessageLiked(
                          widget.messageId, widget.selfUserId)) {
                        await unlikeMessage(
                            widget.messageId, widget.selfUserId);
                      } else {
                        await likeMessage(widget.messageId, widget.selfUserId);
                      }
                      // setState(() {
                      //   isLiked = !isLiked;
                      // });
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.bookmark_border),
                    onPressed: () {},
                  ),
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
