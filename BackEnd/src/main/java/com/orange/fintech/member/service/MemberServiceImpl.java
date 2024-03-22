package com.orange.fintech.member.service;

import com.orange.fintech.jwt.JWTUtil;
import com.orange.fintech.member.entity.Account;
import com.orange.fintech.member.entity.Member;
import com.orange.fintech.member.repository.AccountRepository;
import com.orange.fintech.member.repository.MemberRepository;
import com.orange.fintech.oauth.dto.MemberSearchResponseDto;
import com.orange.fintech.redis.service.RedisService;
import java.util.List;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

@Slf4j
@Service
public class MemberServiceImpl implements MemberService {
    @Autowired MemberRepository memberRepository;

    @Autowired AccountRepository accountRepository;

    @Autowired RedisService redisService;

    @Autowired JWTUtil jWTUtil;

    @Autowired PasswordEncoder passwordEncoder;

    // 그룹원 검색 응답
    @Override
    public MemberSearchResponseDto findByEmail(String email) {
        Member member = memberRepository.findByEmail(email);

        MemberSearchResponseDto memberSearchResponseDto = new MemberSearchResponseDto();
        memberSearchResponseDto.setKakaoId(member.getKakaoId());
        memberSearchResponseDto.setEmail(member.getEmail());
        memberSearchResponseDto.setName(member.getName());
        memberSearchResponseDto.setProfileImage(member.getProfileImage());
        memberSearchResponseDto.setThumbnailImage(member.getThumbnailImage());

        return memberSearchResponseDto;
    }

    @Override
    public List<Account> findAccountsByKakaoId(Member member) {
        List<Account> accountList = accountRepository.findByMember(member);

        return accountList;
    }

    @Override
    public Member findByKakaoId(String id) {
        return memberRepository.findByKakaoId(id);
    }

    @Override
    public boolean logout(String accessToken) {
        String id = jWTUtil.getKakaoId(accessToken);

        return redisService.delete(id);
    }

    @Override
    public boolean updatePin(String kakaoId, String pin) {
        Member member = findByKakaoId(kakaoId);
        member.setPin(passwordEncoder.encode(pin));

        try {
            memberRepository.save(member);
        } catch (Exception e) {
            e.printStackTrace();

            return false;
        }

        return true;
    }

    @Override
    public boolean verifyPin(String kakaoId, String pin) {
        Member member = findByKakaoId(kakaoId);

        return passwordEncoder.matches(pin, member.getPin());
    }

    @Override
    public boolean deleteUser(String kakaoId) {
        try {
            // 1. Member 테이블에서 레코드 삭제
            memberRepository.deleteById(kakaoId);

            // 2. Redis에서 Refresh token 삭제
            redisService.delete(kakaoId);

            return true;
        } catch (Exception e) {
            e.printStackTrace();

            return false;
        }
    }
}
