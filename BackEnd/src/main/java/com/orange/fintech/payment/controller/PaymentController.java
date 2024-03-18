package com.orange.fintech.payment.controller;

import com.orange.fintech.group.entity.Group;
import com.orange.fintech.group.repository.GroupRepository;
import com.orange.fintech.member.entity.Member;
import com.orange.fintech.member.repository.MemberRepository;
import com.orange.fintech.payment.dto.TransactionDto;
import com.orange.fintech.payment.service.PaymentService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.enums.ParameterIn;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.tags.Tag;
import java.util.List;
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

    @Autowired private final MemberRepository memberRepository;
    @Autowired private final GroupRepository groupRepository;

    @GetMapping("/my")
    @Operation(summary = "내 결제 내역 조회", description = "<strong>그룹 아이디</strong>로 내 결제 내역을 조회한다.")
    @ApiResponses({
        @ApiResponse(responseCode = "200", description = "성공"),
        @ApiResponse(responseCode = "500", description = "서버 오류")
    })
    public ResponseEntity<? extends List<TransactionDto>> getMyTransactionList(
            @PathVariable @Parameter(description = "그룹 아이디", in = ParameterIn.PATH) int groupId) {

        //TODO: Member, Group 값 변경 필요
        List<TransactionDto> list = paymentService.getMyTransaction(new Member(), new Group());
        //        Member member = memberRepository.findById("").get();
        //        Group group = groupRepository.findById(groupId).get();
        //
        //        List<TransactionDto> list = paymentService.getMyTransaction(member, group);

        log.info("list.size {}", list.size());
        return ResponseEntity.status(200).body(list);
    }
}
