// import 'package:flutter/services.dart';
// import 'package:front/providers/store.dart';
// import 'package:front/repository/api/ApiLogin.dart';
// import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
//
// Future<bool> SocialKakao() async {
//   // 카카오톡 실행 가능 여부 확인
//   // 카카오톡 실행이 가능하면 카카오톡으로 로그인, 아니면 카카오계정으로 로그인
//   if (await isKakaoTalkInstalled()) {
//     try {
//       await UserApi.instance.loginWithKakaoTalk();
//       User user = await UserApi.instance.me();
//       // String? jwtToken = await postUserInfo(user);
//
//       UserManager().saveUserInfo(
//         newName: user.kakaoAccount?.name,
//         newEmail: user.kakaoAccount?.email,
//         newThumbnailImageUrl: user.kakaoAccount?.profile?.thumbnailImageUrl,
//         newProfileImageUrl: user.kakaoAccount?.profile?.profileImageUrl,
//         // newJwtToken: jwtToken,
//       );
//       return true;
//     } catch (error) {
//       print('카카오톡으로 로그인 실패 $error');
//
//       // 사용자가 카카오톡 설치 후 디바이스 권한 요청 화면에서 로그인을 취소한 경우,
//       // 의도적인 로그인 취소로 보고 카카오계정으로 로그인 시도 없이 로그인 취소로 처리 (예: 뒤로 가기)
//       if (error is PlatformException && error.code == 'CANCELED') {
//         return false;
//       }
//       // 카카오톡에 연결된 카카오계정이 없는 경우, 카카오계정으로 로그인
//       try {
//         await UserApi.instance.loginWithKakaoAccount();
//         User user = await UserApi.instance.me();
//         // String? jwtToken = await postUserInfo(user);
//
//         UserManager().saveUserInfo(
//           newName: user.kakaoAccount?.name,
//           newEmail: user.kakaoAccount?.email,
//           newThumbnailImageUrl: user.kakaoAccount?.profile?.thumbnailImageUrl,
//           newProfileImageUrl: user.kakaoAccount?.profile?.profileImageUrl,
//           // newJwtToken: jwtToken,
//         );
//         return true;
//       } catch (error) {
//         print('카카오계정으로 로그인 실패 $error');
//         return false;
//       }
//     }
//   } else {
//     try {
//       await UserApi.instance.loginWithKakaoAccount();
//       User user = await UserApi.instance.me();
//       // String? jwtToken = await postUserInfo(user);
//
//       UserManager().saveUserInfo(
//         newName: user.kakaoAccount?.name,
//         newEmail: user.kakaoAccount?.email,
//         newThumbnailImageUrl: user.kakaoAccount?.profile?.thumbnailImageUrl,
//         newProfileImageUrl: user.kakaoAccount?.profile?.profileImageUrl,
//         // newJwtToken: jwtToken,
//       );
//       return true;
//     } catch (error) {
//       print('카카오계정으로 로그인 실패 $error');
//       return false;
//     }
//   }
// }
//
// Future<void> logoutKakao() async {
//   try {
//     await UserApi.instance.logout();
//     print("카카오 로그아웃 성공");
//     await UserManager().clearUserInfo();
//
//   } catch (error) {
//     print("카카오 로그아웃 실패: $error");
//   }
// }

import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:front/providers/store.dart';
import 'package:front/repository/api/ApiLogin.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';

Future<bool> SocialKakao() async {
  String YOUR_IP = "10.0.2.2";
  // 카카오톡 실행 가능 여부 확인
  // 카카오톡 실행이 가능하면 카카오톡으로 로그인, 아니면 카카오계정으로 로그인
  if (await isKakaoTalkInstalled()) {
    try {
      await UserApi.instance.loginWithKakaoTalk();
      User user = await UserApi.instance.me();
      Response res = await postUserInfo(user);
      UserManager().saveUserInfo(
        newName: user.kakaoAccount?.name,
        newEmail: user.kakaoAccount?.email,
        newThumbnailImageUrl: user.kakaoAccount?.profile?.thumbnailImageUrl,
        newProfileImageUrl: user.kakaoAccount?.profile?.profileImageUrl,
        newJwtToken: res.data['jwtToken'],
      );
      return true;
    } catch (error) {
      print('카카오톡으로 로그인 실패 $error');

      // 사용자가 카카오톡 설치 후 디바이스 권한 요청 화면에서 로그인을 취소한 경우,
      // 의도적인 로그인 취소로 보고 카카오계정으로 로그인 시도 없이 로그인 취소로 처리 (예: 뒤로 가기)
      if (error is PlatformException && error.code == 'CANCELED') {
        return false;
      }
      // 카카오톡에 연결된 카카오계정이 없는 경우, 카카오계정으로 로그인
      try {
        await UserApi.instance.loginWithKakaoAccount();
        User user = await UserApi.instance.me();
        Response res = await postUserInfo(user);
        UserManager().saveUserInfo(
          newName: user.kakaoAccount?.name,
          newEmail: user.kakaoAccount?.email,
          newThumbnailImageUrl: user.kakaoAccount?.profile?.thumbnailImageUrl,
          newProfileImageUrl: user.kakaoAccount?.profile?.profileImageUrl,
          newJwtToken: res.data['jwtToken'],
        );
        return true;
      } catch (error) {
        print('카카오계정으로 로그인 실패 $error');
        return false;
      }
    }
  } else {
    try {
      await UserApi.instance.loginWithKakaoAccount();
      User user = await UserApi.instance.me();
      Response res = await postUserInfo(user);
      UserManager().saveUserInfo(
        newName: user.kakaoAccount?.name,
        newEmail: user.kakaoAccount?.email,
        newThumbnailImageUrl: user.kakaoAccount?.profile?.thumbnailImageUrl,
        newProfileImageUrl: user.kakaoAccount?.profile?.profileImageUrl,
        newJwtToken: res.data['jwtToken'],
      );
      // String? jwtToken = await postUserInfo(user);
      // var dio = Dio();
      // dio.options.headers['Content-Type'] = 'application/json';
      // Response response =
      //     await dio.post('http://${YOUR_IP}:8080/api/v1/auth/join', data: user);
      // print('response');
      // print(response);
      // String jwtToken = response.headers['Authorization']!.first;
      // print('jwtToken 3');
      // print(jwtToken);

      // UserManager().saveUserInfo(
      //   newName: user.kakaoAccount?.name,
      //   newEmail: user.kakaoAccount?.email,
      //   newThumbnailImageUrl: user.kakaoAccount?.profile?.thumbnailImageUrl,
      //   newProfileImageUrl: user.kakaoAccount?.profile?.profileImageUrl,
      //   // newJwtToken: jwtToken,
      // );
      return true;
    } catch (error) {
      print('카카오계정으로 로그인 실패 $error');
      return false;
    }
  }
}

Future<void> logoutKakao() async {
  try {
    await UserApi.instance.logout();
    await postLogOut();
    print("카카오 로그아웃 성공");
    await UserManager().clearUserInfo();
  } catch (error) {
    print("카카오 로그아웃 실패: $error");
  }
}
