package com.orange.fintech.payment.service;

import com.orange.fintech.payment.dto.CalculateResultDto;
import com.orange.fintech.payment.dto.TransactionDto;
import com.orange.fintech.payment.dto.YeojungDto;
import java.io.IOException;
import java.util.List;
import lombok.ToString;
import org.json.simple.parser.ParseException;

public interface CalculateService {

    public List<YeojungDto> yeojungCalculator(int groupId, String memberId);

    public List<TransactionDto> getRequest(
            int groupId, String type, String memberId, String otherMemberId);

    public List<CalculateResultDto> finalCalculator(int groupId, String lastMemberId)
            throws ParseException, IOException, RuntimeException;

    public long sumOfTotalAmount(int groupId, String memberId);

    public void transactionSimulation(int[] np, List<CalMember> plus, List<CalMember> minus);

    public void transfer(List<CalculateResultDto> calResults, int groupId) throws IOException;

    @ToString
    public class CalMember {
        long amount;
        String kakaoId;

        public CalMember(long amount, String kakaoId) {
            this.amount = amount;
            this.kakaoId = kakaoId;
        }
    }
}
