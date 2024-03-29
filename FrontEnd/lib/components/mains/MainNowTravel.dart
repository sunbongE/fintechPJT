import "package:flutter/material.dart";
import 'package:front/components/mains/MainNowTravelCard.dart';
import 'package:front/screen/groupscreens/GroupItem.dart';
import 'package:front/screen/groupscreens/GroupAdd.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../../entities/Group.dart';
import 'package:front/models/button/GroupAddButton.dart';

class NowTravelList extends StatefulWidget {
  final List<Group> groups;

  const NowTravelList({Key? key, required this.groups}) : super(key: key);

  @override
  State<NowTravelList> createState() => _NowTravelListState();
}

class _NowTravelListState extends State<NowTravelList> {
  int _currentPage = 0;

  void navigateToGroupDetail(Group group) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => GroupItem(groupId: group.groupId!)),
    );
  }

  void navigateToGroupAdd() async {
    final Group? newGroup = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => GroupAdd()),
    );

    if (newGroup != null) {
      setState(() {
        widget.groups.add(newGroup);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.groups.length == 0) {
      return Scaffold(
        body: Center(
            child: Column(
          children: [GroupAddButton(onPressed: navigateToGroupAdd)],
        )),
      );
    }

    return Scaffold(
      body: CarouselSlider.builder(
        itemCount: widget.groups.length,
        itemBuilder: (context, index, realIndex) {
          return MainNowTravelCard(
            group: widget.groups[index],
            onTap: () {
              navigateToGroupDetail(widget.groups[index]);
            },
            isCenter: index == _currentPage,
          );
        },
        options: CarouselOptions(
            autoPlay: false,
            aspectRatio: 3.0,
            enlargeCenterPage: true,
            viewportFraction: 0.5,
            onPageChanged: (index, reason) {
              setState(() {
                _currentPage = index;
              });
            }),
      ),
    );
  }
}
