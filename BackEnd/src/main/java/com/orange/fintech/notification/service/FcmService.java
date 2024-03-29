package com.orange.fintech.notification.service;

import com.orange.fintech.notification.Dto.messageListDataReqDto;
import java.io.IOException;

public interface FcmService {

    void pushListDataMSG(messageListDataReqDto dto, String memberId) throws IOException;
}
