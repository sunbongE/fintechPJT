package com.orange.fintech.payment.controller;

import com.orange.fintech.auth.dto.CustomUserDetails;
import com.orange.fintech.common.BaseResponseBody;
import com.orange.fintech.common.exception.BigFileException;
import com.orange.fintech.common.exception.EmptyFileException;
import com.orange.fintech.common.exception.NotValidExtensionException;
import com.orange.fintech.common.exception.RelatedTransactionNotFoundException;
import com.orange.fintech.group.entity.GroupStatus;
import com.orange.fintech.group.repository.GroupQueryRepository;
import com.orange.fintech.group.service.GroupService;
import com.orange.fintech.notification.Dto.MessageListDataReqDto;
import com.orange.fintech.notification.entity.NotificationType;
import com.orange.fintech.notification.service.FcmService;
import com.orange.fintech.payment.dto.*;
import com.orange.fintech.payment.service.CalculateService;
import com.orange.fintech.payment.service.PaymentService;
import com.orange.fintech.util.FileService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.enums.ParameterIn;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.tags.Tag;
import java.io.IOException;
import java.security.Principal;
import java.util.ArrayList;
import java.util.List;
import java.util.NoSuchElementException;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

@Slf4j
@Tag(name = "Payment", description = "그룹 정산 API")
@RestController
@RequiredArgsConstructor
@RequestMapping("/api/v1/groups/{groupId}/payments")
public class PaymentController {

    private final PaymentService paymentService;
    private final GroupService groupService;
    private final CalculateService calculateService;
    private final FcmService fcmService;
    private final GroupQueryRepository groupQueryRepository;
    private final FileService fileService;

    @GetMapping("/my")
    @Operation(
            summary = "그룹 내에서 내 결제 내역 조회",
            description = "<strong>그룹 아이디</strong>로 내 결제 내역을 조회한다.")
    @ApiResponses({
        @ApiResponse(responseCode = "200", description = "성공"),
        @ApiResponse(responseCode = "403", description = "권한 없음"),
        @ApiResponse(responseCode = "500", description = "서버 오류")
    })
    public ResponseEntity<? extends List<TransactionDto>> getMyTransactionList(
            @PathVariable @Parameter(description = "그룹 아이디", in = ParameterIn.PATH) int groupId,
            @Parameter(description = "페이지 번호(0부터 시작)") @RequestParam int page,
            @Parameter(description = "페이지당 항목 수") @RequestParam int size,
            Principal principal) {

        String memberId = principal.getName();

        if (!paymentService.isMyGroup(principal.getName(), groupId)) {
            return ResponseEntity.status(403).body(null);
        }

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

        if (!paymentService.isMyTransaction(principal.getName(), paymentId)) {
            return ResponseEntity.status(403).body(BaseResponseBody.of(403, "FORBIDDEN"));
        }

        try {
            paymentService.changeContainStatus(paymentId, groupId);
            return ResponseEntity.status(200).body(BaseResponseBody.of(200, "OK"));
        } catch (Exception e) {
            e.printStackTrace();
        }

        return ResponseEntity.status(404).body(BaseResponseBody.of(404, "NOT_FOUND"));
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

        try {
            if (!paymentService.isMyTransaction(principal.getName(), paymentId)
                    || paymentService.isMyGroupTransaction(groupId, paymentId)
                    || !groupService.getGroupStatus(groupId).equals(GroupStatus.SPLIT)) {
                return ResponseEntity.status(403).body(BaseResponseBody.of(403, "FORBIDDEN"));
            }

            paymentService.editTransactionDetail(paymentId, req);

            if (!paymentService.isMyTransaction(principal.getName(), paymentId)) {
                // TODO: 태호 알림
                MessageListDataReqDto messageListDataReqDto = new MessageListDataReqDto();
                messageListDataReqDto.setGroupId(groupId);
                messageListDataReqDto.setNotificationType(NotificationType.SPLIT_MODIFY);

                List<String> groupMembersKakaoId =
                        groupQueryRepository.findGroupMembersKakaoId(groupId);

                messageListDataReqDto.setTargetMembers(groupMembersKakaoId);

                fcmService.pushListDataMSG(messageListDataReqDto);
            }

        } catch (NoSuchElementException e) {
            e.printStackTrace();
            return ResponseEntity.status(404).body(BaseResponseBody.of(404, "NOT_FOUND"));
        } catch (IOException e) {
            throw new RuntimeException(e);
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
        paymentService.addCashTransaction(principal.getName(), groupId, addTransactionDto);

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

        if (!paymentService.isMyGroup(principal.getName(), groupId)
                || !paymentService.isMyGroupTransaction(groupId, paymentId)) {
            return ResponseEntity.status(403).body(null);
        }

        try {
            GroupTransactionDetailRes res = paymentService.getGroupTransactionDetail(paymentId);
            return ResponseEntity.status(200).body(res);
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.status(404).body(null);
        }
    }

    @GetMapping("")
    @Operation(
            summary = "그룹 결제내역 조회",
            description = "<strong>groupId</strong>로 그룹의 결제(정산) 내역을 조회한다.")
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

        if (!paymentService.isMyGroup(principal.getName(), groupId)
                || !paymentService.isMyGroupTransaction(groupId, paymentId)) {
            return ResponseEntity.status(403).body(null);
        }

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

        if (!paymentService.isMyGroup(principal.getName(), groupId)
                || !paymentService.isMyGroupTransaction(groupId, paymentId)) {
            return ResponseEntity.status(403).body(null);
        }

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
            @RequestBody List<ReceiptDetailMemberPutDto> memberList,
            Principal principal) {

        if (!paymentService.isMyGroup(principal.getName(), groupId)
                || !paymentService.isMyGroupTransaction(groupId, paymentId)) {
            return ResponseEntity.status(403).body(BaseResponseBody.of(403, "FORBIDDEN"));
        }

        try {
            paymentService.setReceiptDetailMember(paymentId, receiptDetailId, memberList);

            if (!paymentService.isMyTransaction(principal.getName(), paymentId)) {
                // TODO: 태호 알림
                MessageListDataReqDto messageListDataReqDto = new MessageListDataReqDto();
                messageListDataReqDto.setGroupId(groupId);
                messageListDataReqDto.setNotificationType(NotificationType.SPLIT_MODIFY);

                List<String> groupMembersKakaoId = new ArrayList<>();
                for (ReceiptDetailMemberPutDto receiptDetailMemberPutDto : memberList) {
                    groupMembersKakaoId.add(receiptDetailMemberPutDto.getMemberId());
                }
                messageListDataReqDto.setTargetMembers(groupMembersKakaoId);

                fcmService.pushListDataMSG(messageListDataReqDto);
            }

            return ResponseEntity.status(200).body(BaseResponseBody.of(200, "OK"));
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.status(404).body(BaseResponseBody.of(404, "NOT_FOUND"));
        }
    }

    @PostMapping("/receipt")
    @Operation(summary = "영수증 일괄 등록", description = "다수의 영수증을 <strong>(JSON)</strong> 등록한다.")
    @ApiResponses({
        @ApiResponse(responseCode = "200", description = "성공"),
        @ApiResponse(responseCode = "403", description = "권한 없음"),
        @ApiResponse(responseCode = "404", description = "일치하는 결제 내역 없음"),
        @ApiResponse(responseCode = "500", description = "서버 오류")
    })
    public ResponseEntity<?> addMultipleReceipt(
            @AuthenticationPrincipal CustomUserDetails customUserDetails,
            @PathVariable @Parameter(description = "그룹 아이디", in = ParameterIn.PATH) int groupId,
            @RequestBody List<ReceiptRequestDto> receiptRequestDtoList) {
        String kakaoId = customUserDetails.getUsername();

        try {
            paymentService.addMultipleReceipt(kakaoId, receiptRequestDtoList);
            log.info("영수증 200");

            return ResponseEntity.status(200).body(BaseResponseBody.of(200, "영수증이 정상 등록되었습니다."));
        } catch (RelatedTransactionNotFoundException e) {
            log.info("영수증 404");

            return ResponseEntity.status(HttpStatus.NOT_FOUND)
                    .body("업로드한 영수증에 해당하는 결제 정보를 Transaction 테이블에서 찾을 수 없습니다.");
        } catch (Exception e) {
            log.info("영수증 500");

            return ResponseEntity.internalServerError()
                    .body(BaseResponseBody.of(500, "영수증 저장에 실패했습니다."));
        }
    }

    @GetMapping("/yeojung")
    @Operation(summary = "여정 페이지", description = "groupId로 이번 여정 불러오기")
    @ApiResponses({
        @ApiResponse(responseCode = "200", description = "성공"),
        @ApiResponse(responseCode = "403", description = "권한 없음"),
        @ApiResponse(responseCode = "404", description = "잘못된 정보 요청"),
        @ApiResponse(responseCode = "500", description = "서버 오류")
    })
    public ResponseEntity<List<YeojungDto>> getYeojung(
            @PathVariable @Parameter(description = "그룹 아이디", in = ParameterIn.PATH) int groupId,
            Principal principal) {

        if (!paymentService.isMyGroup(principal.getName(), groupId)) {
            return ResponseEntity.status(403).body(null);
        }

        try {
            List<YeojungDto> res = calculateService.yeojungCalculator(groupId, principal.getName());

            return ResponseEntity.status(200).body(res);
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.status(404).body(null);
        }
    }

    @GetMapping("/yeojung/detail")
    @Operation(
            summary = "여정 정산 내역 페이지",
            description = "<strong>groupId, otherMemberId, type</strong>으로 여정 정산내역 불러오기")
    @ApiResponses({
        @ApiResponse(responseCode = "200", description = "성공"),
        @ApiResponse(responseCode = "403", description = "권한 없음"),
        @ApiResponse(responseCode = "404", description = "잘못된 정보 요청"),
        @ApiResponse(responseCode = "500", description = "서버 오류")
    })
    public ResponseEntity<List<TransactionDto>> getYeojungDetail(
            @PathVariable @Parameter(description = "그룹 아이디", in = ParameterIn.PATH) int groupId,
            @Parameter(description = "SEND(보낼 금액) || RECEIVE(받을 금액)") @RequestParam String type,
            @Parameter(description = "상세보기할 멤버 아이디") @RequestParam String otherMemberId,
            Principal principal) {

        if (!paymentService.isMyGroup(principal.getName(), groupId)) {
            return ResponseEntity.status(403).body(null);
        }

        try {
            List<TransactionDto> res =
                    calculateService.getRequest(groupId, type, principal.getName(), otherMemberId);
            return ResponseEntity.status(200).body(res);
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.status(404).body(null);
        }
    }

    @PostMapping(
            value = "/receiptImage",
            consumes = {MediaType.MULTIPART_FORM_DATA_VALUE})
    @Operation(summary = "영수증 이미지 일괄 등록", description = "다수의 영수증을 <strong>(이미지)</strong> 등록한다.")
    @ApiResponses({
        // TODO: 응답 이대로 가는지 확인
        @ApiResponse(responseCode = "200", description = "정상 등록"),
        @ApiResponse(responseCode = "400", description = "비어있는 파일"),
        @ApiResponse(responseCode = "413", description = "20MB를 초과하는 파일"),
        @ApiResponse(responseCode = "415", description = "지원하지 않는 확장자"),
        @ApiResponse(responseCode = "500", description = "서버 오류"),
    })
    public ResponseEntity<?> uploadReceiptImages(
            @RequestPart(value = "file", required = true) MultipartFile[] receiptImageList) {

        try {
            fileService.uploadReceiptImagesToAmazonS3(receiptImageList);

            return ResponseEntity.status(HttpStatus.OK).body("영수증이 정상 저장되었습니다.");
        } catch (EmptyFileException e) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                    .body(BaseResponseBody.of(400, "파일이 비어있습니다."));
        } catch (BigFileException e) {
            return ResponseEntity.status(HttpStatus.PAYLOAD_TOO_LARGE)
                    .body(BaseResponseBody.of(413, "업로드한 파일의 용량이 20MB 이상입니다."));
        } catch (NotValidExtensionException e) {
            return ResponseEntity.status(HttpStatus.UNSUPPORTED_MEDIA_TYPE)
                    .body(
                            BaseResponseBody.of(
                                    415, "지원하는 확장자가 아닙니다. 지원하는 이미지 형식: jpg, jpeg, pdf, tiff"));
        } catch (Exception e) {
            e.printStackTrace();

            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(BaseResponseBody.of(500, "서버 오류"));
        }
    }
}
