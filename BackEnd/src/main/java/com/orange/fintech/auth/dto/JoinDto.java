package com.orange.fintech.auth.dto;

import com.fasterxml.jackson.databind.PropertyNamingStrategies;
import com.fasterxml.jackson.databind.annotation.JsonNaming;
import lombok.Getter;
import lombok.RequiredArgsConstructor;
import lombok.Setter;

@Setter
@Getter
@RequiredArgsConstructor
@JsonNaming(PropertyNamingStrategies.SnakeCaseStrategy.class) // Camel -> Snake case 변환
public class JoinDto {
    private String id;
    private Properties properties;
    private KakaoAccount kakaoAccount;
    private String connectedAt;

    @Override
    public String toString() {
        return "JoinDto{"
                + "id='"
                + id
                + '\''
                + ", properties="
                + properties
                + ", kakaoAccount="
                + kakaoAccount
                + ", connectedAt='"
                + connectedAt
                + '\''
                + '}';
    }

    @Setter
    @Getter
    @RequiredArgsConstructor
    @JsonNaming(PropertyNamingStrategies.SnakeCaseStrategy.class)
    public class Properties {
        private String profileImage;
        private String thumbnailImage;

        @Override
        public String toString() {
            return "Properties{"
                    + "profileImage='"
                    + profileImage
                    + '\''
                    + ", thumbnailImage='"
                    + thumbnailImage
                    + '\''
                    + '}';
        }
    }

    @Setter
    @Getter
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

        @Override
        public String toString() {
            return "KakaoAccount{"
                    + "profileImageNeedsAgreement="
                    + profileImageNeedsAgreement
                    + ", profile="
                    + profile
                    + ", nameNeedsAgreement="
                    + nameNeedsAgreement
                    + ", name='"
                    + name
                    + '\''
                    + ", emailNeedsAgreement="
                    + emailNeedsAgreement
                    + ", isEmailValid="
                    + isEmailValid
                    + ", isEmailVerified="
                    + isEmailVerified
                    + ", email='"
                    + email
                    + '\''
                    + '}';
        }

        @Setter
        @Getter
        @RequiredArgsConstructor
        @JsonNaming(PropertyNamingStrategies.SnakeCaseStrategy.class)
        public class Profile {
            private String thumbnailImageUrl;
            private String profileImageUrl;
            private Boolean isDefaultImage;

            @Override
            public String toString() {
                return "Profile{"
                        + "thumbnailImageUrl='"
                        + thumbnailImageUrl
                        + '\''
                        + ", profileImageUrl='"
                        + profileImageUrl
                        + '\''
                        + ", isDefaultImage="
                        + isDefaultImage
                        + '}';
            }
        }
    }
}
