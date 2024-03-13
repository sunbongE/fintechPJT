//package com.orange.fintech.oauth.dto;
//
//import java.util.Map;
//import lombok.extern.slf4j.Slf4j;
//
//@Slf4j
//public class KakaoResponse implements OAuth2Response {
//
//    private final Map<String, Object> attribute;
//    private final Map<String, Object> properties;
//    private final Map<String, Object> kakao_account;
//
//    public KakaoResponse(Map<String, Object> attribute) {
//        log.info("카카오에서 받은 데이터 형식 : {}", attribute);
//        this.attribute = (Map<String, Object>) attribute;
//        this.properties = (Map<String, Object>) attribute.get("properties");
//        this.kakao_account = (Map<String, Object>) attribute.get("kakao_account");
//        log.info("카카오에서 받은 데이터 형식(properties) : {}", properties);
//        log.info("카카오에서 받은 데이터 형식(kakao_account) : {}", kakao_account);
//    }
//
//    @Override
//    public String getProvider() {
//        return "kakao";
//    }
//
//    @Override
//    public String getProviderId() {
//        return attribute.get("id").toString();
//    }
//
//    @Override
//    public String getEmail() {
//
//        return kakao_account.get("email").toString();
//    }
//
//    @Override
//    public String getprofileImage() {
//
//        return properties.get("profile_image").toString();
//    }
//
//    @Override
//    public String getName() {
//        return kakao_account.get("name").toString();
//    }
//}
