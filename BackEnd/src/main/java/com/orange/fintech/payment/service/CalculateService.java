package com.orange.fintech.payment.service;

import com.orange.fintech.group.dto.GroupMembersDto;
import com.orange.fintech.group.dto.GroupMembersListDto;
import com.orange.fintech.group.service.GroupService;
import com.orange.fintech.payment.dto.TransactionDto;
import com.orange.fintech.payment.dto.YeojungDto;
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

    /**
     * memberId가 다른 그룹원들에게 얼마를 주고받아야하는지
     *
     * @param groupId
     * @param memberId 여정 페이지의 주인
     */
    public List<YeojungDto> yeojungCalculator(int groupId, String memberId) {
        GroupMembersListDto listDto = groupService.findGroupMembers(groupId);
        List<YeojungDto> yeojungList = new ArrayList<>();

        // 최적화?
        for (GroupMembersDto dto : listDto.getGroupMembersDtos()) {
            if (dto.getKakaoId().equals(memberId)) {
                continue;
            }
            YeojungDto yeojungDto = new YeojungDto();
            yeojungDto.setName(dto.getName());
            yeojungDto.setMemberId(dto.getKakaoId());

            // 받을 금액 계산
            yeojungDto.setSendAmount(
                    transactionQueryRepository.getReceiveAmount(memberId, dto.getKakaoId()));

            // 보낼 금액 계산
            yeojungDto.setReceiveAmount(
                    transactionQueryRepository.getReceiveAmount(dto.getKakaoId(), memberId));

            yeojungList.add(yeojungDto);
        }

        return yeojungList;
    }

    public List<TransactionDto> getRequest(
            int groupId, String type, String memberId, String otherMemberId) {
        if (type.equals("SEND")) {
            return getSendRequest(groupId, memberId, otherMemberId);
        } else {
            return getReceivedRequest(groupId, memberId, otherMemberId);
        }
    }

    private List<TransactionDto> getReceivedRequest(
            int groupId, String memberId, String otherMemberId) {
        List<TransactionDto> list =
                transactionQueryRepository.getReceivedRequest(groupId, memberId, otherMemberId);

        return list;
    }

    private List<TransactionDto> getSendRequest(
            int groupId, String memberId, String otherMemberId) {
        List<TransactionDto> list =
                transactionQueryRepository.getReceivedRequest(groupId, otherMemberId, memberId);

        return list;
    }

    public void finalCalculator(int groupId, String lastMemberId) {
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

        // SINYEONG: calculateResult 저장해야함
    }
}
