import 'GroupMember.dart';

class Group {
  final String title;
  final String description;
  final String startDate;
  final String endDate;
  bool? groupState;
  final List<GroupMember> groupMembers;

  Group({
    required this.title,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.groupState,
    required this.groupMembers,
  });

  factory Group.fromJson(Map<String, dynamic> json) {
    var membersJson = json['groupMember'] as List;
    List<GroupMember> membersList = membersJson.map((memberJson) => GroupMember.fromJson(memberJson)).toList();

    return Group(
      title: json['title'],
      description: json['description'],
      startDate: json['startDate'],
      endDate: json['endDate'],
      groupState: json['groupState'],
      groupMembers: membersList,
    );
  }
}