package com.orange.fintech.notification.service;

import com.orange.fintech.notification.Dto.messageListDataReqDto;
import java.io.IOException;
import org.springframework.http.ResponseEntity;

public interface FcmService {

    ResponseEntity<?> pushListDataMSG(messageListDataReqDto dto, String memberId)
            throws IOException;
}
