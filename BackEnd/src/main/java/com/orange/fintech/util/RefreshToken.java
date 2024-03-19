package com.orange.fintech.util;

import org.springframework.data.annotation.Id;
import org.springframework.data.redis.core.RedisHash;

// TODO: TTL 늘리기
// @RedisHash(value = "refreshToken", timeToLive = 60)
// TTL 3개월
@RedisHash(value = "refreshToken", timeToLive = 60 * 60 * 24 * 90)
public class RefreshToken {

    @Id private String refreshToken;
    private String kakaoId;

    public RefreshToken(final String refreshToken, final String kakaoId) {
        this.refreshToken = refreshToken;
        this.kakaoId = kakaoId;
    }

    public String getRefreshToken() {
        return refreshToken;
    }

    public String getKakaoId() {
        return kakaoId;
    }

    @Override
    public String toString() {
        return "RefreshToken{"
                + "refreshToken='"
                + refreshToken
                + '\''
                + ", kakaoId='"
                + kakaoId
                + '\''
                + '}';
    }
}
