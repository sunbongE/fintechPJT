package com.orange.fintech.util;

import org.springframework.stereotype.Component;

import java.time.LocalDate;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;

@Component
public class AccountUtil {
    // LocalDate를 yyyyMMdd 문자열로 변환하는 함수
    public static String localDateToString(LocalDate date) {
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyyMMdd");
        return date.format(formatter);
    }

    // LocalTime을 HHmmss 문자열로 변환하는 함수
    public static String localTimeToString(LocalTime time) {
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("HHmmss");
        return time.format(formatter);
    }
}
