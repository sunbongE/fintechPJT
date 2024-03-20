import 'package:flutter/material.dart';

class SaveGroupButton extends StatelessWidget {
  final VoidCallback onSave;

  const SaveGroupButton({
    Key? key,
    required this.onSave,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onSave,
      child: Text('저장'),
    );
  }
}
