// class GroupList extends StatelessWidget {
//   const GroupList({Key? key}) : super(key: key);
//   Widget build(BuildContext context) {
//     return ListView(
//       padding: EdgeInsets.all(20.0),
//       children: [
//         Card(
//           margin: EdgeInsets.all(10.0),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(15),
//           ),
//           color: TRAVELING,
//           child: ListTile(
//             horizontalTitleGap: 10,
//             title: Text(
//               '오늘의 날짜',
//               style: TextStyle(
//                 color: Colors.white,
//                 fontSize: 13,
//               ),
//             ),
//             subtitle: Row(
//               children: [
//                 Expanded(
//                   child: Text(
//                     '긔염둥이들',
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 15,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             leading: Padding(
//               padding: EdgeInsets.all(8.0),
//             ),
//             trailing: TravelingButton(
//               btnText: '여행중',
//             ),
//             onTap: () {},
//           ),
//         ),
//         Card(
//           margin: EdgeInsets.all(10.0),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(15),
//           ),
//           color: COMPLETE_COLOR,
//           child: ListTile(
//             horizontalTitleGap: 10,
//             title: Text(
//               '오늘의 날짜',
//               style: TextStyle(
//                 color: Colors.white,
//                 fontSize: 13,
//               ),
//             ),
//             subtitle: Row(
//               children: [
//                 Expanded(
//                   child: Text(
//                     '오렌지',
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 15,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             leading: Padding(
//               padding: EdgeInsets.all(8.0),
//             ),
//             trailing: TravelingButton(
//               btnText: '정산중',
//             ),
//
//             onTap: () {
//
//             },
//           ),
//         ),
//       ],
//     );
//   }