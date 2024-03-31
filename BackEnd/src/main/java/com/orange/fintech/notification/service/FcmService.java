package com.orange.fintech.notification.service;

import com.orange.fintech.notification.Dto.MessageListDataReqDto;
import com.orange.fintech.notification.Dto.UrgeTargetDto;
import java.io.IOException;
import java.util.List;
import org.springframework.http.ResponseEntity;
import org.springframework.scheduling.annotation.Async;

public interface FcmService {

    void pushListDataMSG(MessageListDataReqDto dto, String memberId) throws IOException;

    @Async
    void pushListDataMSG(MessageListDataReqDto dto) throws IOException;

    void pushListDataMSG(List<UrgeTargetDto> urgeTargetDtoList) throws IOException;

    ResponseEntity<?> getIndividualNotification(String memberId);

    @Async
    void noMoneyFcm(List<String> noMoneysKakaoId, int groupId) throws IOException;
}
