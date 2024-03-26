package com.orange.fintech.member.entity;

import com.orange.fintech.account.entity.Account;
import com.orange.fintech.auth.dto.JoinDto;
import jakarta.persistence.*;
import java.util.List;
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

    @Id
    @Column(unique = true)
    private String kakaoId;

    @Column(unique = true)
    private String email; // 회원 검색에 사용.

    private String name; // 회원명

    private String profileImage; // 프로필 이미지 경로 + 이름.???? 아직 모름
    private String thumbnailImage; // 프로필 이미지 경로 + 이름.???? 아직 모름

    private String pin;

    private String fcmToken;

    @Column(unique = true)
    private String userKey; // ssafy_Bank 서비스를 이용하는데 사용될 키.

    @Enumerated(EnumType.STRING)
    @ColumnDefault("'ROLE_USER'")
    private Roles role;

    @OneToMany(mappedBy = "member")
    private List<Account> accounts;

    public Member() {}

    public Member(JoinDto joinDto) {
        this.email = joinDto.getKakaoAccount().getEmail();
        this.name = joinDto.getKakaoAccount().getName();
        this.profileImage = joinDto.getKakaoAccount().getProfile().getProfileImageUrl();
    }

    @Override
    public String toString() {
        return "Member{"
                + "kakaoId='"
                + kakaoId
                + '\''
                + ", email='"
                + email
                + '\''
                + ", name='"
                + name
                + '\''
                + ", profileImage='"
                + profileImage
                + '\''
                + ", thumbnailImage='"
                + thumbnailImage
                + '\''
                + ", pin='"
                + pin
                + '\''
                + ", fcmToken='"
                + fcmToken
                + '\''
                + ", userKey='"
                + userKey
                + '\''
                + ", role="
                + role
                + '}';
    }
}
