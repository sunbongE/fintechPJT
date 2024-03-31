// package com.orange.fintech.auth.service;
//
// import com.orange.fintech.account.entity.Account;
// import com.orange.fintech.account.repository.AccountRepository;
// import com.orange.fintech.account.service.AccountService;
// import com.orange.fintech.group.entity.Group;
// import com.orange.fintech.group.entity.GroupMember;
// import com.orange.fintech.group.entity.GroupMemberPK;
// import com.orange.fintech.group.repository.GroupMemberRepository;
// import com.orange.fintech.member.entity.Member;
// import com.orange.fintech.member.repository.MemberRepository;
//
// import java.io.IOException;
// import java.util.ArrayList;
// import java.util.List;
// import java.util.Optional;
//
// import com.orange.fintech.notification.Dto.MessageListDataReqDto;
// import com.orange.fintech.notification.entity.NotificationType;
// import com.orange.fintech.notification.repository.NotificationQueryRepository;
// import com.orange.fintech.notification.service.FcmService;
// import lombok.extern.slf4j.Slf4j;
// import org.json.simple.JSONObject;
// import org.json.simple.parser.JSONParser;
// import org.json.simple.parser.ParseException;
// import org.springframework.beans.factory.annotation.Autowired;
// import org.springframework.http.ResponseEntity;
// import org.springframework.scheduling.annotation.Async;
// import org.springframework.stereotype.Service;
//
// @Service
// @Slf4j
// public class TestService {
//    @Autowired MemberRepository memberRepository;
//    @Autowired AccountRepository accountRepository;
//    @Autowired AccountService accountService;
//    @Autowired
//    GroupMemberRepository groupMemberRepository;
//    @Autowired
//    FcmService fcmService;
//    @Autowired
//    NotificationQueryRepository notificationQueryRepository;
//
//    public class CalMemberTest {
//        long amount;
//        String kakaoId;
//
//        public CalMemberTest(long amount, String kakaoId) {
//            this.amount = amount;
//            this.kakaoId = kakaoId;
//        }
//    }
//
//    @Async
//    public void test() throws ParseException, IOException {
//        List<CalMemberTest> minus = new ArrayList<>();
//        minus.add(new CalMemberTest((long) -1999990000, "3386029769"));
//        minus.add(new CalMemberTest((long) -100, "3412806386"));
//        //
//        JSONParser parser = new JSONParser();
//
//        List<String> noMoneysKakaoId = new ArrayList<>();
//
//        String result = null;
//        for (CalMemberTest member : minus) {
//            Optional<Member> opMember = memberRepository.findById(member.kakaoId);
//            Member curMember = null;
//            if (opMember.isPresent()) {
//                curMember = opMember.get();
//            }
//
//            Account pAccount = accountRepository.findByMemberAndIsPrimaryAccountIsTrue(curMember);
//            result = accountService.inquireAccountBalance(curMember, pAccount);
//            JSONObject jsonObject = (JSONObject) parser.parse(result);
//            JSONObject data = (JSONObject) jsonObject.get("REC");
//            String balanceString = (String) data.get("accountBalance");
//            Long balance = Long.parseLong(balanceString);
//
//            // 잔액이 부족한 놈 아이디 저장함.
//            if (balance + member.amount < 0) {
//                noMoneysKakaoId.add(member.kakaoId);
//        // 해당 그룹에서 회원의 2차 정산 상태를 변경한다.
//                GroupMemberPK groupMemberPK = new GroupMemberPK();
//                Group group = new Group();
//                group.setGroupId(22);
//                Member noMoneyMember = new Member();
//                noMoneyMember.setKakaoId(member.kakaoId);
//                groupMemberPK.setGroup(group);
//                groupMemberPK.setMember(noMoneyMember);
//                GroupMember groupMember = groupMemberRepository.findById(groupMemberPK).get();
//                groupMember.setSecondCallDone(false);
//                groupMemberRepository.save(groupMember);
//            }
//        }
//        // Todo : noMoneyList.size()가 0이 아니면 return 해버리고 여기부터 비동기하면 돼
//        // fcm보낸거.
//        MessageListDataReqDto messageListDataReqDto = new MessageListDataReqDto();
//        messageListDataReqDto.setTargetMembers(noMoneysKakaoId);
//        messageListDataReqDto.setGroupId(22);
//        messageListDataReqDto.setNotificationType(NotificationType.NO_MONEY);
//
//        fcmService.pushListDataMSG(messageListDataReqDto);
//
//
////        return ResponseEntity.ok().body(noMoneysKakaoId);
//    }
// }
