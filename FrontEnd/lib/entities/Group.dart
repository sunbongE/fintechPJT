import 'GroupMember.dart';

class Group {
  final String groupName;
  final String theme;
  final String startDate;
  final String endDate;
  bool? groupState;
  final List<GroupMember> groupMembers;

  Group({
    required this.groupName,
    required this.theme,
    required this.startDate,
    required this.endDate,
    required this.groupState,
    required this.groupMembers,
  });
  factory Group.fromJson(Map<String, dynamic> json) {
    // groupMembers 필드가 JSON에 없기 때문에 빈 리스트로 초기화
    List<GroupMember> membersList = []; // 예제에서 GroupMember 리스트를 어떻게 처리해야 하는지에 대한 정보가 없어 빈 리스트로 처리

    return Group(
      groupName: json['groupName'],
      theme: json['theme'] ?? '',  // theme이 null일 경우 기본 값 설정
      startDate: json['startDate'],
      endDate: json['endDate'],
      groupState: json['isCalculateDone'],  // isCalculateDone을 groupState로 매핑
      groupMembers: membersList,
    );
  }

  // factory Group.fromJson(Map<String, dynamic> json) {
  //   var membersJson = json['groupMember'] as List;
  //   List<GroupMember> membersList = membersJson.map((memberJson) => GroupMember.fromJson(memberJson)).toList();
  //
  //   return Group(
  //     groupName: json['groupName'],
  //     theme: json['theme'],
  //     startDate: json['startDate'],
  //     endDate: json['endDate'],
  //     groupState: json['groupState'],
  //     groupMembers: membersList,
  //   );
  // }
}