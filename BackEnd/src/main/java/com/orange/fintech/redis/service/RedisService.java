package com.orange.fintech.redis.service;

public interface RedisService {
    //    boolean save(RefreshToken refreshToken);
    //    boolean save(String token, String id);
    boolean save(String id, String token);

    String getValues(String key);

    boolean delete(String key);

    boolean hasKey(String key);
}
