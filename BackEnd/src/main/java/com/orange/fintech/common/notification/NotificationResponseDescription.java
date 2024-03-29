package com.orange.fintech.common.notification;

public interface NotificationResponseDescription {

    String INVITE = "님으로부터 여정에 초대받았어요. 함께 여행을 떠나볼까요?";
    String SPLIT = "에 여행 정산 내역이 있습니다. 지금 바로 확인해보세요.";
    String TRANSFER = "에 대한 정산액이 출금되었습니다. 상세 내역을 확인해보세요.";
    String SPLIT_MODIFY = "의 정산 요청 내역이 변경되었습니다. 요청 내용을 확인해보세요.";
    String NO_MONEY = "정산중 회원님의 잔액이 부족하여 정산이 취소되었습니다. ";
    String URGE = "님의 정산을 기다리고 있어요. 지금 확인해보세요."; // {그룹 이름}에서 {이름}님의 정산을 기다리고 있어요. 지금 확인해보세요
}
