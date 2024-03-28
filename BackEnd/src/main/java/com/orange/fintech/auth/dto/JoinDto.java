package com.orange.fintech.auth.dto;

import com.fasterxml.jackson.databind.PropertyNamingStrategies;
import com.fasterxml.jackson.databind.annotation.JsonNaming;
import lombok.Getter;
import lombok.RequiredArgsConstructor;
import lombok.Setter;
import lombok.ToString;

@Setter
@Getter
@ToString
@RequiredArgsConstructor
@JsonNaming(PropertyNamingStrategies.SnakeCaseStrategy.class) // Camel -> Snake case 변환
public class JoinDto {
    private String id;
    private Properties properties;
    private KakaoAccount kakaoAccount;
    private String connectedAt;
    private String fcmToken;

    @Setter
    @Getter
    @ToString
    @RequiredArgsConstructor
    @JsonNaming(PropertyNamingStrategies.SnakeCaseStrategy.class)
    public class Properties {
        private String profileImage;
        private String thumbnailImage;
    }

    @Setter
    @Getter
    @ToString
    @RequiredArgsConstructor
    @JsonNaming(PropertyNamingStrategies.SnakeCaseStrategy.class)
    public class KakaoAccount {
        private Boolean profileImageNeedsAgreement;
        private Profile profile;
        private Boolean nameNeedsAgreement;
        private String name;
        private Boolean emailNeedsAgreement;
        private Boolean isEmailValid;
        private Boolean isEmailVerified;
        private String email;

        @Setter
        @Getter
        @ToString
        @RequiredArgsConstructor
        @JsonNaming(PropertyNamingStrategies.SnakeCaseStrategy.class)
        public class Profile {
            private String thumbnailImageUrl;
            private String profileImageUrl;
            private Boolean isDefaultImage;
        }
    }
}
