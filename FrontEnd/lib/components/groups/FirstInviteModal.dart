import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

class FirstInviteModal {
  static void showInviteModal(BuildContext context, String groupId) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('그룹을 만드셨네요!'),
          content: Text('링크를 공유해서 친구들을 초대해보세요'),
          actions: [
            ElevatedButton(
              onPressed: () => cancelPressed(context),
              child: Text('취소'),
            ),
            ElevatedButton(
              onPressed: () => sharePressed(context),
              child: Text('공유하기'),
            ),
          ],
        );
      },
    );
  }

  static void sharePressed(context) {
    String inviteLink = 'https://halgatewood.com/deeplink?link=yeojung%3A%2F%2Fexample.com';
    Navigator.of(context).pop();

    Share.share('그룹에 참가하려면 다음 링크에서 YEOJUNG://example.com를 클릭하세요!: $inviteLink');

  }
  static void cancelPressed(BuildContext context) {
    Navigator.of(context).pop();
  }
}
