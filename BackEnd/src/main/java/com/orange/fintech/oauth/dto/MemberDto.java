package com.orange.fintech.oauth.dto;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class MemberDto {
    private String role;
    private String email;
    private String name;
    private String username;
}
