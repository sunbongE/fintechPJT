package com.orange.fintech.payment.service;

import com.orange.fintech.group.dto.GroupMembersDto;
import com.orange.fintech.group.dto.GroupMembersListDto;
import com.orange.fintech.group.service.GroupService;
import com.orange.fintech.payment.repository.TransactionQueryRepository;
import java.util.ArrayList;
import java.util.List;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Slf4j
@Service
@Transactional
@RequiredArgsConstructor
public class CalculateService {

    private final GroupService groupService;
    private final PaymentService paymentService;
    private final TransactionQueryRepository transactionQueryRepository;

    public class Member {
        long amount;
        String kakaoId;

        public Member(long amount, String kakaoId) {
            this.amount = amount;
            this.kakaoId = kakaoId;
        }
    }

    public void yeojungCalculate(int groupId, String lastMemberId) {
        GroupMembersListDto listDto = groupService.findGroupMembers(groupId);

        List<Member> plus = new ArrayList<>();
        List<Member> minus = new ArrayList<>();

        int remainder = transactionQueryRepository.sumOfRemainder(groupId);

        for (GroupMembersDto dto : listDto.getGroupMembersDtos()) {
            long amount = transactionQueryRepository.sumOfTotalAmount(groupId, dto.getKakaoId());
            if (dto.getKakaoId().equals(lastMemberId)) {
                amount -= remainder;
            }

            if (amount >= 0) {
                plus.add(new Member(amount, dto.getKakaoId()));
            } else {
                minus.add(new Member(amount, dto.getKakaoId()));
            }
        }
    }
}
