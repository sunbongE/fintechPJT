package com.orange.fintech.auth.service;

import com.orange.fintech.common.BaseResponseBody;
import com.orange.fintech.jwt.JWTUtil;
import com.orange.fintech.member.entity.Member;
import com.orange.fintech.member.repository.MemberRepository;
import com.orange.fintech.redis.service.RedisService;
import java.util.Map;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpHeaders;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Slf4j
@Transactional
@RequiredArgsConstructor
@Service("joinService")
public class JoinServiceImpl implements JoinService {

    @Autowired private final MemberRepository memberRepository;
    //    private final BCryptPasswordEncoder bCryptPasswordEncoder;

    @Autowired private final RedisService redisService;

    @Autowired private final JWTUtil jWTUtil;

    // TODO: 로깅 삭제
    public ResponseEntity<?> joinProcess(Map<String, Object> map) {
        String id = String.valueOf(map.get("id"));
        log.info("id: {}", id);

        Map<String, Object> properties = (Map<String, Object>) map.get("properties");
        log.info("properties: {}", properties);
        String profileImageUrl = (String) properties.get("profile_image");
        log.info("profileImageUrl: {}", profileImageUrl);

        String thumbnailImageUrl = (String) properties.get("thumbnail_image");
        log.info("thumbnailImageUrl: {}", thumbnailImageUrl);

        Map<String, Object> kakaoAccount = (Map<String, Object>) map.get("kakao_account");
        log.info("kakaoAccount: {}", kakaoAccount);

        String name = (String) kakaoAccount.get("name");
        log.info("name: {}", name);

        String email = (String) kakaoAccount.get("email");
        log.info("email: {}", email);

        try {
            // 이미 존재하는 회원이 있는 경우 토큰만 발급 (회원가입 진행 X)
            if (!memberRepository.existsByKakaoId(id)) {

                Member member = new Member();

                member.setKakaoId(id);
                member.setEmail(email);
                member.setName(name);
                // FIXME: Amazon S3로 프로필 이미지, 프로필 썸네일 이미지 업로드
                member.setProfileImage(profileImageUrl);
                member.setThumbnailImage(thumbnailImageUrl);

                memberRepository.save(member);
            }

            // 엑세스 토큰
            String accessToken =
                    jWTUtil.createAccessToken(
                            name, email, id, Long.valueOf(1000 * 60 * 60 * 24)); // 1일 후 토큰 만료

            // 리프레시 토큰
            String refreshToken =
                    jWTUtil.createRefreshToken(
                            name, email, id, Long.valueOf(1000 * 60 * 60 * 24 * 90)); // 3개월 후 토큰 만료

            redisService.save(id, refreshToken);

            HttpHeaders responseHeaders = new HttpHeaders();
            responseHeaders.set("Authorization", "Bearer " + accessToken);

            return ResponseEntity.ok()
                    .headers(responseHeaders)
                    .body(BaseResponseBody.of(200, "정상 가입"));
            //            return ResponseEntity.ok(BaseResponseBody.of(200, accessToken));
        } catch (Exception e) {
            log.info(e.getMessage());
            return ResponseEntity.internalServerError()
                    .body(BaseResponseBody.of(500, "Server Error"));
        }
    }
}
