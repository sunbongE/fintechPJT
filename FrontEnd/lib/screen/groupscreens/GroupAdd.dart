import 'package:flutter/material.dart';
import 'package:front/components/groups/GroupList.dart';// Group 클래스를 import
import 'package:front/models/Calendar.dart';


class GroupAdd extends StatefulWidget {
  @override
  _GroupAddState createState() => _GroupAddState();
}

class _GroupAddState extends State<GroupAdd> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();

  void saveGroup() {
    String title = _titleController.text;
    String description = _descriptionController.text;

    Group newGroup = Group(title: title, description: description);
    Navigator.pop(context, newGroup);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Group'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Title',
              ),
            ),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: 'Description',
              ),
            ),
            ElevatedButton(
              onPressed: saveGroup,
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
