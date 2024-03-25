import 'package:flutter/material.dart';

import '../../screen/HomeScreen.dart';

void buttonSlideAnimation(BuildContext context, Widget page, {Duration duration = const Duration(milliseconds: 300)}) {
  Navigator.push(
    context,
    PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset(1.0, 0.0);
        var end = Offset.zero;
        var curve = Curves.ease;
        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);

        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
      transitionDuration: duration,
    ),
  );
}

void buttonSlideAnimatioThenOnPop(BuildContext context, Widget page, {Duration duration = const Duration(milliseconds: 300), required Function() onPop}) {
  Navigator.push(
    context,
    PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset(1.0, 0.0);
        var end = Offset.zero;
        var curve = Curves.ease;
        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);

        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
      transitionDuration: duration,
    ),
  ).then((_) => onPop());
}

// 모든 스택 초기화 및 nav에 속한 메뉴들의 첫 화면로 갈 때
// 사용법 : buttonSlideAnimationPushAndRemoveUntil(context, 3);
// 홈스크린의 3번째 인덱스 = MyPage로 감
void buttonSlideAnimationPushAndRemoveUntil(BuildContext context, int initialIndex, {Duration duration = const Duration(milliseconds: 300)}) {
  Navigator.pushAndRemoveUntil(
    context,
    PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => HomeScreen(initialIndex: initialIndex),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset(-1.0, 0.0);
        var end = Offset.zero;
        var curve = Curves.ease;
        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);

        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
      transitionDuration: duration,
    ),
        (Route<dynamic> route) => false,
  );
}
