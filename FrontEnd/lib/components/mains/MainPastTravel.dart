import "package:flutter/material.dart";
import 'package:front/components/mains/MainPastTravelCard.dart';
import 'package:front/screen/groupscreens/GroupItem.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../../entities/Group.dart';

class PastTravelList extends StatefulWidget {
  final List<Group> groups;

  const PastTravelList({Key? key, required this.groups}) : super(key: key);

  @override
  State<PastTravelList> createState() => _PastTravelListState();
}

class _PastTravelListState extends State<PastTravelList> {
  void navigateToGroupDetail(Group group) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => GroupItem(group: group)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredGroups = widget.groups.where((group) => group.isCalculateDone).toList();
    // if (filteredGroups.isEmpty) {
    //   return Scaffold(
    //     body: Center(
    //       child: Text('이전 여행이 없습니다.'),
    //     ),
    //   );
    // }

    return Scaffold(
      body: CarouselSlider.builder(
        itemCount: widget.groups.length,
        itemBuilder: (context, index, realIndex) {
          return MainPastTravelCard(
            group: widget.groups[index],
            onTap: () {
              navigateToGroupDetail(widget.groups[index]);
            },
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
