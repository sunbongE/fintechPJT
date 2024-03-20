import 'package:flutter/material.dart';
import '../../entities/Group.dart';

class GroupDecription extends StatelessWidget {
  final Group group;
  final VoidCallback onEdit;

  const GroupDecription({Key? key, required this.group, required this.onEdit})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                group.description,
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                '${group.startDate} ~ ${group.endDate}',
                style: TextStyle(fontSize: 20),
              ),
            ],
          ),
        ),
        IconButton(
          icon: Icon(Icons.edit),
          onPressed: onEdit,
        ),
      ],
    );
  }
}
