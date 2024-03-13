import 'dart:math';
import 'package:flutter/material.dart';
import 'package:front/components/intros/KeyBoardKey.dart';

class KeyBoardBoard extends StatefulWidget {
  @override
  State<KeyBoardBoard> createState() => _KeyBoardBoardState();
}

class _KeyBoardBoardState extends State<KeyBoardBoard> {
  List<List<dynamic>> keys = [
    ['1', '2', '3'],
    ['4', '5', '6'],
    ['7', '8', '9'],
  ];

  @override
  void initState() {
    super.initState();
    randomizeKeys();
  }

  void randomizeKeys() {
    final allKeys = keys.expand((element) => element).toList();
    allKeys.shuffle(Random());

    allKeys.add(null);
    allKeys.add('0');
    allKeys.add(Icon(Icons.keyboard_backspace));

    keys = [];
    for (var i = 0; i < allKeys.length; i += 3) {
      keys.add(allKeys.sublist(i, min(i + 3, allKeys.length)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: keys
            .map(
              (x) => Row(
                children: x.map(
                  (y) {
                    return Expanded(
                      child: KeyBoardKey(
                        label: y,
                        value: y,
                        onTap: (val) {},
                      ),
                    );
                  },
                ).toList(),
              ),
            )
            .toList(),
      ),
    );
  }
}
