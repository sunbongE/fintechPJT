package com.orange.fintech.oauth.dto;

import java.util.Map;
import lombok.extern.slf4j.Slf4j;

@Slf4j
public class KakaoResponse implements OAuth2Response {

    private final Map<String, Object> attribute;

    public KakaoResponse(Map<String, Object> attribute) {
        log.info("카카오에서 받은 데이터 형식 : {}", attribute);
        this.attribute = (Map<String, Object>) attribute;
    }

    @Override
    public String getProvider() {
        return "kakao";
    }

    @Override
    public String getProviderId() {
        log.info("attribute.get(\"id\").toString() : {}", attribute.get("id").toString());
        return attribute.get("id").toString();
    }

    @Override
    public String getEmail() {

//        return attribute.get("kakao_account").get("account_email").toString();
        return "";
    }

    @Override
    public String getprofileImage() {
        return attribute.get("profile_image").toString();
    }

    @Override
    public String getName() {
        return attribute.get("name").toString();
    }
}
