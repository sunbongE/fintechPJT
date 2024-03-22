package com.orange.fintech.member.controller;

import com.orange.fintech.auth.dto.CustomUserDetails;
import com.orange.fintech.common.BaseResponseBody;
import com.orange.fintech.member.entity.Account;
import com.orange.fintech.member.entity.Member;
import com.orange.fintech.member.service.AccountService;
import com.orange.fintech.member.service.MemberService;
import com.orange.fintech.oauth.dto.MemberSearchResponseDto;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.tags.Tag;

import java.security.Principal;
import java.util.List;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

@Slf4j
@Tag(name = "Member", description = "회원 API")
@RestController
@RequiredArgsConstructor
@RequestMapping("/api/v1/members")
public class MemberController {

    @Autowired MemberService memberService;

    @Autowired AccountService accountService;

    @GetMapping("/account")
    @Operation(
            summary = "회원 본인의 계좌 정보 조회",
            description = "<string>회원 본인의 <strong>계좌정보</strong>를 조회한다.")
    @ApiResponses({
        @ApiResponse(responseCode = "200", description = "정상 반환"),
        @ApiResponse(responseCode = "404", description = "계좌 정보 없음 (DB 레코드 유실)"),
        @ApiResponse(responseCode = "500", description = "서버 오류")
    })
    public ResponseEntity<?> getMyAccountList(
            @AuthenticationPrincipal CustomUserDetails customUserDetails) {
        String kakaoId = customUserDetails.getUsername();

        Member member = memberService.findByKakaoId(kakaoId);
        List<Account> myAccounts = memberService.findAccountsByKakaoId(member);

        if (myAccounts != null && !myAccounts.isEmpty()) {
            return ResponseEntity.status(HttpStatus.OK).body(myAccounts);
        }

        return ResponseEntity.status(HttpStatus.NOT_FOUND).body("일치하는 계좌 정보 없음");
    }

    @PutMapping("/account")
    @Operation(
            summary = "계좌 정보 수정 (주 계좌 설정)",
            description = "<string>회원 본인의 <strong>계좌 정보</strong>를 수정한다.")
    @ApiResponses({
        @ApiResponse(responseCode = "200", description = "정상 저장"),
        @ApiResponse(responseCode = "500", description = "서버 오류")
    })
    public ResponseEntity<?> updatePrimaryAccount(
            @AuthenticationPrincipal CustomUserDetails customUserDetails, String accountNo) {
        String kakaoId = customUserDetails.getUsername();

        accountService.updatePrimaryAccount(kakaoId, accountNo);

        //        if(accountService.insertAccount(kakaoId, account)) {
        return ResponseEntity.ok(BaseResponseBody.of(200, "계좌 정보 추가 성공"));
        //        }

        //        return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
        //                .body(BaseResponseBody.of(500, "Pin 번호 수정 중 오류 발생"));
    }

    @GetMapping("/{email}")
    @Operation(summary = "사용자 검색", description = "<string>이메일 아이디<strong>로 사용자를 검색한다.")
    @ApiResponses({
        @ApiResponse(responseCode = "200", description = "일치하는 유저 정보 있음"),
        @ApiResponse(responseCode = "404", description = "일치하는 유저 정보 없음"),
        @ApiResponse(responseCode = "500", description = "서버 오류")
    })
    public ResponseEntity<?> searchUser(@PathVariable(name = "email") String email) {
        MemberSearchResponseDto memberSearchResponseDto = memberService.findByEmail(email);

        if (memberSearchResponseDto != null) {
            return ResponseEntity.status(HttpStatus.OK).body(memberSearchResponseDto);
        }

        return ResponseEntity.status(HttpStatus.NOT_FOUND).body("일치하는 유저 정보 없음");
    }

    @PostMapping("/pin")
    @Operation(summary = "핀 번호 등록", description = "앱에서 사용할 핀 번호를 등록한다.")
    @ApiResponses({
        @ApiResponse(responseCode = "200", description = "정상 등록"),
        @ApiResponse(responseCode = "500", description = "서버 오류")
    })
    public ResponseEntity<?> registerPin(
            @AuthenticationPrincipal CustomUserDetails customUserDetails, @RequestBody String pin) {

        String kakaoId = customUserDetails.getUsername();

        if (memberService.updatePin(kakaoId, pin)) {
            return ResponseEntity.ok(BaseResponseBody.of(200, "Pin 번호 수정 완료"));
        }

        return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                .body(BaseResponseBody.of(500, "Pin 번호 수정 중 오류 발생"));
    }

    @DeleteMapping()
    @Operation(summary = "회원 탈퇴", description = "")
    @ApiResponses({
        @ApiResponse(responseCode = "200", description = "정상 탈퇴"),
        @ApiResponse(responseCode = "500", description = "서버 오류")
    })
    public ResponseEntity<?> withdraw(
            @AuthenticationPrincipal CustomUserDetails customUserDetails) {
        String kakaoId = customUserDetails.getUsername();

        if (memberService.deleteUser(kakaoId)) {
            return ResponseEntity.ok(BaseResponseBody.of(200, "정상적으로 탈퇴되었습니다."));
        }

        return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                .body(BaseResponseBody.of(500, "탈퇴 중 오류 발생"));
    }
}
