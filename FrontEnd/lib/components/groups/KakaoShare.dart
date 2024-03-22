// import 'package:flutter/material.dart';
// import '../../entities/Group.dart';
// import 'package:kakao_flutter_sdk_share/kakao_flutter_sdk_share.dart';
// import 'package:kakao_flutter_sdk_template/kakao_flutter_sdk_template.dart';
//
//
// /// 카카오 공유하기
// class KakaoShareManager {
//
//   /// 카카오톡 설치 유무
//   Future<bool> isKakaotalkInstalled() async {
//     bool isKakaoTalkSharingAvailable = await ShareClient.instance.isKakaoTalkSharingAvailable();
//     return isKakaoTalkSharingAvailable;
//   }
//
//   /// 카카오톡 공유하기
//   void shareMyCode(String inputJson) async {
//
//     bool isKakaoTalkSharingAvailable = await ShareClient.instance.isKakaoTalkSharingAvailable();
//
//     Map<String, dynamic> jsonMap = json.decode(inputJson);
//     String url = jsonMap['url'];
//
//     // 파이어베이스 다이나믹 링크 생성
//     Uri mobileLink = await buildDynamicLink(url);
//
//     // 카카오톡 공유하기 탬플릿 생성
//     var template =  _getTemplateV2(jsonMap, mobileLink);
//
//     // 설치 여부에 따른 로직 분기
//     if (isKakaoTalkSharingAvailable) {
//       Uri uri = await ShareClient.instance.shareDefault(template: template);
//       await ShareClient.instance.launchKakaoTalk(uri);
//     }else{
//       Uri shareUrl = await WebSharerClient.instance.makeDefaultUrl(template: template);
//       await launchBrowserTab(shareUrl, popupOpen: true);
//     }
//   }
//
//   /// 탬플릿 제작
//   DefaultTemplate _getTemplateV2(Map<String,dynamic> jsonMap, Uri mobileLink){
//
//     String title = jsonMap['title'];
//     String description = jsonMap['description'];
//     String imageUrl = jsonMap['imageUrl'];
//     String url = jsonMap['url'];
//     String likeCount = jsonMap['likeCount'].toString();
//     String commentCount = jsonMap['commentCount'].toString();
//
//     final FeedTemplate template = FeedTemplate(
//       content: Content(
//         title: title,
//         description: description,
//         imageUrl: Uri.parse(imageUrl),
//         link: Link(
//             webUrl: Uri.parse(url),
//             mobileWebUrl: Uri.parse(url)),
//       ),
//       social: Social(
//         likeCount: int.parse(likeCount),
//         commentCount: int.parse(commentCount),
//       ),
//       buttons: [
//         Button(
//           title: '웹으로 보기',
//           link: Link(
//             webUrl: Uri.parse(url),
//             mobileWebUrl: Uri.parse(url),
//           ),
//         ),
//         Button(
//           title: '앱으로보기',
//           link: Link(
//             mobileWebUrl: mobileLink,
//           ),
//         ),
//       ],
//     );
//
//     return template;
//
//   }
//
// /// + buildDynamicLink(String url) 생략
//
// }