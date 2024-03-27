package com.orange.fintech.account.dto;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class UpdateAccountDto {

    String bankCode;
    String accountNo;
}
