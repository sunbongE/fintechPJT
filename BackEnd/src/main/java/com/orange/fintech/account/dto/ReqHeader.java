package com.orange.fintech.account.dto;

import java.util.Random;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class ReqHeader {

    String apiName;
    String transmissionDate;
    String transmissionTime;
    String institutionCode;
    String fintechAppNo;
    String apiServiceCode;
    String institutionTransactionUniqueNo; // 20자리 난수.
    String apiKey;
    String userKey;

    private String generalTUN() {
        Random random = new Random();
        StringBuilder sb = new StringBuilder();

        for (int i = 0; i < 20; i++) {
            sb.append(random.nextInt(10));
        }

        String TUN = sb.toString();
        return TUN;
    }

    public ReqHeader() {
        this.institutionTransactionUniqueNo = generalTUN();
        this.transmissionDate = "20240101";
        this.transmissionTime = "121212";
        this.institutionCode = "00100";
        this.fintechAppNo = "001";
    }

    //     "apiName": "inquireAccountList",
    //             "transmissionDate": "20240101",
    //             "transmissionTime": "121212",
    //             "institutionCode": "00100",
    //             "fintechAppNo": "001",
    //             "apiServiceCode": "inquireAccountList",
    //             "institutionTransactionUniqueNo": "20240015121212123490",
    //             "apiKey": "a2ceeb8bd60c4103a582d68fb30ea29d",
    //             "userKey": "df9ce83a-b9e2-4218-ab4f-5d66032c6330"
}
