// package com.orange.fintech.jwt;
//
//// import com.orange.fintech.oauth.dto.CustomOAuth2User;
//// import com.orange.fintech.oauth.dto.MemberDto;
// import static org.springframework.http.HttpHeaders.AUTHORIZATION;
//
// import com.orange.fintech.auth.dto.CustomUserDetails;
// import com.orange.fintech.auth.service.CustomUserDetailsService;
// import com.orange.fintech.member.entity.Member;
// import com.orange.fintech.member.repository.MemberRepository;
// import com.orange.fintech.redis.service.RedisService;
// import jakarta.servlet.FilterChain;
// import jakarta.servlet.ServletException;
// import jakarta.servlet.http.HttpServletRequest;
// import jakarta.servlet.http.HttpServletResponse;
// import java.io.IOException;
// import lombok.RequiredArgsConstructor;
// import lombok.extern.slf4j.Slf4j;
// import org.springframework.beans.factory.annotation.Autowired;
// import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
// import org.springframework.security.core.Authentication;
// import org.springframework.security.core.context.SecurityContextHolder;
// import org.springframework.stereotype.Component;
// import org.springframework.web.filter.OncePerRequestFilter;
//
// @Slf4j
// @Component
// @RequiredArgsConstructor
// public class JWTFilter extends OncePerRequestFilter {
//    @Autowired private final JWTUtil jwtUtil;
//
//    //    @Autowired
//    //    CustomUserDetails customUserDetails;
//
//    @Autowired CustomUserDetailsService customUserDetailsService;
//
//    @Autowired private final MemberRepository memberRepository;
//
//    @Autowired RedisService redisService;
//
//    @Override
//    protected void doFilterInternal(
//            HttpServletRequest request, HttpServletResponse response, FilterChain filterChain)
//            throws ServletException, IOException {
//        String accessToken = request.getHeader(AUTHORIZATION); // accessToken을 가져오기 위해 Header를 불러옴
//
//        if (accessToken == null
//                || !accessToken.startsWith("Bearer ")) { // header에 값이 있고, Bearer로 시작하면
//            filterChain.doFilter(request, response); // 헤더에 토큰이 없으면 다음 필터로 request, response를 넘겨줌
//
//            // 조건이 해당되면 메소드 종료 (필수)
//            return;
//        }
//
//        accessToken = accessToken.substring("Bearer ".length());
//
//        // 1. 액세스 토큰이 만료
//        if (jwtUtil.isExpired(accessToken)) {
//            filterChain.doFilter(request, response);
//
//            // 조건이 해당되면 메소드 종료 (필수)
//            return;
//        }
//
//        // 2. 액세스 토큰이 유효 -> 토큰으로부터 member 로드
//        String id = jwtUtil.getKakaoId(accessToken);
//        Member member = memberRepository.findByKakaoId(id);
//
//        // UserDetails에 회원 정보 객체 담기
//        CustomUserDetails customUserDetails = new CustomUserDetails(member);
//
//        // 스프링 시큐리티 인증 토큰 생성
//        Authentication authToken =
//                new UsernamePasswordAuthenticationToken(
//                        customUserDetails, null, customUserDetails.getAuthorities());
//
//        // 세션에 사용자 등록
//        SecurityContextHolder.getContext().setAuthentication(authToken);
//
//        /*
//        //1. 액세스 토큰이 유효
//        if (!jwtUtil.isExpired(accessToken)) {
//            //UserDetails에 회원 정보 객체 담기
//            CustomUserDetails customUserDetails = new CustomUserDetails(member);
//            //스프링 시큐리티 인증 토큰 생성
//            Authentication authToken = new UsernamePasswordAuthenticationToken(customUserDetails,
// null, customUserDetails.getAuthorities());
//            //세션에 사용자 등록
//            SecurityContextHolder.getContext().setAuthentication(authToken);
//        }
//        //2. 액세스 토큰이 만료
//        else {
//            //2-1. 액세스 토큰 재발급
//            //새로운 액세스 토큰 발급
//            String newAccessToken = jwtUtil.createAccessToken(
//                    member.getName(),
//                    email,
//                    member.getKakaoId(),
//                    Long.valueOf(1000 * 60 * 60 * 24)); // 1일 후 토큰 만료
//
//            //2-2. 리프레시 토큰이 만료된 경우
//            if(!redisService.hasKey(id)) {
//                String newRefreshToken = jwtUtil.createRefreshToken(
//                        member.getName(),
//                        email,
//                        member.getKakaoId(),
//                        Long.valueOf(1000 * 60 * 60 * 24 * 90)); // 3개월 후 토큰 만료
//            }
//
//            response.addHeader("Authorization", "Bearer " + newAccessToken);
//
//            //UserDetails에 회원 정보 객체 담기
//            CustomUserDetails customUserDetails = new CustomUserDetails(member);
//
//            //스프링 시큐리티 인증 토큰 생성
//            Authentication authToken = new UsernamePasswordAuthenticationToken(customUserDetails,
// null, customUserDetails.getAuthorities());
//
//            //세션에 사용자 등록
//            SecurityContextHolder.getContext().setAuthentication(authToken);
//        }
//        */
//        filterChain.doFilter(request, response);
//
//        // 조건이 해당되면 메소드 종료 (필수)
//        return;
//    }
//
//    /*
//    // cookie들을 불러온 뒤 Authorization Key에 담긴 쿠키를 찾음
//    String authorization = null;
//    Cookie[] cookies = request.getCookies();
//    if (cookies == null || cookies.length == 0) {
//        filterChain.doFilter(request, response);
//        return;
//    }
//    System.out.println(Arrays.toString(cookies));
//    for (Cookie cookie : cookies) {
//
//        ////            System.out.println(cookie.getName());
//        if (cookie.getName().equals("Authorization")) {
//
//            authorization = cookie.getValue();
//        }
//    }
//
//    // Authorization 헤더 검증
//    if (authorization == null) {
//
//        //            System.out.println("token null");
//        filterChain.doFilter(request, response);
//
//        // 조건이 해당되면 메소드 종료 (필수)
//        return;
//    }
//
//    // 토큰
//    String token = authorization;
//
//    // 토큰 소멸 시간 검증
//    if (jwtUtil.isExpired(token)) {
//
//        //            System.out.println("token expired");
//        filterChain.doFilter(request, response);
//
//        // 조건이 해당되면 메소드 종료 (필수)
//        return;
//    }
//
//    // 토큰에서 username과 role 획득
//    String email = jwtUtil.getUserEmail(token);
//    String role = jwtUtil.getRole(token);
//
//    // MemberDto 생성하여 값 set
//    //        MemberDto memberDto = new MemberDto();
//    //        memberDto.setEmail(email);
//    //        memberDto.setRole(role);
//    //
//    //        // UserDetails에 회원 정보 객체 담기
//    //        CustomOAuth2User customOAuth2User = new CustomOAuth2User(memberDto);
//    //
//    //        // 스프링 시큐리티 인증 토큰 생성
//    //        Authentication authToken =
//    //                new UsernamePasswordAuthenticationToken(
//    //                        customOAuth2User, null, customOAuth2User.getAuthorities());
//    //        // 세션에 사용자 등록
//    //        SecurityContextHolder.getContext().setAuthentication(authToken);
//
//    filterChain.doFilter(request, response);
//    */
//    //    }
// }
