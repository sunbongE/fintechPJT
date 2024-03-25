package com.orange.fintech.account.dto;

import com.fasterxml.jackson.annotation.JsonFormat;
import java.time.LocalDate;
import java.time.LocalTime;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class AccountResDto {
    String bankCode;
    String bankName;
    String userName;
    String accountNo;
    String accountName;
    String accountTypeCode;
    String accountTypeName;

    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyyMMdd", timezone = "Asia/Seoul")
    LocalDate accountCreatedDate;

    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyyMMdd", timezone = "Asia/Seoul")
    LocalTime accountExpiryDate;

    String dailyTransferLimit;
    String oneTimeTransferLimit;
    String accountBalance;

    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyyMMdd", timezone = "Asia/Seoul")
    LocalTime lastTransactionDate;

    //    "bankCode": "001",
    //            "bankName": "한국은행",
    //            "userName": "qkrxogh7",
    //            "accountNo": "001367035538944",
    //            "accountName": "한국은행 수시입출금",
    //            "accountTypeCode": "1",
    //            "accountTypeName": "수시입출금",
    //            "accountCreatedDate": "20240311",
    //            "accountExpiryDate": "20290311",
    //            "dailyTransferLimit": "1000000000000",
    //            "oneTimeTransferLimit": "1000000000000",
    //            "accountBalance": "1000000",
    //            "lastTransactionDate": "20240311"
}
