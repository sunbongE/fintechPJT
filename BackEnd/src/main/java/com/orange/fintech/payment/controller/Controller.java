//package com.orange.fintech.payment.controller;
//
//import com.orange.fintech.payment.dto.*;
//import com.orange.fintech.payment.service.PaymentService;
//import io.swagger.v3.oas.annotations.Operation;
//import io.swagger.v3.oas.annotations.Parameter;
//import io.swagger.v3.oas.annotations.enums.ParameterIn;
//import io.swagger.v3.oas.annotations.responses.ApiResponse;
//import io.swagger.v3.oas.annotations.responses.ApiResponses;
//import io.swagger.v3.oas.annotations.tags.Tag;
//import java.security.Principal;
//import lombok.RequiredArgsConstructor;
//import lombok.extern.slf4j.Slf4j;
//import org.springframework.http.ResponseEntity;
//import org.springframework.web.bind.annotation.*;
//
//@Slf4j
//@Tag(name = "Payment", description = "정산 API")
//@RestController
//@RequiredArgsConstructor
//@RequestMapping("/api/v1/payments")
//public class PaymentController {
//
//    private final PaymentService paymentService;
//
//    @GetMapping("/{paymentId}")
//    @Operation(summary = "결제 내역 상세보기", description = "<strong>paymentId</strong>로 결제 내역 상세보기 한다.")
//    @ApiResponses({
//        @ApiResponse(responseCode = "200", description = "성공"),
//        @ApiResponse(responseCode = "403", description = "권한 없음"),
//        @ApiResponse(responseCode = "404", description = "잘못된 정보 요청"),
//        @ApiResponse(responseCode = "500", description = "서버 오류")
//    })
//    public ResponseEntity<TransactionDetailRes> getTransactionDetail(
//            @PathVariable @Parameter(description = "그룹 아이디", in = ParameterIn.PATH) int groupId,
//            @PathVariable @Parameter(description = "거래 아이디", in = ParameterIn.PATH) int paymentId,
//            Principal principal) {
//
//        try {
//            TransactionDetailRes transactionDetail = paymentService.getTransactionDetail(paymentId);
//
//            return ResponseEntity.status(200).body(transactionDetail);
//        } catch (Exception e) {
//            e.printStackTrace();
//            return ResponseEntity.status(404).body(null);
//        }
//    }
//}
