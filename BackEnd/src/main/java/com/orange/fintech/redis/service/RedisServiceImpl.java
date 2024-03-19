package com.orange.fintech.redis.service;

import com.orange.fintech.util.RefreshTokenRepository;
import java.time.Duration;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.data.redis.core.ValueOperations;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@Transactional
@RequiredArgsConstructor
public class RedisServiceImpl implements RedisService {
    @Autowired private final RefreshTokenRepository refreshTokenRepository;

    @Autowired private RedisTemplate<String, Object> redisTemplate;

    @Override
    public boolean save(String id, String token) {
        try {
            redisTemplate.opsForValue().set(id, token, Duration.ofDays(90));

            return true;
        } catch (Exception e) {
            e.printStackTrace();

            return false;
        }
    }

    @Override
    public String getValues(String key) {
        ValueOperations<String, Object> values = redisTemplate.opsForValue();

        return (String) values.get(key);
    }

    @Override
    public boolean delete(String key) {
        try {
            redisTemplate.delete(key);
        } catch(Exception e) {
            e.printStackTrace();

            return false;
        }

        return true;
    }

    @Override
    public boolean hasKey(String key) {
        return redisTemplate.hasKey(key);
    }
}
