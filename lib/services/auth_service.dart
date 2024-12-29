import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final supabase = Supabase.instance.client;

  /// 新規ユーザー登録
  Future<void> signUpUser(String email, String password) async {
    try {
      final response = await supabase.auth.signUp(
        email: email,
        password: password,
      );
      if (response.user != null) {
        print('確認用メールを送信しました。');
      }
    } on AuthException catch (error) {
      print('エラー: ${error.message}');
    } catch (e) {
      print('エラーが発生しました: $e');
    }
  }

  /// メール確認後の画面遷移チェック
  void checkEmailVerificationAndNavigate(BuildContext context) async {
    final session = supabase.auth.currentSession;
    if (session != null && session.user.emailConfirmedAt != null) {
      Navigator.pushNamed(context, '/home');
    } else {
      print('メール確認がまだ完了していません。');
    }
  }

  /// パスワードリセットリンクの送信
   Future<void> sendPasswordResetEmail(String email, String resetLink) async {
    try {
      await supabase.auth.resetPasswordForEmail(
        email,
        redirectTo: resetLink,
      );
      print('パスワードリセット用のメールを送信しました。');
    } on AuthException catch (error) {
      print('エラー: ${error.message}');
      throw error;
    } catch (e) {
      print('エラーが発生しました: $e');
      throw e;
    }
  }

  /// 新しいパスワードを設定
  Future<void> updatePassword(String newPassword, BuildContext context) async {
    try {
      final response = await supabase.auth.updateUser(
        UserAttributes(password: newPassword),
      );
      if (response.user != null) {
        print('パスワードが正常に更新されました。');
        Navigator.pushNamed(context, '/login');
      }
    } on AuthException catch (error) {
      print('エラー: ${error.message}');
    } catch (e) {
      print('エラーが発生しました: $e');
    }
  }
}