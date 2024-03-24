package com.orange.fintech.member.entity;

import com.fasterxml.jackson.annotation.JsonIgnore;
import jakarta.persistence.*;
import jakarta.persistence.Id;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import org.hibernate.annotations.OnDelete;
import org.hibernate.annotations.OnDeleteAction;

@Entity
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Table(name = "profile_image")
// 앱에서 프로필 이미지 수정을 했을 때 레코드 생성 (Amazon S3에 파일 업로드)
public class ProfileImage {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int profileImageId;

    @JsonIgnore
    @OneToOne(optional = true)
    @JoinColumn(name = "kakao_id")
    @OnDelete(action = OnDeleteAction.CASCADE)
    private Member member;

    private String profileImagePath; // Amazon S3의 파일 경로

    private String thumbnailImagePath; // Amazon S3의 파일 경로
}
