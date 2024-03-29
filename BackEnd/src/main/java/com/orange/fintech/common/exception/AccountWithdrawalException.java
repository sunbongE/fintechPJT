package com.orange.fintech.common.exception;

import lombok.extern.slf4j.Slf4j;

@Slf4j
public class AccountWithdrawalException extends Exception {
    public AccountWithdrawalException() {
        log.error("결제 실패");
    }
}
