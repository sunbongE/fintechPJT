package com.orange.fintech.util;

import java.time.LocalDate;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;

public class AccountDateTimeUtil {
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

    public static LocalDate StringToLocalDate(String stringDate) {
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyyMMdd");
        LocalDate date = LocalDate.parse(stringDate, formatter);
        return date;
    }

    public static LocalTime StringToLocalTime(String stringTime) {
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("HHmmss");
        LocalTime date = LocalTime.parse(stringTime, formatter);
        return date;
    }
}
