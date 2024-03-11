package com.orange.fintech.jwt;

import com.orange.fintech.auth.dto.CustomUserDetails;
import com.orange.fintech.member.entity.Member;
import com.orange.fintech.member.entity.Roles;
import com.orange.fintech.oauth.dto.CustomOAuth2User;
import com.orange.fintech.oauth.dto.MemberDto;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.filter.OncePerRequestFilter;

@Slf4j
@RequiredArgsConstructor
public class JWTFilter extends OncePerRequestFilter {

    private final JWTUtil jwtUtil;

    @Override
    protected void doFilterInternal(
            HttpServletRequest request, HttpServletResponse response, FilterChain filterChain)
            throws ServletException, IOException {

        // cookie들을 불러온 뒤 Authorization Key에 담긴 쿠키를 찾음
        String authorization = null;
        Cookie[] cookies = request.getCookies();
        for (Cookie cookie : cookies) {

            ////            System.out.println(cookie.getName());
            if (cookie.getName().equals("Authorization")) {

                authorization = cookie.getValue();
            }
        }

        if (authorization == null) {
            normalLogin(request, response, filterChain);

        } else {
            socialLogin(request, response, filterChain, authorization);
        }
    }

    private void socialLogin(
            HttpServletRequest request,
            HttpServletResponse response,
            FilterChain filterChain,
            String authorization)
            throws ServletException, IOException {
        // Authorization 헤더 검증
        if (authorization == null) {

            //            System.out.println("token null");
            filterChain.doFilter(request, response);

            // 조건이 해당되면 메소드 종료 (필수)
            return;
        }

        // 토큰
        String token = authorization;

        // 토큰 소멸 시간 검증
        if (jwtUtil.isExpired(token)) {

            //            System.out.println("token expired");
            filterChain.doFilter(request, response);

            // 조건이 해당되면 메소드 종료 (필수)
            return;
        }

        // 토큰에서 username과 role 획득
        String email = jwtUtil.getUserEmail(token);
        String role = jwtUtil.getRole(token);

        // MemberDto 생성하여 값 set
        MemberDto memberDto = new MemberDto();
        memberDto.setEmail(email);
        memberDto.setRole(role);

        // UserDetails에 회원 정보 객체 담기
        CustomOAuth2User customOAuth2User = new CustomOAuth2User(memberDto);

        // 스프링 시큐리티 인증 토큰 생성
        Authentication authToken =
                new UsernamePasswordAuthenticationToken(
                        customOAuth2User, null, customOAuth2User.getAuthorities());
        // 세션에 사용자 등록
        SecurityContextHolder.getContext().setAuthentication(authToken);

        filterChain.doFilter(request, response);
    }

    private void normalLogin(
            HttpServletRequest request, HttpServletResponse response, FilterChain filterChain)
            throws ServletException, IOException {
        // request에서 Authorization 헤더를 찾음
        String authorization = request.getHeader("Authorization");

        // Authorization 헤더 검증
        if (authorization == null || !authorization.startsWith("Bearer ")) {

            log.info("token null");

            // 현재필터를 종료하고 다음 필터로 넘겨준다.
            filterChain.doFilter(request, response);

            // 조건이 해당되면 메소드 종료 (필수)
            return;
        }
        //        log.info("authorization now");
        // Bearer 부분 제거 후 순수 토큰만 획득
        String token = authorization.split(" ")[1];

        // 토큰 소멸 시간 검증
        if (jwtUtil.isExpired(token)) {

            log.info("token 만료됨");
            filterChain.doFilter(request, response);

            // 조건이 해당되면 메소드 종료 (필수)
            return;
        }

        // 토큰에서 username과 role 획득
        String email = jwtUtil.getUserEmail(token);
        String role = jwtUtil.getRole(token);

        // userEntity를 생성하여 값 set
        Member member = new Member();
        member.setEmail(email);
        member.setPassword("temppassword");
        member.setRole(Roles.valueOf(role));

        // UserDetails에 회원 정보 객체 담기
        CustomUserDetails customUserDetails = new CustomUserDetails(member);

        // 스프링 시큐리티 인증 토큰 생성
        Authentication authToken =
                new UsernamePasswordAuthenticationToken(
                        customUserDetails, null, customUserDetails.getAuthorities());

        // 세션에 사용자 등록
        SecurityContextHolder.getContext().setAuthentication(authToken);

        filterChain.doFilter(request, response);
    }
}
