package com.orange.fintech.api.service;

import com.orange.fintech.api.dto.JoinDto;
import com.orange.fintech.api.repository.MemberRepository;
import com.orange.fintech.entity.Member;
import lombok.RequiredArgsConstructor;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@RequiredArgsConstructor
@Transactional
public class JoinService {

    private final MemberRepository memberRepository;
    private final BCryptPasswordEncoder bCryptPasswordEncoder;

    public boolean joinProcess(JoinDto dto){
        String email = dto.getEmail();
//        String name = dto.getName();
//        String profileImage = dto.getProfileImage();
        // 비밀번호 암호화.
        String password = dto.getPassword();
        dto.setPassword(bCryptPasswordEncoder.encode(password));

        Boolean isExist = memberRepository.existsByEmail(email);

        if(isExist){ // 이미 회원가입 한 이메일인 경우.
            return false;
        }

        Member data = new Member(dto);
        memberRepository.save(data);


        return true;
    }

}
