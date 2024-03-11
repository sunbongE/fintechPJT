import 'package:flutter/material.dart';
import 'package:front/const/colors/Colors.dart';
import 'package:front/screen/GroupAdd.dart';

class GroupAddButton extends StatelessWidget {
  const GroupAddButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      height: 50,
      decoration: BoxDecoration(
        color: ADDBUTTON,
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextButton(
        onPressed: () {
          // 그룹 생성 page로 이동
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => GroupAdd()),
          );
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add,
              color: Colors.black,
            ),
            SizedBox(width: 5),
            Text(
              '그룹 추가하기',
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
