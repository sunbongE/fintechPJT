package com.orange.fintech.member.service;

import com.orange.fintech.member.entity.Account;
import com.orange.fintech.member.entity.Member;
import com.orange.fintech.oauth.dto.MemberSearchResponseDto;
import java.util.List;

public interface MemberService {
    MemberSearchResponseDto findByEmail(String email);

    List<Account> findAccountsByKakaoId(Member member);

    Member findByKakaoId(String id);

    boolean logout(String accessToken);

    boolean updatePin(String kakaoId, String pin);

    boolean verifyPin(String kakaoId, String pin);

    boolean deleteUser(String kakaoId);
}
