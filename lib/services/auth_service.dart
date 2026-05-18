import 'package:firebase_auth/firebase_auth.dart';

import 'user_service.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance; //firebase authentication servisine erişmek için 
  final UserService _userService = UserService(); //firestore kullanıcı işlemleri için 

  Future<String?> register({
  required String name,
  required String email,
  required String password,
}) async {
    try {
      final UserCredential credential =
          await _auth.createUserWithEmailAndPassword(  //kullanıcının email ve şifresiyle hesap oluşturuluyor
        email: email,
        password: password,
      );

      await credential.user?.updateDisplayName(name); 
      await credential.user?.reload();

      await credential.user?.sendEmailVerification(); //doğrulama maili gönderiliyor

      await _userService.createUserIfNotExists(
        name: name,
      );
      

      return null;
    } on FirebaseAuthException catch (e) {
      return _getErrorMessage(e.code);
    } catch (e) {
      return 'Beklenmeyen bir hata oluştu.';
    }
  }

  Future<String?> login({
    required String email,
    required String password,
  }) async {
    try {
      final UserCredential credential =
          await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user != null && !credential.user!.emailVerified) {  //email doğrulama yapılmış mı kontrol
        await _auth.signOut();
        return 'Lütfen e-posta adresini doğrula.';
      }

      await _userService.createUserIfNotExists();

      return null;
    } on FirebaseAuthException catch (e) {
      return _getErrorMessage(e.code);
    } catch (e) {
      return 'Beklenmeyen bir hata oluştu.';
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
  }

  String _getErrorMessage(String code) {
    switch (code) {
      case 'email-already-in-use':
        return 'Bu e-posta zaten kayıtlı.';
      case 'invalid-email':
        return 'Geçersiz e-posta adresi.';
      case 'weak-password':
        return 'Şifre en az 6 karakter olmalı.';
      case 'user-not-found':
        return 'Bu e-posta ile kayıtlı kullanıcı bulunamadı.';
      case 'wrong-password':
        return 'Şifre hatalı.';
      case 'invalid-credential':
        return 'E-posta veya şifre hatalı.';
      case 'network-request-failed':
        return 'İnternet bağlantını kontrol et.';
      default:
        return 'Bir hata oluştu: $code';
    }
  }
}