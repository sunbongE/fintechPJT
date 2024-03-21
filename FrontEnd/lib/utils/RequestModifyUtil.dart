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
