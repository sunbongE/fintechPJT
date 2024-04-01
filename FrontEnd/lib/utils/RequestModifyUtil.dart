import 'dart:core';

/**
 *
 * 정산 수정에 필요한 함수들을 넣을 예정입니다.
 *
 * */
bool isModifyButtonEnabled(
    int amount, List<int> personalRequestAmount, int remainderAmount) {
  int totalAmount = personalRequestAmount.fold(0, (sum, item) => sum + item) +
      remainderAmount;
  return totalAmount == amount;
}

List<int> reCalculateAmount(
    int amount, List<int> personalRequestAmount, List<bool> isLockedList) {
  //전부 isLocked인데 금액이 안맞는 경우는 알림창을 따로 띄울 것
  //마지막 사람이 토글을 끄면 전부 0
  int fixedSummary = 0;
  List<int> changeIndexList = [];
  for (int i = 0; i < personalRequestAmount.length; i++) {
    if (personalRequestAmount[i] > 0 && isLockedList[i] == false) {
      changeIndexList.add(i);
    } else {
      fixedSummary += personalRequestAmount[i];
    }
  }

  List<int> newList = personalRequestAmount.map((e) => e).toList();
  if (changeIndexList.isNotEmpty) {
    //이거 안하면 dived Zero
    int newAmount = ((amount - fixedSummary) / changeIndexList.length).toInt();
    for (int i = 0; i < changeIndexList.length; i++) {
      newList[changeIndexList[i]] = newAmount;
    }
    //자동 계산에 음수가 되지 않게 설정
    bool newListHasNegative = newList.any((element) => element < 0);
    if (newListHasNegative) {
      return List<int>.filled(newList.length, 0);
    }
  }
  //print(newList);
  return newList;
}

int reCalculateRemainder(int amount, List<int> personalRequestAmount) {
  //전부 숫자입력이면 자투리 금액으로 몰빵가능한건 막아야함
  int totalRequestAmount = amount;
    totalRequestAmount =
        personalRequestAmount.fold(0, (sum, item) => sum + item);
    int tmp = amount - totalRequestAmount;
  return tmp > personalRequestAmount.length? 0: tmp;
}
