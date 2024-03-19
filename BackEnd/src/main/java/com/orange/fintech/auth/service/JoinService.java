package com.orange.fintech.auth.service;

import java.util.Map;
import org.springframework.http.ResponseEntity;

public interface JoinService {
    ResponseEntity<?> joinProcess(Map<String, Object> map);
}
