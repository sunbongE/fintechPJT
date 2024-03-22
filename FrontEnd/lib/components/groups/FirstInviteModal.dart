import 'package:flutter/material.dart';
import '../../entities/Group.dart';
import 'package:kakao_flutter_sdk_share/kakao_flutter_sdk_share.dart';
import 'package:kakao_flutter_sdk_template/kakao_flutter_sdk_template.dart';
import 'package:flutter/material.dart';
import '../../entities/Group.dart';
import 'package:kakao_flutter_sdk_share/kakao_flutter_sdk_share.dart';
import 'package:kakao_flutter_sdk_common/kakao_flutter_sdk_common.dart';
import 'package:flutter/material.dart';
import '../../entities/Group.dart';
import 'package:kakao_flutter_sdk_share/kakao_flutter_sdk_share.dart';

class FirstInviteModal {
  static void showInviteModal(BuildContext context, Group newGroup) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('그룹을 만드셨네요!'),
          content: Text('링크를 공유해서 친구들을 초대해보세요'),
          actions: [
            ElevatedButton(
              onPressed: () {
                _kakaoShare(context, newGroup);
              },
              child: Text('공유하기'),
            ),
          ],
        );
      },
    );
  }

  static void _kakaoShare(BuildContext context, Group newGroup) async {
    try {
      final CalendarTemplate calendarTemplate = CalendarTemplate(
        idType: IdType.event,
        id: '${newGroup.groupName}',
        content: Content(
          title: '${newGroup.groupName}',
          description: '${newGroup.theme}에 초대합니다.',
          imageUrl: Uri.parse(
              'assets/images/splash_logo_768.png'),
          link: Link(
            webUrl: Uri.parse('https://developers.kakao.com'),
            mobileWebUrl: Uri.parse('https://developers.kakao.com'),
          ),
        ),
        buttons: [
          Button(
            title: '모임 주제 보기',
            link: Link(
              webUrl: Uri.parse('https://developers.kakao.com'),
              mobileWebUrl: Uri.parse('https://developers.kakao.com'),
            ),
          )
        ],
      );
      // await ShareClient.instance.shareDefault(template: calendarTemplate);
      bool isKakaoTalkSharingAvailable = await ShareClient.instance.isKakaoTalkSharingAvailable();

      // 카카오톡으로 공유
      if (isKakaoTalkSharingAvailable) {
        await ShareClient.instance.shareDefault(template: calendarTemplate);
      } else {
        // 카카오톡이 설치되어 있지 않은 경우, 예외 처리
        print('카카오톡이 설치되어 있지 않습니다. 웹 공유를 사용하세요.');
      }
      Navigator.pop(context); // 공유 후 모달창 닫기
    } catch (error) {
      print('카카오톡 공유 실패: $error');
    }
  }
}




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