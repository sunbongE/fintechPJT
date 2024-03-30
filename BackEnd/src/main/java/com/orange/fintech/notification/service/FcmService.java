package com.orange.fintech.notification.service;

import com.orange.fintech.notification.Dto.MessageListDataReqDto;
import com.orange.fintech.notification.Dto.UrgeTargetDto;
import java.io.IOException;
import java.util.List;
import org.springframework.http.ResponseEntity;

public interface FcmService {

    void pushListDataMSG(MessageListDataReqDto dto, String memberId) throws IOException;

    void pushListDataMSG(MessageListDataReqDto dto) throws IOException;

    void pushListDataMSG(List<UrgeTargetDto> urgeTargetDtoList) throws IOException;

    ResponseEntity<?> getIndividualNotification(String memberId);
}
