package com.orange.fintech.account.controller;

import com.orange.fintech.account.service.AccountService;
import com.orange.fintech.member.repository.MemberRepository;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@Tag(name = "Account", description = "계좌관련 API")
@Slf4j
@RestController
@RequiredArgsConstructor
@RequestMapping("/api/v1/account")
public class AccountController {
    private final MemberRepository memberRepository;
    private final AccountService accountService;
}
