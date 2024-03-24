package com.orange.fintech.payment.controller;

import com.orange.fintech.common.BaseResponseBody;
import com.orange.fintech.payment.dto.*;
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
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@Slf4j
@Tag(name = "Payment", description = "그룹 정산 API")
@RestController
@RequiredArgsConstructor
@RequestMapping("/api/v1/groups/{groupId}/payments")
public class PaymentController {

    private final PaymentService paymentService;

    @GetMapping("/my")
    @Operation(
            summary = "그룹 내에서 내 결제 내역 조회",
            description = "<strong>그룹 아이디</strong>로 내 결제 내역을 조회한다.")
    @ApiResponses({
        @ApiResponse(responseCode = "200", description = "성공"),
        @ApiResponse(responseCode = "404", description = "사용자 정보 없음"),
        @ApiResponse(responseCode = "500", description = "서버 오류")
    })
    public ResponseEntity<? extends List<TransactionDto>> getMyTransactionList(
            @PathVariable @Parameter(description = "그룹 아이디", in = ParameterIn.PATH) int groupId,
            @Parameter(description = "페이지 번호(0부터 시작)") @RequestParam int page,
            @Parameter(description = "페이지당 항목 수") @RequestParam int size,
            Principal principal) {

        String memberId = principal.getName();

        List<TransactionDto> list = paymentService.getMyTransaction(memberId, groupId, page, size);

        log.info("list.size {}", list.size());
        return ResponseEntity.status(200).body(list);
    }

    @PutMapping("/{paymentId}/include")
    @Operation(
            summary = "정산 내역에 포함하기 / 제외하기",
            description = "<strong>paymentId</strong>로 정산 내역 포함 여부를 설정한다.")
    @ApiResponses({
        @ApiResponse(responseCode = "200", description = "성공"),
        @ApiResponse(responseCode = "403", description = "권한 없음"),
        @ApiResponse(responseCode = "404", description = "잘못된 정보 요청"),
        @ApiResponse(responseCode = "500", description = "서버 오류")
    })
    public ResponseEntity<? extends BaseResponseBody> modifyPaymentsList(
            @PathVariable @Parameter(description = "그룹 아이디", in = ParameterIn.PATH) int groupId,
            @PathVariable @Parameter(description = "거래 아이디", in = ParameterIn.PATH) int paymentId,
            Principal principal) {

        //        if (!paymentService.isMyTransaction(principal.getName(), paymentId)) {
        //            return ResponseEntity.status(403).body(BaseResponseBody.of(403, "FORBIDDEN"));
        //        }

        if (paymentService.changeContainStatus(paymentId, groupId)) {

            return ResponseEntity.status(200).body(BaseResponseBody.of(200, "OK"));
        } else {
            return ResponseEntity.status(404).body(BaseResponseBody.of(404, "NOT_FOUND"));
        }
    }

    @PutMapping("/{paymentId}")
    @Operation(summary = "결제 내역 수정", description = "<strong>paymentId</strong>로 정산 내역을 수정한다")
    @ApiResponses({
        @ApiResponse(responseCode = "200", description = "성공"),
        @ApiResponse(responseCode = "403", description = "권한 없음"),
        @ApiResponse(responseCode = "404", description = "잘못된 정보 요청"),
        @ApiResponse(responseCode = "500", description = "서버 오류")
    })
    public ResponseEntity<? extends BaseResponseBody> editTransaction(
            @PathVariable @Parameter(description = "그룹 아이디", in = ParameterIn.PATH) int groupId,
            @PathVariable @Parameter(description = "거래 아이디", in = ParameterIn.PATH) int paymentId,
            @RequestBody TransactionEditReq req,
            Principal principal) {
        log.info("editTransaction 시작");
        //        if (!paymentService.isMyTransaction(principal.getName(), paymentId)) {
        //            return ResponseEntity.status(403).body(BaseResponseBody.of(403, "FORBIDDEN"));
        //        }

        try {
            paymentService.editTransactionDetail(paymentId, req);
        } catch (NoSuchElementException e) {
            e.printStackTrace();
            return ResponseEntity.status(404).body(BaseResponseBody.of(404, "NOT_FOUND"));
        }

        return ResponseEntity.status(200).body(BaseResponseBody.of(200, "OK"));
    }

    @PostMapping("/cash")
    @Operation(summary = "현금 결제 내역 추가", description = "<strong>groupId</strong>로 현금 결제 내역을 추가한다.")
    @ApiResponses({
        @ApiResponse(responseCode = "200", description = "성공"),
        @ApiResponse(responseCode = "403", description = "권한 없음"),
        @ApiResponse(responseCode = "404", description = "잘못된 정보 요청"),
        @ApiResponse(responseCode = "500", description = "서버 오류")
    })
    public ResponseEntity<? extends BaseResponseBody> addCash(
            @PathVariable @Parameter(description = "그룹 아이디", in = ParameterIn.PATH) int groupId,
            @RequestBody AddCashTransactionReq addTransactionDto,
            Principal principal) {
        log.info("addCash 시작");
        log.info("addTransactionDto {}", addTransactionDto);
        paymentService.addTransaction(principal.getName(), groupId, addTransactionDto);

        return ResponseEntity.status(200).body(BaseResponseBody.of(200, "OK"));
    }

    @GetMapping("/{paymentId}")
    @Operation(summary = "결제 내역 상세보기", description = "<strong>paymentId</strong>로 결제 내역 상세보기 한다.")
    @ApiResponses({
        @ApiResponse(responseCode = "200", description = "성공"),
        @ApiResponse(responseCode = "403", description = "권한 없음"),
        @ApiResponse(responseCode = "404", description = "잘못된 정보 요청"),
        @ApiResponse(responseCode = "500", description = "서버 오류")
    })
    public ResponseEntity<GroupTransactionDetailRes> getGroupTransactionDetail(
            @PathVariable @Parameter(description = "그룹 아이디", in = ParameterIn.PATH) int groupId,
            @PathVariable @Parameter(description = "거래 아이디", in = ParameterIn.PATH) int paymentId,
            Principal principal) {

        //        if (!paymentService.isMyGroup(principal.getName(), groupId)
        //                || !paymentService.isMyGroupTransaction(groupId, paymentId)) {
        //            return ResponseEntity.status(403).body(null);
        //        }

        try {
            GroupTransactionDetailRes res = paymentService.getGroupTransactionDetail(paymentId);
            return ResponseEntity.status(200).body(res);
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.status(404).body(null);
        }
    }

    @GetMapping("")
    @Operation(summary = "그룹 결제내역 조회", description = "<strong>groupId</strong>로 그룹의 결제 내역을 조회한다.")
    @ApiResponses({
        @ApiResponse(responseCode = "200", description = "성공"),
        @ApiResponse(responseCode = "403", description = "권한 없음"),
        @ApiResponse(responseCode = "404", description = "잘못된 정보 요청"),
        @ApiResponse(responseCode = "500", description = "서버 오류")
    })
    public ResponseEntity<? extends List<TransactionDto>> getGroupPayments(
            @PathVariable @Parameter(description = "그룹 아이디", in = ParameterIn.PATH) int groupId,
            @Parameter(description = "페이지 번호(0부터 시작)") @RequestParam int page,
            @Parameter(description = "페이지당 항목 수") @RequestParam int size,
            @Parameter(description = "조건", example = "all || my") @RequestParam String option,
            Principal principal) {

        log.info("getGroupPayments start");
        try {
            List<TransactionDto> res =
                    paymentService.getGroupTransaction(
                            principal.getName(), groupId, page, size, option);
            return ResponseEntity.status(200).body(res);
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.status(404).body(null);
        }
    }

    @GetMapping("/{paymentId}/receipt/{receiptId}")
    @Operation(summary = "영수증 보기", description = "영수증을 불러온다.")
    @ApiResponses({
        @ApiResponse(responseCode = "200", description = "성공"),
        @ApiResponse(responseCode = "403", description = "권한 없음"),
        @ApiResponse(responseCode = "404", description = "잘못된 정보 요청"),
        @ApiResponse(responseCode = "500", description = "서버 오류")
    })
    public ResponseEntity<ReceiptDto> getGroupReceipt(
            @PathVariable @Parameter(description = "그룹 아이디", in = ParameterIn.PATH) int groupId,
            @PathVariable @Parameter(description = "거래 아이디", in = ParameterIn.PATH) int paymentId,
            @PathVariable @Parameter(description = "영수증 아이디", in = ParameterIn.PATH) int receiptId,
            Principal principal) {

        //        if (!paymentService.isMyGroup(principal.getName(), groupId)
        //                || !paymentService.isMyGroupTransaction(groupId, paymentId)) {
        //            return ResponseEntity.status(403).body(null);
        //        }

        try {
            ReceiptDto res = paymentService.getGroupReceipt(receiptId);

            return ResponseEntity.status(200).body(res);
        } catch (Exception e) {

            return ResponseEntity.status(403).body(null);
        }
    }

    @GetMapping("/{paymentId}/receipt/receipt-detail/{receiptDetailId}")
    @Operation(summary = "영수증 세부 항목 보기", description = "영수증 세부 항목 내용(밥, 인원A,B,C)을 불러온다.")
    @ApiResponses({
        @ApiResponse(responseCode = "200", description = "성공"),
        @ApiResponse(responseCode = "403", description = "권한 없음"),
        @ApiResponse(responseCode = "404", description = "잘못된 정보 요청"),
        @ApiResponse(responseCode = "500", description = "서버 오류")
    })
    public ResponseEntity<ReceiptDetailRes> getGroupReceiptDetail(
            @PathVariable @Parameter(description = "그룹 아이디", in = ParameterIn.PATH) int groupId,
            @PathVariable @Parameter(description = "거래 아이디", in = ParameterIn.PATH) int paymentId,
            @PathVariable @Parameter(description = "영수증 세부항목 아이디", in = ParameterIn.PATH)
                    int receiptDetailId,
            Principal principal) {

        //        if (!paymentService.isMyGroup(principal.getName(), groupId)
        //                || !paymentService.isMyGroupTransaction(groupId, paymentId)) {
        //            return ResponseEntity.status(403).body(null);
        //        }

        try {
            ReceiptDetailRes groupReceiptDetail =
                    paymentService.getGroupReceiptDetail(receiptDetailId);
            return ResponseEntity.status(200).body(groupReceiptDetail);
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.status(404).body(null);
        }
    }

    @PutMapping("/{paymentId}/receipt/receipt-detail/{receiptDetailId}")
    @Operation(summary = "영수증 세부 항목 참여 인원 설정", description = "영수증 세부 항목에 대한 참여 인원 설정을 한다.")
    @ApiResponses({
        @ApiResponse(responseCode = "200", description = "성공"),
        @ApiResponse(responseCode = "403", description = "권한 없음"),
        @ApiResponse(responseCode = "404", description = "잘못된 정보 요청"),
        @ApiResponse(responseCode = "500", description = "서버 오류")
    })
    public ResponseEntity<BaseResponseBody> setReceiptDetailMember(
            @PathVariable @Parameter(description = "그룹 아이디", in = ParameterIn.PATH) int groupId,
            @PathVariable @Parameter(description = "거래 아이디", in = ParameterIn.PATH) int paymentId,
            @PathVariable @Parameter(description = "영수증 세부항목 아이디", in = ParameterIn.PATH)
                    int receiptDetailId,
            @RequestBody List<ReceiptDetailMemberDto> memberList,
            Principal principal) {

        //        if (!paymentService.isMyGroup(principal.getName(), groupId)
        //                || !paymentService.isMyGroupTransaction(groupId, paymentId)) {
        //            return ResponseEntity.status(403).body(BaseResponseBody.of(403, "FORBIDDEN"));
        //        }

        try {
            paymentService.setReceiptDetailMember(memberList);

            return ResponseEntity.status(200).body(BaseResponseBody.of(200, "OK"));
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.status(404).body(BaseResponseBody.of(404, "NOT_FOUND"));
        }
    }
}
