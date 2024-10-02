import 'package:flutter/material.dart';

/// スナックバーの種類を表す列挙型
enum CsbType {
  /// 通常のスナックバー
  nomal(
    color: null,
  ),
  /// エラーを示すスナックバー
  error(
    color: Colors.red,
  );

  const CsbType({
    required this.color,
  });

  final Color? color;
}

class Csb {
  /// [context]には、スナックバーを表示するウィジェットのコンテキストを指定します。
  /// 
  /// [message]に与えられた文字列をスナックバーで表示します。
  /// 
  /// [type]に与えられた値によってスナックバーの色を変更します。
  static void showSnackBar(BuildContext context, String message, CsbType type) {
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: type.color,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
