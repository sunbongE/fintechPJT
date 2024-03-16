import 'package:flutter/material.dart';
import 'package:front/components/intros/KeyBoardKey.dart';
import 'dart:math';

class KeyBoardBoard extends StatefulWidget {
  final Function(String) onKeyTap;

  const KeyBoardBoard({super.key, required this.onKeyTap});

  @override
  State<KeyBoardBoard> createState() => _KeyBoardBoardState();
}

class _KeyBoardBoardState extends State<KeyBoardBoard> {

  String passWord = '';
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

  void onKeyTap(String val) {
    setState(() {
      if (passWord.length < 6) {
        passWord += val;
        widget.onKeyTap(passWord);
      }
    });
  }

  void onBackSpace() {
    setState(() {
      if(passWord.isNotEmpty) {
        passWord = passWord.substring(0, passWord.length - 1);
        widget.onKeyTap(passWord);
      }
    });
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
                        onTap: (val) {
                          if (val is Widget) {
                            onBackSpace();
                          } else {
                            onKeyTap(val);
                          }
                        },
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
