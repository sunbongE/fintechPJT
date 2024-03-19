package com.orange.fintech.member.service;

import com.orange.fintech.jwt.JWTUtil;
import com.orange.fintech.member.entity.Account;
import com.orange.fintech.member.entity.Member;
import com.orange.fintech.member.repository.AccountRepository;
import com.orange.fintech.member.repository.MemberRepository;
import com.orange.fintech.oauth.dto.MemberSearchResponseDto;
import com.orange.fintech.redis.service.RedisService;
import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class MemberServiceImpl implements MemberService {
    @Autowired MemberRepository memberRepository;

    @Autowired AccountRepository accountRepository;

    @Autowired RedisService redisService;

    @Autowired JWTUtil jWTUtil;

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
        System.out.println("accessToken");
        System.out.println(accessToken);

        String id = jWTUtil.getKakaoId(accessToken);

        return redisService.delete(id);
    }
}
