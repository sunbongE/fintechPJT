 package com.orange.fintech.oauth.dto;

 import lombok.Getter;
 import lombok.Setter;

 /*
 그룹원 초대 응답 DTO
  */
 @Getter
 @Setter
 public class MemberSearchResponseDto {
     private String kakaoId;
     private String email;              //회원 검색에 사용.
     private String name;               //회원명
     private String profileImage;       //프로필 이미지 경로 + 이름.???? 아직 모름
     private String thumbnailImage;     //프로필 이미지 경로 + 이름.???? 아직 모름
 }
