package com.orange.fintech.notification.service;

import com.orange.fintech.notification.Dto.MessageListDataReqDto;
import java.io.IOException;

public interface FcmService {

    void pushListDataMSG(MessageListDataReqDto dto, String memberId) throws IOException;

    void pushListDataMSG(MessageListDataReqDto dto) throws IOException;
}
