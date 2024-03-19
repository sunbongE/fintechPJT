package com.orange.fintech.jwt;

import io.jsonwebtoken.Jwts;
import java.nio.charset.StandardCharsets;
import java.util.Date;
import javax.crypto.SecretKey;
import javax.crypto.spec.SecretKeySpec;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

@Component
public class JWTUtil {

    private SecretKey secretKey;

    public JWTUtil(@Value("${secret-key}") String secret) {
        secretKey =
                new SecretKeySpec(
                        secret.getBytes(StandardCharsets.UTF_8),
                        Jwts.SIG.HS256.key().build().getAlgorithm());
    }

    /**
     * 토큰에서 카카오 아이디(식별자)를 추출하여 리턴한다.
     *
     * @param token
     * @return
     */
    // TODO: 테스트 필요
    public String getKakaoId(String token) {
        return Jwts.parser()
                .verifyWith(secretKey)
                .build()
                .parseSignedClaims(token)
                .getPayload()
                .get("kakaoId", String.class);
    }

    /**
     * 토큰에서 이메일(식별자) 추출하여 리턴한다.
     *
     * @param token
     * @return
     */
    public String getUserEmail(String token) {
        return Jwts.parser()
                .verifyWith(secretKey)
                .build()
                .parseSignedClaims(token)
                .getPayload()
                .get("email", String.class); // username -> email
    }

    /**
     * default : String -> Enum<Roles>으로 변경함.
     *
     * @param token
     * @return
     */
    public String getRole(String token) {
        return Jwts.parser()
                .verifyWith(secretKey)
                .build()
                .parseSignedClaims(token)
                .getPayload()
                .get("role", String.class);
    }

    public Boolean isExpired(String token) {
        System.out.println("token ====> " + token);
        return Jwts.parser()
                .verifyWith(secretKey)
                .build()
                .parseSignedClaims(token)
                .getPayload()
                .getExpiration()
                .before(new Date());
    }

    public String createAccessToken(String name, String email, String kakaoId, Long expiredMs) {

        return Jwts.builder()
                .claim("name", name)
                // TODO: Parameter email 지우기
                .claim("kakaoId", kakaoId)
                //                .subject(kakaoId)
                .issuedAt(new Date(System.currentTimeMillis()))
                .expiration(new Date(System.currentTimeMillis() + expiredMs))
                .signWith(secretKey)
                .compact();
    }

    public String createRefreshToken(String name, String email, String kakaoId, Long expiredMs) {

        return Jwts.builder()
                .claim("name", name)
                .claim("email", email)
                .claim("kakaoId", kakaoId)
                //                .subject(kakaoId)
                .issuedAt(new Date(System.currentTimeMillis()))
                .expiration(new Date(System.currentTimeMillis() + expiredMs))
                .signWith(secretKey)
                .compact();
    }
}
