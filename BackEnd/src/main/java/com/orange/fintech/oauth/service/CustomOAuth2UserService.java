package com.orange.fintech.oauth.service;

import com.orange.fintech.member.entity.Member;
import com.orange.fintech.member.entity.Roles;
import com.orange.fintech.member.repository.MemberRepository;
import com.orange.fintech.oauth.dto.CustomOAuth2User;
import com.orange.fintech.oauth.dto.KakaoResponse;
import com.orange.fintech.oauth.dto.MemberDto;
import com.orange.fintech.oauth.dto.OAuth2Response;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.oauth2.client.userinfo.DefaultOAuth2UserService;
import org.springframework.security.oauth2.client.userinfo.OAuth2UserRequest;
import org.springframework.security.oauth2.core.OAuth2AuthenticationException;
import org.springframework.security.oauth2.core.user.OAuth2User;
import org.springframework.stereotype.Service;

@Slf4j
@Service
@RequiredArgsConstructor
public class CustomOAuth2UserService extends DefaultOAuth2UserService {

    private final MemberRepository memberRepository;

    @Override
    public OAuth2User loadUser(OAuth2UserRequest userRequest) throws OAuth2AuthenticationException {

        OAuth2User oAuth2User = super.loadUser(userRequest);
        log.info("oAuth2User : {}", oAuth2User);

        String registrationId = userRequest.getClientRegistration().getRegistrationId();
        OAuth2Response oAuth2Response = null;
        if (registrationId.equals("kakao")) {
            oAuth2Response = new KakaoResponse(oAuth2User.getAttributes());
        } else {
            return null;
        }

        // 리소스 서버에서 발급 받은 정보로 사용자를 특정할 아이디값을 만듬
        String username = oAuth2Response.getProvider() + " " + oAuth2Response.getProviderId();
        // 존재하는 회원인지 확인.
        Member existData = memberRepository.findByUsername(username);

        if (existData == null) { // 신규회원인경우 회원가입진행 .
            Member member = new Member();
            member.setUsername(username);
            member.setEmail(oAuth2Response.getEmail());
            member.setName(oAuth2Response.getName());
            member.setRole(Roles.ROLE_USER);

            memberRepository.save(member);

            MemberDto memberDto = new MemberDto();
            memberDto.setUsername(username);
            memberDto.setEmail(oAuth2Response.getEmail());
            memberDto.setName(oAuth2Response.getName());
            memberDto.setRole(String.valueOf(Roles.ROLE_USER));

            return new CustomOAuth2User(memberDto);
        } else { // 기존 회원
            existData.setEmail(oAuth2Response.getEmail());
            existData.setName(oAuth2Response.getName());
            // 변경내용 수정.
            memberRepository.save(existData);
            MemberDto memberDto = new MemberDto();
            memberDto.setUsername(existData.getUsername());
            memberDto.setEmail(oAuth2Response.getEmail());
            memberDto.setName(oAuth2Response.getName());
            memberDto.setRole(String.valueOf(existData.getRole()));
            return new CustomOAuth2User(memberDto);
        }
    }
}
