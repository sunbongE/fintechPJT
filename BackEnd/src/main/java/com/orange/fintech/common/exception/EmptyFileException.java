package com.orange.fintech.common.exception;

public class EmptyFileException extends Exception {
    public EmptyFileException() {
        System.err.println("파일이 비어있습니다.");
    }
}
