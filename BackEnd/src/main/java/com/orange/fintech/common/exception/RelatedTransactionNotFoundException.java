package com.orange.fintech.common.exception;

public class RelatedTransactionNotFoundException extends Exception {
    public RelatedTransactionNotFoundException() {
        System.err.println("업로드한 영수증에 해당하는 결제 정보를 Transaction 테이블에서 찾을 수 없습니다.");
    }
}
