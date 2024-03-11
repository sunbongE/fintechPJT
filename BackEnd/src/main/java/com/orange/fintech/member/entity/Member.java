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
public class Member {

    @Id
    @Column(unique = true)
    private String email;

    private String name;
    private String profileImage; // 프로필 이미지 경로 + 이름.???? 아직 모름
    private String password;

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
