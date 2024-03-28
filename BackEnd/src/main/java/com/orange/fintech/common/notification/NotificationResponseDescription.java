package com.orange.fintech.common.notification;

public interface NotificationResponseDescription {

    String INVITE = "님으로부터 여정에 초대받았어요. 함께 여행을 떠나볼까요?";
    String CREATE_YEOJUNG = "{그룹 이름}에서 여행 정산 내역이 새롭게 제작되었습니다. 지금 바로 확인해보세요.";
    String UPDATE_YEOJUNG = "{그룹 이름}에서 정산에 대한 수정 요청이 도착했습니다. 요청 내용을 확인해 주세요.";
}
