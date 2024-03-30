package com.orange.fintech.member.dto;

import com.orange.fintech.account.entity.Account;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Schema(description = "로그인시 계좌 정보 Dto")
public class PrimaryAccountRes {

    private String accountNo;

    private String bankCode;

    public static PrimaryAccountRes of(Account account) {
        PrimaryAccountRes res = new PrimaryAccountRes();
        res.setAccountNo(account.getAccountNo());
        res.setBankCode(account.getBankCode());
        return res;
    }
}
