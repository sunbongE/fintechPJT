import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'FlutterToastMsg.dart';

final LocalAuthentication auth = LocalAuthentication();

Future<bool?> CheckBiometrics() async {
  bool canCheckBiometrics = false;
  try {
    canCheckBiometrics = await auth.canCheckBiometrics;
  } on PlatformException catch (e) {
    print(e);
  }
  if (!canCheckBiometrics) {
    FlutterToastMsg("생체 인증을 지원하지 않는 기기입니다.");
  } else {
    bool authenticated = false;
    try {
      authenticated = await auth.authenticate(
        localizedReason: '생체 인증을 진행해 주세요',
        options: const AuthenticationOptions(biometricOnly: true),
      );
    } on PlatformException catch (e) {
      print(e);
    }
    return authenticated;
  }
}