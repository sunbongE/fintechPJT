package com.orange.fintech.auth.service;

import com.orange.fintech.auth.dto.JoinDto;
import com.orange.fintech.common.BaseResponseBody;
import com.orange.fintech.jwt.JWTUtil;
import com.orange.fintech.member.entity.Member;
import com.orange.fintech.member.repository.MemberRepository;
import com.orange.fintech.redis.service.RedisService;
import java.time.Instant;
import java.time.temporal.ChronoUnit;
import java.util.Date;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpHeaders;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import static com.orange.fintech.member.entity.Roles.ROLE_USER;

@Slf4j
@Transactional
@RequiredArgsConstructor
@Service("joinService")
public class JoinServiceImpl implements JoinService {

    @Autowired private final MemberRepository memberRepository;
    @Autowired private final RedisService redisService;
    @Autowired private final JWTUtil jWTUtil;

    public ResponseEntity<?> joinProcess(JoinDto joinDto) {
        String id = joinDto.getId();

        JoinDto.Properties properties = joinDto.getProperties();
        String profileImageUrl = properties.getProfileImage();
        String thumbnailImageUrl = properties.getThumbnailImage();

        JoinDto.KakaoAccount kakaoAccount = joinDto.getKakaoAccount();
        String name = kakaoAccount.getName();
        String email = kakaoAccount.getEmail();

        Member member = null;
        HttpHeaders responseHeaders = new HttpHeaders();
        boolean doesFCMTokenExists = joinDto.getFcmToken() == null ? false : true;

        try {
            member = memberRepository.findByKakaoId(id);

            // 이미 존재하는 회원이 있는 경우 액세스 토큰 발급, FCM 토큰 저장 (회원가입 진행 X)
            if (member == null) {
                member = new Member();
            }

            member.setKakaoId(id);
            member.setEmail(email);
            member.setName(name);
            member.setProfileImage(profileImageUrl);
            member.setThumbnailImage(thumbnailImageUrl);
            member.setRole(ROLE_USER);

            if (joinDto.getFcmToken() != null) {
                member.setFcmToken(joinDto.getFcmToken());
            }

            member = new Member();

            member.setKakaoId(id);
            member.setEmail(email);
            member.setName(name);
            member.setProfileImage(profileImageUrl);
            member.setThumbnailImage(thumbnailImageUrl);

            member.setFcmToken(joinDto.getFcmToken());
            memberRepository.save(member);

            Date expiredDate = Date.from(Instant.now().plus(30, ChronoUnit.DAYS)); // 30일
            // 엑세스 토큰
            String accessToken =
                    jWTUtil.createAccessToken(
                            name,
                            id,
                            Date.from(Instant.now().plus(30, ChronoUnit.DAYS))); // 1개월 후 토큰 만료

            // 리프레시 토큰
            String refreshToken =
                    jWTUtil.createRefreshToken(
                            name,
                            id,
                            Date.from(Instant.now().plus(90, ChronoUnit.DAYS))); // 3개월 후 토큰 만료

            redisService.save(id, refreshToken);

            responseHeaders.set("Authorization", "Bearer " + accessToken);

            if (doesFCMTokenExists) {
                return ResponseEntity.ok()
                        .headers(responseHeaders)
                        .body(BaseResponseBody.of(200, "정상 가입"));
            } else {
                return ResponseEntity.ok()
                        .headers(responseHeaders)
                        .body(BaseResponseBody.of(200, "FCM 토큰 없이 가입"));
            }
        } catch (Exception e) {
            log.info(e.getMessage());
            return ResponseEntity.internalServerError()
                    .body(BaseResponseBody.of(500, "Server Error"));
        }
    }
}
