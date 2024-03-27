package com.orange.fintech.account.controller;

import com.orange.fintech.account.dto.TransactionResDto;
import com.orange.fintech.account.dto.UpdateAccountDto;
import com.orange.fintech.account.service.AccountService;
import com.orange.fintech.common.BaseResponseBody;
import com.orange.fintech.member.repository.MemberRepository;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import java.security.Principal;
import java.util.Collections;
import java.util.List;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.json.simple.JSONObject;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@Tag(name = "Account", description = "계좌관련 API")
@Slf4j
@RestController
@RequiredArgsConstructor
@RequestMapping("/api/v1/account")
public class AccountController {
    private final MemberRepository memberRepository;
    private final AccountService accountService;

    @GetMapping("/list/{bankId}")
    @Operation(summary = "회원의 계좌 목록 조회", description = "<string>회원의 <strong>계좌 목록</strong>을 조회한다.")
    @ApiResponses({
        @ApiResponse(responseCode = "200", description = "성공"),
        @ApiResponse(responseCode = "500", description = "서버 에러")
    })
    public ResponseEntity<?> findAccountList(
            @PathVariable("bankId") String bankId, Principal principal) {
        if (!bankId.equals("001")) {
            return ResponseEntity.ok().body(Collections.EMPTY_LIST);
        }
        String memberId = principal.getName();
        try {
            List<JSONObject> result = accountService.findAccountList(memberId);
            return ResponseEntity.ok().body(result);
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.internalServerError().body(BaseResponseBody.of(500, "서버 에러"));
        }
    }

    @PutMapping("/update")
    @Operation(
            summary = "주계좌 등록(수정)",
            description = "<string>회원의 <strong>주계좌</strong>를 등록 혹은 수정한다.")
    @ApiResponses({
        @ApiResponse(responseCode = "200", description = "주계좌 등록됨"),
        @ApiResponse(responseCode = "500", description = "서버 에러")
    })
    public ResponseEntity<?> accountMainAccount(
            @RequestBody @Valid UpdateAccountDto dto, Principal principal) {

        String memberId = principal.getName();
        try {
            accountService.updateMainAccount(memberId, dto);
            return ResponseEntity.ok().body("주계좌 등록됨");
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.internalServerError().body(BaseResponseBody.of(500, "서버 에러"));
        }
    }

    @GetMapping("/transaction")
    @Operation(summary = "거래내역 조회", description = "거래내역을 전부 조회하거나 일부 조회하여 저장 후 거래내역을 반환한다.")
    @ApiResponses({
        @ApiResponse(responseCode = "200", description = "성공"),
        @ApiResponse(responseCode = "500", description = "서버 에러")
    })
    public ResponseEntity<?> readAllOrUpdateTransation(
             Principal principal) {

        String memberId = principal.getName();
        try {
            List<TransactionResDto> result = accountService.readAllOrUpdateTransation(memberId);
            return ResponseEntity.ok().body(result);
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.internalServerError().body(BaseResponseBody.of(500, "서버 에러"));
        }
    }
//
//    @GetMapping("/transaction/reload")
//    @Operation(summary = "거래내역 새로고침", description = "회원의 거래내역에서 새로운 내역을 조회하여 저장한다.")
//    @ApiResponses({
//            @ApiResponse(responseCode = "200", description = "성공"),
//            @ApiResponse(responseCode = "500", description = "서버 에러")
//    })
//    public ResponseEntity<?> transactionReload(
//            Principal principal) {
//        String memberId = principal.getName();
//
//        try {
//            String result =
//            return ResponseEntity.ok().body(result);
//        } catch (Exception e) {
//            e.printStackTrace();
//            return ResponseEntity.internalServerError().body(BaseResponseBody.of(500, "서버 에러"));
//        }
//    }
}
