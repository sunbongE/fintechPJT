package com.orange.fintech.auth.service;

import com.orange.fintech.auth.dto.JoinDto;
import org.springframework.http.ResponseEntity;

public interface JoinService {
    ResponseEntity<?> joinProcess(JoinDto joinDto);
}
