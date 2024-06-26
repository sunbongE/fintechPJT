package com.orange.fintech.member.service;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.orange.fintech.account.entity.Account;
import com.orange.fintech.common.exception.BigFileException;
import com.orange.fintech.common.exception.EmptyFileException;
import com.orange.fintech.common.exception.NotValidExtensionException;
import com.orange.fintech.member.dto.PrimaryAccountRes;
import com.orange.fintech.member.entity.Member;
import com.orange.fintech.oauth.dto.MemberSearchResponseDto;
import java.io.IOException;
import java.util.List;
import org.springframework.http.ResponseEntity;
import org.springframework.web.multipart.MultipartFile;

public interface MemberService {
    MemberSearchResponseDto findByEmail(String email);

    List<Account> findAccountsByKakaoId(Member member);

    PrimaryAccountRes findMyPrimaryAccount(Member member);

    Member findByKakaoId(String id);

    boolean logout(String accessToken, String fcmToken);

    boolean updatePin(String kakaoId, String pin);

    boolean verifyPin(String kakaoId, String pin);

    boolean deleteUser(String kakaoId);

    boolean updateProfileImage(MultipartFile multipartFile, Member member)
            throws IOException, EmptyFileException, BigFileException, NotValidExtensionException;

    String getSelfProfileURL(String kakaoId);

    ResponseEntity<?> searchMember(String email) throws JsonProcessingException;

    void saveFcmToken(String kakaoId, String fcmTokenString);
}
