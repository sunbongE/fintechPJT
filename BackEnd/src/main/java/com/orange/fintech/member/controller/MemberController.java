package com.orange.fintech.member.controller;

import com.orange.fintech.auth.dto.CustomUserDetails;
import com.orange.fintech.member.entity.Account;
import com.orange.fintech.member.entity.Member;
import com.orange.fintech.member.repository.AccountRepository;
import com.orange.fintech.member.service.MemberService;
import com.orange.fintech.oauth.dto.MemberSearchResponseDto;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@Slf4j
@RestController
@RequestMapping("/api/v1/members")
public class MemberController {

    @Autowired
    MemberService memberService;

    @GetMapping("/account")
    @Operation(summary = "회원 본인의 계좌 정보 조회", description ="<string>회원 본인의 <strong>계좌정보</strong>를 조회한다.")
    @ApiResponses({
            @ApiResponse(responseCode = "200", description = "정상 반환"),
            @ApiResponse(responseCode = "404", description = "계좌 정보 없음 (DB 레코드 유실)"),
            @ApiResponse(responseCode = "500", description = "서버 오류")
    })
    public ResponseEntity<?> getMyAccountList(@AuthenticationPrincipal CustomUserDetails customUserDetails) {
        String kakaoId = customUserDetails.getUsername();

        Member member = memberService.findByKakaoId(kakaoId);
        List<Account> myAccounts = memberService.findAccountsByKakaoId(member);

        if(myAccounts != null && !myAccounts.isEmpty()) {
            return ResponseEntity.status(HttpStatus.OK).body(myAccounts);
        }

        return ResponseEntity.status(HttpStatus.NOT_FOUND).body("일치하는 계좌 정보 없음");
    }

    @GetMapping("/{email}")
    @Operation(summary = "사용자 검색", description ="<string>이메일 아이디<strong>로 사용자를 검색한다.")
    @ApiResponses({
            @ApiResponse(responseCode = "200", description = "일치하는 유저 정보 있음"),
            @ApiResponse(responseCode = "404", description = "일치하는 유저 정보 없음"),
            @ApiResponse(responseCode = "500", description = "서버 오류")
    })
    public ResponseEntity<?> searchUser(@PathVariable(name = "email") String email) {
        MemberSearchResponseDto memberSearchResponseDto = memberService.findByEmail(email);

        if(memberSearchResponseDto != null) {
            return ResponseEntity.status(HttpStatus.OK).body(memberSearchResponseDto);
        }

        return ResponseEntity.status(HttpStatus.NOT_FOUND).body("일치하는 유저 정보 없음");
    }
}
