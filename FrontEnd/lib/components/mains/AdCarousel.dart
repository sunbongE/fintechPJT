import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class AdCarousel extends StatelessWidget {
  final List<String> imgList = [
    'assets/images/fish.PNG',
    'assets/images/mela.PNG',
    'assets/images/iandwe.PNG',
    'assets/images/myname.png',
  ];

  @override
  Widget build(BuildContext context) {
    // 화면 너비를 가져옵니다.
    var screenWidth = MediaQuery.of(context).size.width;

    return CarouselSlider(
      options: CarouselOptions(
        viewportFraction: 1.0,
        autoPlay: true,
        aspectRatio: 1430 / 320,
      ),
      items: imgList
          .map((item) => Container(
                width: screenWidth,
                child: Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(item, fit: BoxFit.cover),
                  ),
                ),
              ))
          .toList(),
    );
  }
}
