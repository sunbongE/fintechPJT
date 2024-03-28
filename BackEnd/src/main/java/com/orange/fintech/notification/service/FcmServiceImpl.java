package com.orange.fintech.notification.service;

import com.orange.fintech.common.BaseResponseBody;
import com.orange.fintech.common.notification.NotificationResponseDescription;
import com.orange.fintech.common.notification.NotificationResponseTitle;
import com.orange.fintech.group.repository.GroupRepository;
import com.orange.fintech.member.entity.Member;
import com.orange.fintech.member.repository.MemberRepository;
import com.orange.fintech.notification.Dto.messageListDataReqDto;
import com.orange.fintech.notification.FcmSender;
import com.orange.fintech.notification.entity.Notification;
import com.orange.fintech.notification.entity.NotificationType;
import com.orange.fintech.notification.repository.NotificationQueryRepository;
import com.orange.fintech.notification.repository.NotificationRepository;
import java.io.IOException;
import java.util.List;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Slf4j
@Service
@Transactional
public class FcmServiceImpl implements FcmService {

    @Autowired MemberRepository memberRepository;
    @Autowired FcmSender fcmSender;
    @Autowired GroupRepository groupRepository;
    @Autowired NotificationRepository notificationRepository;
    @Autowired NotificationQueryRepository notificationQueryRepository;

    @Override
    public ResponseEntity<?> pushListDataMSG(messageListDataReqDto dto, String memberId)
            throws IOException {
        // fcmToken이 없는 사람은 없다고 알려줘야하는데 이건 DB에만 알려줘야겠다.
        // 토큰이 없는 경우는 없다고 가정한다.

        if (!groupRepository.existsById(dto.getGroupId())) {
            return ResponseEntity.badRequest().body(BaseResponseBody.of(400, "그룹이 없습니다"));
        }
        String sender = memberRepository.findById(memberId).get().getName();


        List<String> kakaoIdList = dto.getInviteMembers();
        List<String> inviteMembersFcmToken =
                notificationQueryRepository.getMembersFcmToken(kakaoIdList);


        // 그룹초대인경우.
        if (dto.getNotificationType().equals(NotificationType.INVITE)) {
            // DB에 저장
            for (String kakaoId : kakaoIdList) {
                Member member = memberRepository.findById(kakaoId).get();
                Notification notification =
                        new Notification(
                                member,
                                dto.getNotificationType(),
                                dto.getGroupId(),
                                NotificationResponseTitle.INVITE,
                                (sender+NotificationResponseDescription.INVITE));
                notificationRepository.save(notification);
            }
            // FCM 보내기
            for (String fcmToken : inviteMembersFcmToken) {
                fcmSender.sendMessageTo(
                        fcmToken,
                        NotificationResponseTitle.INVITE,
                        (sender+NotificationResponseDescription.INVITE));
            }
        }
//        log.info("fcm {}번 발생 ",cnt,sender);
        return ResponseEntity.ok().body(BaseResponseBody.of(200, "DB저장 후, FCM 보냈습니다."));
    }
}
