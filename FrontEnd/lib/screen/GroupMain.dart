import 'package:flutter/material.dart';
import 'package:front/components/groups/GroupList.dart';
import 'package:front/screen/groupscreens/GroupAdd.dart';

//백에서 group정보 받아오면 여기에 넣기
// class Group {
//   final String title;
//   final String description;
//
//   Group({required this.title, required this.description});
// }

class GroupMain extends StatefulWidget {
  const GroupMain({Key? key}) : super(key: key);

  @override
  State<GroupMain> createState() => _GroupMain();
}

class _GroupMain extends State<GroupMain> {
  String title = "";
  String description = "";
  List<Group> groups = [];

  void addGroup(Group group) {
    setState(() {
      groups.add(group);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("그룹 목록"),
      ),
      body: GroupList(),
      // body: ListView.builder(
      //   itemCount: groups.length,
      //   itemBuilder: (context, index) {
      //     return ListTile(
      //       title: Text(groups[index].title),
      //       subtitle: Text(groups[index].description),
      //     );
      //   },
      // ),

      // floatingActionButton: ElevatedButton(
      //   onPressed: () {
      //     Navigator.push(
      //       context,
      //       MaterialPageRoute(
      //         builder: (_) => GroupAdd(addGroup), // addGroup 함수를 전달
      //       ),
      //     );
      //   },
      //   child: Icon(Icons.add),
      // ),
    );
  }
}

// class Group {
//   final String groupName;
//   final String groupTheme;
//   final String startDate;
//   final String endDate;
// }
//
// class GroupAdd extends StatelessWidget {
//   const GroupAdd({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//
//       child: Scaffold(
//           appBar: AppBar(
//             // automaticallyImplyLeading: false,
//             backgroundColor: Colors.white,
//             title: Text('새로운 그룹 만들기'),
//           ),
//           body: Column(
//             children: [
//               // 그룹 이름 입력 폼
//               TextFormField(
//                 decoration: InputDecoration(
//                   labelText: '그룹 이름',
//                 ),
//               ),
//               // 그룹 테마 입력 폼
//               TextFormField(
//                 decoration: InputDecoration(
//                   labelText: '그룹 테마',
//                 ),
//               ),
//               // 여행 시작일 설정
//               TextFormField(
//                 decoration: InputDecoration(
//                   labelText: '여행 시작일',
//                 ),
//                 keyboardType: TextInputType.datetime,
//                 // 여행 시작일 입력을 받을 수 있는 로직 추가
//               ),
//               // 여행 종료일 설정
//               TextFormField(
//                 decoration: InputDecoration(
//                   labelText: '여행 종료일',
//                 ),
//                 keyboardType: TextInputType.datetime,
//                 // 여행 종료일 입력을 받을 수 있는 로직 추가
//               ),
//             ],
//           )
//       ),
//     );
//   }
// }

//
// class GroupMain extends StatefulWidget {
//   const GroupMain({Key? key}) : super(key: key);
//
//   @override
//   _GroupMainState createState() => _GroupMainState();
// }
//
// class _GroupMainState extends State<GroupMain> {
//   String appBarText = '그룹목록';
//
//
//
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         appBar: AppBar(
//           automaticallyImplyLeading: false,
//           backgroundColor: Colors.white,
//           title: Text(appBarText), // 수정: 'appBarText' -> appBarText
//           actions: [
//             IconButton(
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => HomeScreen()),
//                 );
//               },
//               icon: Icon(Icons.backspace_outlined),
//             ),
//           ],
//         ),
//         body: Column(
//           children: [
//             Expanded(
//               child: Container(
//                 child: Center(
//                   child: GroupList(),
//                 ),
//               ),
//             ),
//             GroupAddButton(
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
