package com.orange.fintech.payment.service;

import com.orange.fintech.account.entity.Account;
import com.orange.fintech.account.repository.AccountRepository;
import com.orange.fintech.account.service.AccountService;
import com.orange.fintech.group.dto.GroupMembersDto;
import com.orange.fintech.group.dto.GroupMembersListDto;
import com.orange.fintech.group.entity.*;
import com.orange.fintech.group.repository.CalculateResultRepository;
import com.orange.fintech.group.repository.GroupMemberRepository;
import com.orange.fintech.group.repository.GroupRepository;
import com.orange.fintech.group.service.GroupService;
import com.orange.fintech.member.entity.Member;
import com.orange.fintech.member.repository.MemberRepository;
import com.orange.fintech.notification.Dto.MessageListDataReqDto;
import com.orange.fintech.notification.entity.NotificationType;
import com.orange.fintech.notification.service.FcmService;
import com.orange.fintech.payment.dto.CalculateResultDto;
import com.orange.fintech.payment.dto.TransactionDto;
import com.orange.fintech.payment.dto.YeojungDto;
import com.orange.fintech.payment.repository.TransactionQueryRepository;
import com.querydsl.core.types.dsl.BooleanExpression;
import java.io.IOException;
import java.util.*;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Slf4j
@Service
@RequiredArgsConstructor
public class CalculateServiceImpl implements CalculateService {

    private final AccountService accountService;
    private final AccountRepository accountRepository;
    private final GroupService groupService;
    private final FcmService fcmService;
    private final GroupMemberRepository groupMemberRepository;
    private final TransactionQueryRepository transactionQueryRepository;
    private final MemberRepository memberRepository;
    private final GroupRepository groupRepository;
    private final CalculateResultRepository calculateResultRepository;

    @Value("${ssafy.bank.transfer")
    private String transferUri;

    /**
     * memberId가 다른 그룹원들에게 얼마를 주고받아야하는지
     *
     * @param groupId
     * @param memberId 여정 페이지의 주인
     */
    @Transactional
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
            yeojungDto.setReceiveAmount(
                    transactionQueryRepository.getReceiveAmount(
                            memberId, dto.getKakaoId(), groupId));

            // 보낼 금액 계산
            yeojungDto.setSendAmount(
                    transactionQueryRepository.getReceiveAmount(
                            dto.getKakaoId(), memberId, groupId));

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
    @Transactional
    public List<TransactionDto> getRequest(
            int groupId, String type, String memberId, String otherMemberId) {
        if (type.equals("SEND")) {
            return getReceivedRequest(groupId, memberId, otherMemberId);
        } else {
            return getSendRequest(groupId, memberId, otherMemberId);
        }
    }

    @Transactional
    private List<TransactionDto> getReceivedRequest(
            int groupId, String memberId, String otherMemberId) {
        List<TransactionDto> list =
                transactionQueryRepository.getReceivedRequest(groupId, memberId, otherMemberId);

        return list;
    }

    @Transactional
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
    public List<CalculateResultDto> finalCalculator(int groupId, String lastMemberId)
            throws ParseException, IOException, RuntimeException {
        GroupMembersListDto listDto = groupService.findGroupMembers(groupId);

        List<CalMember> plus = new ArrayList<>(); // 돈을 받아야하는 인원
        List<CalMember> minus = new ArrayList<>(); // 돈을 줘야하는 인원
        Group group = groupRepository.findById(groupId).get();

        int remainder = transactionQueryRepository.sumOfRemainder(groupId);

        for (GroupMembersDto dto : listDto.getGroupMembersDtos()) {
            long amount = sumOfTotalAmount(groupId, dto.getKakaoId());
            amount += transactionQueryRepository.sumOfMyRemainder(groupId, dto.getKakaoId());

            if (dto.getKakaoId().equals(lastMemberId)) {
                amount -= remainder;
            }

            // 주고받을 금액이 없는 사람?
            if (amount > 0) {
                plus.add(new CalMember(amount, dto.getKakaoId()));
            } else if (amount < 0) {
                minus.add(new CalMember(amount, dto.getKakaoId()));
            }
        }

        if (plus.size() == 0 || minus.size() == 0) {
            return null;
        }

        // Todo 여기임!!!!!!!!! ==> 돈을 보내야하는 인원의 계좌를 확인 후 잔액이 부족한 회원 기록 후, 비동기로 알림을 보낸다. 테스트해봐야함!

        JSONParser parser = new JSONParser();
        List<String> noMoneysKakaoId = new ArrayList<>();

        for (CalMember member : minus) {
            Optional<Member> opMember = memberRepository.findById(member.kakaoId);
            Member curMember = null;
            if (opMember.isPresent()) {
                curMember = opMember.get();
            }

            Account pAccount = accountRepository.findByMemberAndIsPrimaryAccountIsTrue(curMember);
            String result = accountService.inquireAccountBalance(curMember, pAccount);
            JSONObject jsonObject = (JSONObject) parser.parse(result);
            JSONObject data = (JSONObject) jsonObject.get("REC");
            String balanceString = (String) data.get("accountBalance");
            Long balance = Long.parseLong(balanceString);

            // 잔액이 부족한 놈 아이디 저장함.
            if (balance + member.amount < 0) {
                //                log.info("CalculateServiceImpl 잔액 부족한 상태!!");
                noMoneysKakaoId.add(member.kakaoId);
                // 해당 그룹에서 회원의 2차 정산 상태를 변경한다.

                Member noMoneyMember = memberRepository.findByKakaoId(member.kakaoId);

                GroupMemberPK groupMemberPK = new GroupMemberPK();
                groupMemberPK.setGroup(group);
                groupMemberPK.setMember(noMoneyMember);

                GroupMember groupMember = groupMemberRepository.findById(groupMemberPK).get();
                groupMember.setSecondCallDone(false);
                groupMemberRepository.save(groupMember);
                //                log.info("===============>>>>>>>>>>>>>>>groupMember : {}, {}",
                // groupMember.getGroupMemberPK().getMember().getName(),groupMember.getSecondCallDone());
            }
        }
        // 돈이 부족한 사람이 있으면 fcm호출하고 정산을 종료한다.
        if (!noMoneysKakaoId.isEmpty()) {
            fcmService.noMoneyFcm(noMoneysKakaoId, groupId);
            throw new RuntimeException();
            //            return null;

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
        } while (np(p));

        // minTransaction 으로 누가 누구에게 얼마 보낼지 계산
        long[] remains = new long[plus.size()];
        for (int i = 0; i < plus.size(); i++) {
            remains[i] = plus.get(i).amount;
        }

        long[][] transaction = new long[minus.size()][plus.size()];

        int plusIdx = 0;
        for (int i = 0; i < transaction.length; i++) {
            long receiveAmount = remains[plusIdx];
            long sendAmount = -minus.get(minTransaction[i]).amount;

            while (sendAmount > 0) {
                if (receiveAmount > sendAmount) {
                    transaction[i][plusIdx] += sendAmount;
                    remains[plusIdx] -= sendAmount;
                    sendAmount = 0;
                } else {
                    transaction[i][plusIdx] += receiveAmount;
                    sendAmount -= receiveAmount;
                    remains[plusIdx++] = 0;
                }
            }
        }

        List<CalculateResultDto> results = new ArrayList<>();

        for (int i = 0; i < transaction.length; i++) {
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
    @Transactional
    public long sumOfTotalAmount(int groupId, String memberId) {
        long res = 0;

        BooleanExpression sendExpression =
                transactionQueryRepository.getSumOfTotalAmountCondition(groupId, memberId, "SEND");
        BooleanExpression receiveExpression =
                transactionQueryRepository.getSumOfTotalAmountCondition(
                        groupId, memberId, "RECEIVE");

        res -= transactionQueryRepository.sumOfTotalAmount(groupId, memberId, sendExpression);
        res += transactionQueryRepository.sumOfTotalAmount(groupId, memberId, receiveExpression);

        log.info("memberId: {} sumOfTotalAmount: {}", memberId, res);

        return res;
    }

    int minTransactionCnt = Integer.MAX_VALUE;
    int minTransaction[];

    @Override
    @Transactional
    public void transactionSimulation(int[] np, List<CalMember> plus, List<CalMember> minus) {
        long[] remains = new long[plus.size()];
        for (int i = 0; i < plus.size(); i++) {
            remains[i] = plus.get(i).amount;
        }

        long[][] transaction = new long[minus.size()][plus.size()];

        int transactionCnt = 0;
        int plusIdx = 0;
        for (int i = 0; i < minus.size(); i++) {
            long receiveAmount = remains[plusIdx];
            long sendAmount = -minus.get(np[i]).amount;

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
                    remains[plusIdx++] = 0;
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
    @Transactional
    public void transfer(List<CalculateResultDto> calResults, int groupId) throws IOException {
        // 회원 목록
        HashMap<String, String> getdistinctMemberId = new HashMap<>();
        // 송금
        for (CalculateResultDto calResult : calResults) {
            accountService.transfer(
                    calResult.getSendMemberId(),
                    calResult.getReceiveMemberId(),
                    calResult.getAmount());
            getdistinctMemberId.put(calResult.getReceiveMemberId(), calResult.getReceiveMemberId());
            getdistinctMemberId.put(calResult.getSendMemberId(), calResult.getSendMemberId());
            log.info("transfer: {} -> {}", calResult.getSendMemberId(), calResult.getReceiveMemberId());
        }

        Group group = groupRepository.findById(groupId).get();

        // 송금 후 저장
        for (CalculateResultDto calResult : calResults) {
            CalculateResult calculateResult = new CalculateResult();
            calculateResult.setGroup(group);
            calculateResult.setAmount(calResult.getAmount());
            calculateResult.setSendMember(
                    memberRepository.findById(calResult.getSendMemberId()).get());
            calculateResult.setReceiveMember(
                    memberRepository.findById(calResult.getReceiveMemberId()).get());
            calculateResultRepository.save(calculateResult);
            log.info("calculateResultSave: {}", calculateResult);
        }

        group.setGroupStatus(GroupStatus.DONE);
        groupRepository.save(group);

        // 정산했던 회원들 아이디 추출
        Collection<String> distinctMemberId = getdistinctMemberId.values();
        List<String> calculateMembers = new ArrayList<>(distinctMemberId);

        MessageListDataReqDto messageListDataReqDto = new MessageListDataReqDto();
        messageListDataReqDto.setTargetMembers(calculateMembers);
        messageListDataReqDto.setGroupId(groupId);
        messageListDataReqDto.setNotificationType(NotificationType.TRANSFER);
        fcmService.pushListDataMSG(messageListDataReqDto);
    }

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
