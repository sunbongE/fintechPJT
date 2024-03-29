package com.orange.fintech.payment.service;

import com.orange.fintech.payment.dto.CalculateResultDto;
import com.orange.fintech.payment.dto.TransactionDto;
import com.orange.fintech.payment.dto.YeojungDto;
import java.util.List;

public interface CalculateService {

    public List<YeojungDto> yeojungCalculator(int groupId, String memberId);

    public List<TransactionDto> getRequest(
            int groupId, String type, String memberId, String otherMemberId);

    public List<CalculateResultDto> finalCalculator(int groupId, String lastMemberId);

    public long sumOfTotalAmount(int groupId, String memberId);

    public void transactionSimulation(int[] np, List<Member> plus, List<Member> minus);

    public void transfer(List<CalculateResultDto> calResults, int groupId);

    public class Member {
        long amount;
        String kakaoId;

        public Member(long amount, String kakaoId) {
            this.amount = amount;
            this.kakaoId = kakaoId;
        }
    }
}
