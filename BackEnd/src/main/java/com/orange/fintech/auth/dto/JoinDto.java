package com.orange.fintech.auth.dto;

import lombok.Getter;
import lombok.Setter;

@Setter
@Getter
public class JoinDto {

    private String email;
    private String name;
    private String profileImage; // 프로필 이미지 경로 + 이름.???? 아직 모름
    private String password;
}
