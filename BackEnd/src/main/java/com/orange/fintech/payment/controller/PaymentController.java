package com.orange.fintech.payment.controller;

import com.orange.fintech.payment.dto.TransactionDto;
import com.orange.fintech.payment.service.PaymentService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.enums.ParameterIn;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.tags.Tag;
import java.security.Principal;
import java.util.List;
import java.util.NoSuchElementException;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@Slf4j
@Tag(name = "Payment", description = "정산 API")
@RestController
@RequiredArgsConstructor
@RequestMapping("/api/v1/groups/{groupId}/payments")
public class PaymentController {

    @Autowired private final PaymentService paymentService;

    @GetMapping("/my")
    @Operation(summary = "내 결제 내역 조회", description = "<strong>그룹 아이디</strong>로 내 결제 내역을 조회한다.")
    @ApiResponses({
        @ApiResponse(responseCode = "200", description = "성공"),
        @ApiResponse(responseCode = "404", description = "사용자 정보 없음"),
        @ApiResponse(responseCode = "500", description = "서버 오류")
    })
    public ResponseEntity<? extends List<TransactionDto>> getMyTransactionList(
            @PathVariable @Parameter(description = "그룹 아이디", in = ParameterIn.PATH) int groupId,
            Principal principal) {

        String memberId = principal.getName();

        List<TransactionDto> list = paymentService.getMyTransaction(memberId, groupId);

        log.info("list.size {}", list.size());
        return ResponseEntity.status(200).body(list);
    }

    @PutMapping("/{paymentId}")
    @Operation(
            summary = "정산 내역에 포함하기 / 제외하기",
            description = "<strong>paymentId</strong>로 정산 내역 포함 여부를 설정한다.")
    @ApiResponses({
        @ApiResponse(responseCode = "200", description = "성공"),
        @ApiResponse(responseCode = "403", description = "권한 없음"),
        @ApiResponse(responseCode = "404", description = "잘못된 정보 요청"),
        @ApiResponse(responseCode = "500", description = "서버 오류")
    })
    public ResponseEntity<?> modifyPaymentsList(
            @PathVariable @Parameter(description = "그룹 아이디", in = ParameterIn.PATH) int groupId,
            @PathVariable @Parameter(description = "거래 아이디", in = ParameterIn.PATH) int paymentId,
            Principal principal) {

        if (!paymentService.isMyTransaction(principal.getName(), paymentId)) {
            return ResponseEntity.status(403).body("FORBIDDEN");
        }

        if (paymentService.changeContainStatus(paymentId, groupId)) {

            return ResponseEntity.status(200).body("OK");
        } else {
            return ResponseEntity.status(404).body("NOT_FOUND");
        }
    }

    @PutMapping("/{paymentId}/memo")
    @Operation(summary = "결제 내역에 메모", description = "<strong>paymentId</strong>로 정산 내역에 메모를 한다.")
    @ApiResponses({
        @ApiResponse(responseCode = "200", description = "성공"),
        @ApiResponse(responseCode = "403", description = "권한 없음"),
        @ApiResponse(responseCode = "404", description = "잘못된 정보 요청"),
        @ApiResponse(responseCode = "500", description = "서버 오류")
    })
    public ResponseEntity<?> memo(
            @PathVariable @Parameter(description = "그룹 아이디", in = ParameterIn.PATH) int groupId,
            @PathVariable @Parameter(description = "거래 아이디", in = ParameterIn.PATH) int paymentId,
            @RequestBody String memo,
            Principal principal) {

        if (!paymentService.isMyTransaction(principal.getName(), paymentId)) {
            return ResponseEntity.status(403).body("FORBIDDEN");
        }

        try {
            paymentService.memo(paymentId, memo);
        } catch (NoSuchElementException e) {
            return ResponseEntity.status(404).body("NOT_FOUND");
        }

        return ResponseEntity.status(200).body("OK");
    }
}
