import 'GroupMember.dart';

class Group {
  final int? groupId;
  final String groupName;
  final String theme;
  final String startDate;
  final String endDate;
  bool? groupState;
  final bool isCalculateDone;
  final List<GroupMember> groupMembers;

  Group({
    this.groupId,
    required this.groupName,
    required this.theme,
    required this.startDate,
    required this.endDate,
    required this.groupState,
    required this.isCalculateDone,
    required this.groupMembers,
  });
  factory Group.fromJson(Map<String, dynamic> json) {
    // groupMembers 필드가 JSON에 없기 때문에 빈 리스트로 초기화
    List<GroupMember> membersList = [];

    return Group(
      groupId: json['groupId'],
      groupName: json['groupName'],
      theme: json['theme'] ?? '',  // theme이 null일 경우 기본 값 설정
      startDate: json['startDate'],
      endDate: json['endDate'],
      groupState: json['groupState'],
      isCalculateDone: json['isCalculateDone'],
      groupMembers: membersList,
    );
  }
}