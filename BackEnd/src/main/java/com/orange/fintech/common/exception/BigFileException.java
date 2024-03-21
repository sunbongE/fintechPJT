package com.orange.fintech.common.exception;

public class BigFileException extends Exception {
    public BigFileException() {
        System.err.println("파일의 용량이 20MB를 초과합니다.");
    }
}
