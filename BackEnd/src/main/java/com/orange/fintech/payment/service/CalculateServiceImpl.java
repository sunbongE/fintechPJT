package com.orange.fintech.payment.service;

import com.orange.fintech.group.dto.GroupMembersDto;
import com.orange.fintech.group.dto.GroupMembersListDto;
import com.orange.fintech.group.service.GroupService;
import com.orange.fintech.payment.dto.CalculateResultDto;
import com.orange.fintech.payment.dto.TransactionDto;
import com.orange.fintech.payment.dto.YeojungDto;
import com.orange.fintech.payment.repository.TransactionQueryRepository;
import com.querydsl.core.types.dsl.BooleanExpression;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Slf4j
@Service
@Transactional
@RequiredArgsConstructor
public class CalculateServiceImpl implements CalculateService {

    private final GroupService groupService;
    private final TransactionQueryRepository transactionQueryRepository;

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

    /**
     * 1차 영수증 요청 금액 계산 type 에 따라 보낼 금액, 받을 금액 계산
     *
     * @param groupId
     * @param type SEND, RECEIVE
     * @param memberId 내 ID
     * @param otherMemberId 요청을 보낸/준 MEMBER ID
     * @return
     */
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

    /**
     * 최종 정산 계산기
     *
     * @param groupId
     * @param lastMemberId
     */
    public List<CalculateResultDto> finalCalculator(int groupId, String lastMemberId) {
        GroupMembersListDto listDto = groupService.findGroupMembers(groupId);

        List<Member> plus = new ArrayList<>();
        List<Member> minus = new ArrayList<>();

        int remainder = transactionQueryRepository.sumOfRemainder(groupId);

        for (GroupMembersDto dto : listDto.getGroupMembersDtos()) {
            long amount = sumOfTotalAmount(groupId, dto.getKakaoId());
            if (dto.getKakaoId().equals(lastMemberId)) {
                amount -= remainder;
            }

            if (amount >= 0) {
                plus.add(new Member(amount, dto.getKakaoId()));
            } else {
                minus.add(new Member(amount, dto.getKakaoId()));
            }
        }

        // 초기화
        minTransaction = new int[minus.size()];
        minTransactionCnt = Integer.MAX_VALUE;

        int[] p = new int[minus.size()];
        for (int i = 0; i < p.length; i++) {
            p[i] = i;
        }

        do {
            System.out.println(Arrays.toString(p));
            transactionSimulation(p, plus, minus);
            System.out.println("min: " + Arrays.toString(minTransaction));
        } while (np(p));

        // minTransaction 으로 누가 누구에게 얼마 보낼지 계산
        long[] remains = new long[plus.size()];
        for (int i = 0; i < plus.size(); i++) {
            remains[i] = plus.get(i).amount;
        }

        long[][] transaction = new long[plus.size()][minus.size()];

        int plusIdx = 0;
        for (int i = 0; i < minTransaction.length; i++) {
            long receiveAmount = remains[plusIdx];
            long sendAmount = minus.get(minTransaction[i]).amount;

            while (sendAmount > 0) {
                if (receiveAmount > sendAmount) {
                    transaction[plusIdx][i] += sendAmount;

                    remains[plusIdx] -= sendAmount;
                    sendAmount = 0;
                } else {
                    transaction[plusIdx][i] += receiveAmount;

                    sendAmount -= receiveAmount;
                    remains[plusIdx++] = 0;
                }
            }
        }

        List<CalculateResultDto> results = new ArrayList<>();

        log.info("transaction[i][j]: i -> j로 송금");
        for (int i = 0; i < transaction.length; i++) {
            log.info("transaction: {}", Arrays.toString(transaction[i]));
            for (int j = 0; j < transaction[0].length; j++) {
                if (transaction[i][j] != 0) {
                    results.add(
                            new CalculateResultDto(
                                    minus.get(i).kakaoId, plus.get(j).kakaoId, transaction[i][j]));
                }
            }
        }

        return results;
    }

    /**
     * 내가 총 내야할 금액 계산
     *
     * @param groupId
     * @param memberId
     * @return
     */
    public long sumOfTotalAmount(int groupId, String memberId) {
        long res = 0;

        BooleanExpression sendExpression =
                transactionQueryRepository.getSumOfTotalAmountCondition(groupId, memberId, "SEND");
        BooleanExpression receiveExpression =
                transactionQueryRepository.getSumOfTotalAmountCondition(
                        groupId, memberId, "RECEIVE");

        res -= transactionQueryRepository.sumOfTotalAmount(groupId, memberId, sendExpression);
        res += transactionQueryRepository.sumOfTotalAmount(groupId, memberId, receiveExpression);

        log.info("sumOfTotalAmount: {}", res);

        return res;
    }

    int minTransactionCnt = Integer.MAX_VALUE;
    int minTransaction[];

    @Override
    public void transactionSimulation(
            int[] np, List<CalculateService.Member> plus, List<CalculateService.Member> minus) {
        long[] remains = new long[plus.size()];
        for (int i = 0; i < plus.size(); i++) {
            remains[i] = plus.get(i).amount;
        }

        long[][] transaction = new long[minus.size()][plus.size()];
        int transactionCnt = 0;
        int plusIdx = 0;
        for (int i = 0; i < np.length; i++) {
            long receiveAmount = remains[plusIdx];
            long sendAmount = minus.get(np[i]).amount;

            while (sendAmount > 0) {
                if (receiveAmount > sendAmount) {
                    // 받아야하는 금액보다 줄 수 있는 금액이 많으면 다 주면 됨
                    transaction[i][plusIdx] += sendAmount;
                    remains[plusIdx] -= sendAmount;
                    sendAmount = 0;
                } else {
                    // 줄수있는만큼 주고 받을 사람 넘기기
                    transaction[i][plusIdx] += receiveAmount;

                    sendAmount -= receiveAmount;
                    remains[plusIdx] = 0;

                    plusIdx++;
                }
                transactionCnt++;
            }

            // transactionCnt가 min값 이상이면 더 이상 검사할 필요 없음
            if (transactionCnt >= minTransactionCnt) {
                return;
            }
        }

        if (transactionCnt < minTransactionCnt) {
            minTransactionCnt = transactionCnt;
            for (int i = 0; i < np.length; i++) {
                minTransaction[i] = np[i];
            }
        }
    }

    @Override
    public void transfer(List<CalculateResultDto> calResults, int groupId) {}

    private boolean np(int[] p) {
        int N = p.length;
        int i = N - 1;
        while (i > 0 && (p[i - 1] >= p[i])) i--;

        if (i == 0) {
            return false;
        }
        int j = N - 1;
        while ((p[i - 1] >= p[j])) j--;

        swap(p, i - 1, j);

        int k = N - 1;
        while (i < k) {
            swap(p, i++, k--);
        }

        return true;
    }

    private void swap(int[] p, int a, int b) {
        int tmp = p[a];
        p[a] = p[b];
        p[b] = tmp;
    }
}
