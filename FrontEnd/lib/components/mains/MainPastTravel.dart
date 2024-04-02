import "package:flutter/material.dart";
import 'package:front/components/mains/MainPastTravelCard.dart';
import 'package:front/components/mypage/MyTripHistoryDetail.dart';
import 'package:front/screen/groupscreens/GroupItem.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../../entities/Group.dart';

class PastTravelList extends StatefulWidget {
  final List<Group> groups;

  const PastTravelList({Key? key, required this.groups}) : super(key: key);

  @override
  State<PastTravelList> createState() => _PastTravelListState();
}

// 과거여행 보기
class _PastTravelListState extends State<PastTravelList> {
  final List<String> imageNames = [
    'assets/images/mainpast/m1.jpg',
    'assets/images/mainpast/m3.jpg',
    'assets/images/mainpast/m4.jpg',
    'assets/images/mainpast/m5.jpg',
    'assets/images/mainpast/m6.jpg',
    'assets/images/mainpast/m7.jpg',
    'assets/images/mainpast/m8.jpg',
    'assets/images/mainpast/m9.jpg',
    'assets/images/mainpast/m10.jpg',
    'assets/images/mainpast/m11.jpg',
  ];

  @override
  Widget build(BuildContext context) {
    final filteredGroups = widget.groups.where((group) => group.isCalculateDone).toList();
    if (filteredGroups.isEmpty) {
      return Scaffold(
        body: Center(
          child: Text('이전 여행이 없습니다.'),
        ),
      );
    }

    return Scaffold(
      body: CarouselSlider.builder(
        itemCount: filteredGroups.length,
        itemBuilder: (context, index, realIndex) {
          final imagePath = imageNames[index % imageNames.length];
          return MainPastTravelCard(
            group: filteredGroups[index],
            imagePath: imagePath,
          );
        },
        options: CarouselOptions(
          autoPlay: false,
          aspectRatio: 3.0,
          viewportFraction: 0.6,
        ),
      ),
    );
  }
}
