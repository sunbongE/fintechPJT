package com.orange.fintech.member.entity;

import com.orange.fintech.auth.dto.JoinDto;
import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;
import org.hibernate.annotations.ColumnDefault;
import org.hibernate.annotations.DynamicInsert;

@Entity
@Getter
@Setter
@DynamicInsert
@Table(name = "member")
public class Member {

    @Id private String email; // 회원 검색에 사용.

    private String name; // 회원명

    private String profileImage; // 프로필 이미지 경로 + 이름.???? 아직 모름

    private String pin;

    private String userKey; // ssafy_Bank 서비스를 이용하는데 사용될 키.

    private String username; // 실습용

    private String password; // 삭제 예정.

    @Enumerated(EnumType.STRING)
    @ColumnDefault("'ROLE_USER'")
    private Roles role;

    public Member() {}

    public Member(JoinDto joinDto) {
        this.email = joinDto.getEmail();
        this.name = joinDto.getName();
        this.profileImage = joinDto.getProfileImage();
        this.password = joinDto.getPassword();
    }

    @Override
    public String toString() {
        return "Member{"
                + "email='"
                + email
                + '\''
                + ", name='"
                + name
                + '\''
                + ", profileImage='"
                + profileImage
                + '\''
                + ", password='"
                + password
                + '\''
                + ", role="
                + role
                + '}';
    }
}
