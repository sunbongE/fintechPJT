package com.orange.fintech.account.controller;

import com.orange.fintech.account.dto.TransactionResDto;
import com.orange.fintech.account.dto.UpdateAccountDto;
import com.orange.fintech.account.service.AccountService;
import com.orange.fintech.auth.dto.CustomUserDetails;
import com.orange.fintech.common.BaseResponseBody;
import com.orange.fintech.member.repository.MemberRepository;
import com.orange.fintech.payment.dto.ReceiptRequestDto;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
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
import org.json.simple.parser.ParseException;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;
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
            @Parameter(description = "페이지 번호(0부터 시작)") @RequestParam int page,
            @Parameter(description = "페이지당 항목 수") @RequestParam int size,
            Principal principal) {

        String memberId = principal.getName();
        try {
            List<TransactionResDto> result =
                    accountService.readAllOrUpdateTransation(memberId, page, size);
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
    //            return ResponseEntity.internalServerError().body(BaseResponseBody.of(500, "서버
    // 에러"));
    //        }
    //    }

    @PostMapping("/dummytransaction")
    @Operation(
            summary = "<strong>더미 데이터</strong>결제 내역 추가",
            description = "<strong>더미 데이터용</strong> 결제 내역을 추가한다.")
    @ApiResponses({
        @ApiResponse(responseCode = "200", description = "성공"),
        @ApiResponse(responseCode = "409", description = "일치하는 결제 내역 없음"),
        @ApiResponse(responseCode = "500", description = "서버 오류")
    })
    public ResponseEntity<?> addDummyTranactionRecord(
            @AuthenticationPrincipal CustomUserDetails customUserDetails,
            @RequestBody List<ReceiptRequestDto> receiptRequestDtoList) {
        String kakaoId = customUserDetails.getUsername();

        try {
            accountService.addDummyTranactionRecord(kakaoId, receiptRequestDtoList);

            return ResponseEntity.status(200).body(BaseResponseBody.of(200, "더미 데이터가 정상 추가되었습니다."));
        } catch (ParseException e) {
            e.printStackTrace();

            return ResponseEntity.internalServerError()
                    .body(BaseResponseBody.of(500, "영수증 저장에 실패했습니다."));
        } catch (Exception e) {
            e.printStackTrace();

            return ResponseEntity.internalServerError()
                    .body(BaseResponseBody.of(500, "영수증 저장에 실패했습니다."));
        }
    }
}
