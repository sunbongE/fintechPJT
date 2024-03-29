// import 'package:flutter/material.dart';
// import 'package:url_launcher/url_launcher.dart';
// import '../../entities/Group.dart';
// // import 'package:kakao_flutter_sdk_share/kakao_flutter_sdk_share.dart';
// // import 'package:kakao_flutter_sdk_template/kakao_flutter_sdk_template.dart';
// import 'package:share_plus/share_plus.dart';
//
//
// class FirstInviteModal {
//   static void showInviteModal(BuildContext context, String response) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('그룹을 만드셨네요!'),
//           content: Text('링크를 공유해서 친구들을 초대해보세요'),
//           actions: [
//             ElevatedButton(
//               onPressed: () => sharePressed(response),
//               child: Text('공유하기'),
//             ),
//           ],
//         );
//       },
//     );
//
//   }
//
//   void _launchURL() async {
//     final Uri _url = Uri.parse('yeojung://example.com');
//     if (await canLaunchUrl(_url)) {
//       await launchUrl(_url);
//     } else {
//       throw 'Could not launch $_url';
//     }
//   }
//
//   static void sharePressed(String groupId) {
//     String baseUrl = 'https://yourapp.com'; // 여기에 앱이나 웹서비스의 기본 URL을 넣으세요.
//     String inviteLink = 'http://j10c203.p.ssafy.io:8080/api/v1/groups/$groupId/invite';
//
//     String message = '친구를 그룹에 초대하세요! 링크를 클릭하면 그룹에 참여하게 됩니다: $inviteLink';
//     Share.share(message);
//
//   }
// }
//   static void _kakaoShare(BuildContext context, Group newGroup) async {
//     try {
//       final CalendarTemplate calendarTemplate = CalendarTemplate(
//         idType: IdType.event,
//         id: '${newGroup.groupName}',
//         content: Content(
//           title: '${newGroup.groupName}',
//           description: '${newGroup.theme}에 초대합니다.',
//           imageUrl: Uri.parse(
//               'assets/images/splash_logo_768.png'),
//           link: Link(
//             webUrl: Uri.parse('https://developers.kakao.com'),
//             mobileWebUrl: Uri.parse('https://developers.kakao.com'),
//           ),
//         ),
//         buttons: [
//           Button(
//             title: '모임 주제 보기',
//             link: Link(
//               webUrl: Uri.parse('https://developers.kakao.com'),
//               mobileWebUrl: Uri.parse('https://developers.kakao.com'),
//             ),
//           )
//         ],
//       );
//       // await ShareClient.instance.shareDefault(template: calendarTemplate);
//       bool isKakaoTalkSharingAvailable = await ShareClient.instance.isKakaoTalkSharingAvailable();
//
//       // 카카오톡으로 공유
//       if (isKakaoTalkSharingAvailable) {
//         await ShareClient.instance.shareDefault(template: calendarTemplate);
//       } else {
//         // 카카오톡이 설치되어 있지 않은 경우, 예외 처리
//         print('카카오톡이 설치되어 있지 않습니다. 웹 공유를 사용하세요.');
//       }
//       Navigator.pop(context); // 공유 후 모달창 닫기
//     } catch (error) {
//       print('카카오톡 공유 실패: $error');
//     }
//   }
// }




//
// class FirstInviteModal {
//   static void showInviteModal(BuildContext context, Group newGroup) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('그룹을 만드셨네요!'),
//           content: Text('링크를 공유해서 친구들을 초대해보세요'),
//           actions: [
//             ElevatedButton(
//               onPressed: () {
//                 _kakaoShare(context, newGroup);
//               },
//               child: Text('공유하기'),
//             ),
//           ],
//         );
//       },
//     );
//   }
//
//   static void _kakaoShare(BuildContext context, Group newGroup) async {
//     try {
//       final template = TextTemplate(
//         text: '그룹을 만드셨네요! 링크를 공유해서 친구들을 초대해보세요. ${newGroup.title} ${newGroup.description}에 초대합니다.',
//         link: Link(
//           webUrl: Uri.parse('https://developers.kakao.com'),
//           mobileWebUrl: Uri.parse('https://developers.kakao.com'),
//         ),
//       );
//       await ShareClient.instance.shareDefault(template: template);
//
//       Navigator.pop(context); // 공유 후 모달창 닫기
//     } catch (error) {
//       print('카카오톡 공유 실패: $error');
//     }
//   }

// static void _kakaoShare(BuildContext context, Group newGroup) async {
  //   try {
  //     final CalendarTemplate calendarTemplate = CalendarTemplate(
  //       idType: IdType.event,
  //       id: '${newGroup.title}',
  //       content: Content(
  //         title: '${newGroup.title}',
  //         description: '${newGroup.description}에 초대합니다.',
  //         imageUrl: Uri.parse(
  //             'assets/images/splash_logo_768.png'),
  //         link: Link(
  //           webUrl: Uri.parse('https://developers.kakao.com'),
  //           mobileWebUrl: Uri.parse('https://developers.kakao.com'),
  //         ),
  //       ),
  //       buttons: [
  //         Button(
  //           title: '모임 주제 보기',
  //           link: Link(
  //             webUrl: Uri.parse('https://developers.kakao.com'),
  //             mobileWebUrl: Uri.parse('https://developers.kakao.com'),
  //           ),
  //         )
  //       ],
  //     );
  //     await ShareClient.instance.shareDefault(template: calendarTemplate);
  //
  //     Navigator.pop(context); // 공유 후 모달창 닫기
  //   } catch (error) {
  //     print('카카오톡 공유 실패: $error');
  //   }
  // }
// }

// import 'package:flutter/material.dart';
// import 'package:url_launcher/url_launcher.dart';
// import '../../entities/Group.dart';
// import 'package:share_plus/share_plus.dart';
//
// class FirstInviteModal {
//   static void showInviteModal(BuildContext context, String response) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('그룹을 만드셨네요!'),
//           content: Text('링크를 공유해서 친구들을 초대해보세요'),
//           actions: [
//             ElevatedButton(
//               onPressed: () => sharePressed(),
//               child: Text('공유하기'),
//             ),
//           ],
//         );
//       },
//     );
//   }
//
//   static void _launchURL() async {
//     final Uri _url = Uri.parse('yeojung://example.com');
//     if (await canLaunchUrl(_url)) {
//       await launchUrl(_url);
//     } else {
//       throw 'Could not launch $_url';
//     }
//   }
//
//   static void sharePressed() {
//     _launchURL();
//     Share.share('yeojung://example.com');
//   }
// }

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../entities/Group.dart'; // 이 예제에서는 사용되지 않습니다.
import 'package:share_plus/share_plus.dart';

class FirstInviteModal {
  static void showInviteModal(BuildContext context, String groupId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('그룹을 만드셨네요!'),
          content: Text('링크를 공유해서 친구들을 초대해보세요'),
          actions: [
            ElevatedButton(
              onPressed: () => sharePressed(),
              // onPressed: () => sharePressed(groupId),

              child: Text('공유하기'),
            ),
          ],
        );
      },
    );
  }

  // static void _launchURL(String url) async {
  //   final Uri _url = Uri.parse(url);
  //   if (await canLaunchUrl(_url)) {
  //     await launchUrl(_url);
  //   } else {
  //     throw 'Could not launch $_url';
  //   }
  // }

  static void sharePressed() {
    // String inviteLink = 'yeojung://example.com/group/$groupId'; // 예시로 사용된 딥링크 형식입니다.
    String inviteLink = 'yeojung://example.com';
    // 해당 링크를 공유합니다.
    Share.share('그룹에 초대하려면 다음 링크를 클릭하세요: $inviteLink');
  }
}
