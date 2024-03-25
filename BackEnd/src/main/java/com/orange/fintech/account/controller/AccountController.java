package com.orange.fintech.account.controller;

import com.orange.fintech.account.dto.AccountResDto;
import com.orange.fintech.account.service.AccountService;
import com.orange.fintech.common.BaseResponseBody;
import com.orange.fintech.member.repository.MemberRepository;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.tags.Tag;
import java.security.Principal;
import java.util.List;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
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

    @GetMapping("/list")
    @Operation(summary = "회원의 계좌 목록 조회", description = "<string>회원의 <strong>계좌 목록</strong>을 조회한다.")
    @ApiResponses({
        @ApiResponse(responseCode = "200", description = "성공"),
        @ApiResponse(responseCode = "500", description = "서버 에러")
    })
    public ResponseEntity<?> findAccountList(Principal principal) {
        String memberId = principal.getName();
        try {
            List<AccountResDto> result = accountService.findAccountList(memberId);
            return ResponseEntity.ok().body(result);
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.internalServerError().body(BaseResponseBody.of(500, "서버 에러"));
        }
    }
}
