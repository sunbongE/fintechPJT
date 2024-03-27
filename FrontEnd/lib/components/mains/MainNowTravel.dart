import "package:flutter/material.dart";
import 'package:front/components/mains/MainNowTravelCard.dart';
import 'package:front/screen/groupscreens/GroupItem.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../../entities/Group.dart';

class NowTravelList extends StatefulWidget {
  final List<Group> groups;

  const NowTravelList({Key? key, required this.groups}) : super(key: key);

  @override
  State<NowTravelList> createState() => _NowTravelListState();
}

class _NowTravelListState extends State<NowTravelList> {
  void navigateToGroupDetail(Group group) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => GroupItem(group: group)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CarouselSlider.builder(
        itemCount: widget.groups.length,
        itemBuilder: (context, index, realIndex) {
          return MainNowTravelCard(
            group: widget.groups[index],
            onTap: () {
              navigateToGroupDetail(widget.groups[index]);
            },
          );
        },
        options: CarouselOptions(

          autoPlay: false,
          aspectRatio: 3.0,
          enlargeCenterPage: true,
          viewportFraction: 0.37,
        ),
      ),
    );
  }
}