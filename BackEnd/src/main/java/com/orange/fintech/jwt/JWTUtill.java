package com.orange.fintech.jwt;

import com.orange.fintech.member.entity.Roles;
import io.jsonwebtoken.Jwts;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import javax.crypto.SecretKey;
import javax.crypto.spec.SecretKeySpec;
import java.nio.charset.StandardCharsets;

@Component
public class JWTUtill {

    private SecretKey secretKey;

    public JWTUtill(@Value("${secret-key}") String secret){
        secretKey = new SecretKeySpec(secret.getBytes(StandardCharsets.UTF_8), Jwts.SIG.HS256.key().build().getAlgorithm());
    }

    /**
     * 토큰에서 이메일(식별자) 추출하여 리턴한다.
     * @param token
     * @return
     */
    public String getUserEmail(String token){
        return Jwts.parser().verifyWith(secretKey).build().parseSignedClaims(token).getPayload().get("email",String.class);
    }

    /**
     * default : String -> Enum<Roles>으로 변경함.
     * @param token
     * @return
     */
    public Enum<Roles> getRole(String token){
        return Jwts.parser().verifyWith(secretKey).build().parseSignedClaims(token).getPayload().get("role", Roles.class);
    }




}
