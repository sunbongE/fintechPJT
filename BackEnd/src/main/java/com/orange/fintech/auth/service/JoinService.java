package com.orange.fintech.auth.service;

import com.orange.fintech.auth.dto.JoinDto;
import com.orange.fintech.member.entity.Member;
import com.orange.fintech.member.repository.MemberRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@RequiredArgsConstructor
@Transactional
public class JoinService {

    private final MemberRepository memberRepository;
    //    private final BCryptPasswordEncoder bCryptPasswordEncoder;

    public boolean joinProcess(JoinDto dto) {
        String email = dto.getEmail();
        //        String name = dto.getName();
        //        String profileImage = dto.getProfileImage();
        // 비밀번호 암호화.
        String password = dto.getPassword();
        //        dto.setPassword(bCryptPasswordEncoder.encode(password));

        Boolean isExist = memberRepository.existsByKakaoId(email);

        if (isExist) { // 이미 회원가입 한 이메일인 경우.
            return false;
        }

        Member data = new Member(dto);
        memberRepository.save(data);

        return true;
    }
}
