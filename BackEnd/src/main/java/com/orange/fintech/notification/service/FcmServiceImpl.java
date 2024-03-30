package com.orange.fintech.notification.service;

import com.orange.fintech.common.notification.NotificationResponseDescription;
import com.orange.fintech.common.notification.NotificationResponseTitle;
import com.orange.fintech.group.entity.Group;
import com.orange.fintech.group.repository.GroupQueryRepository;
import com.orange.fintech.member.entity.Member;
import com.orange.fintech.member.repository.MemberRepository;
import com.orange.fintech.notification.Dto.FCMMessageDto;
import com.orange.fintech.notification.Dto.MessageListDataReqDto;
import com.orange.fintech.notification.Dto.UrgeTargetDto;
import com.orange.fintech.notification.FcmSender;
import com.orange.fintech.notification.entity.Notification;
import com.orange.fintech.notification.entity.NotificationType;
import com.orange.fintech.notification.repository.NotificationQueryRepository;
import com.orange.fintech.notification.repository.NotificationRepository;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.scheduling.annotation.Async;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Slf4j
@Service
@Transactional
public class FcmServiceImpl implements FcmService {

    @Autowired MemberRepository memberRepository;
    @Autowired FcmSender fcmSender;
    @Autowired GroupQueryRepository groupQueryRepository;
    @Autowired NotificationRepository notificationRepository;
    @Autowired NotificationQueryRepository notificationQueryRepository;

    @Override
    public void pushListDataMSG(MessageListDataReqDto dto, String memberId) throws IOException {
        // fcmToken이 없는 사람은 없다고 알려줘야하는데 이건 DB에만 알려줘야겠다.
        // 토큰이 없는 경우는 없다고 가정한다.

        //        if (!groupRepository.existsById(dto.getGroupId())) {
        //            return ResponseEntity.badRequest().body(BaseResponseBody.of(400, "그룹이 없습니다"));
        //        }
        String sender = memberRepository.findById(memberId).get().getName();

        List<String> kakaoIdList = dto.getTargetMembers();
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
                                (sender + NotificationResponseDescription.INVITE));
                notificationRepository.save(notification);
            }
            // FCM 보내기
            Map<String, String> dataSet = new HashMap<>();
            dataSet.put("groupId", String.valueOf(dto.getGroupId()));
            dataSet.put("type", NotificationResponseTitle.INVITE);

            for (String fcmToken : inviteMembersFcmToken) {
                FCMMessageDto fcmMessageDto =
                        new FCMMessageDto(
                                fcmToken,
                                NotificationResponseTitle.INVITE,
                                (sender + NotificationResponseDescription.INVITE),
                                dataSet);
                fcmSender.sendMessageTo(fcmMessageDto);
            }
        }
        //        log.info("fcm {}번 발생 ",cnt,sender);
        //        return ResponseEntity.ok().body(BaseResponseBody.of(200, "DB저장 후, FCM 보냈습니다."));
    }

    /**
     * MEMBERID가 필요없는 알림.
     *
     * @param dto
     * @throws IOException
     */
    @Override
    public void pushListDataMSG(MessageListDataReqDto dto) throws IOException {
        List<String> kakaoIdList = dto.getTargetMembers();
        List<String> inviteMembersFcmToken =
                notificationQueryRepository.getMembersFcmToken(kakaoIdList);

        String sendGroup = groupQueryRepository.getGroupName(dto.getGroupId());

        //        log.info("sendGroup => {}", sendGroup);
        //         firstCall인경우

        if (dto.getNotificationType().equals(NotificationType.SPLIT)) {
            // DB에 저장
            for (String kakaoId : kakaoIdList) {
                Member member = memberRepository.findById(kakaoId).get();
                Notification notification =
                        new Notification(
                                member,
                                dto.getNotificationType(),
                                dto.getGroupId(),
                                NotificationResponseTitle.SPLIT,
                                (sendGroup + NotificationResponseDescription.SPLIT));
                notificationRepository.save(notification);
            }
            // FCM 보내기

            // 필요한 데이터 입력부.
            Map<String, String> dataSet = new HashMap<>();
            dataSet.put("groupId", String.valueOf(dto.getGroupId()));
            dataSet.put("type", NotificationResponseTitle.SPLIT);

            for (String fcmToken : inviteMembersFcmToken) {
                FCMMessageDto fcmMessageDto =
                        new FCMMessageDto(
                                fcmToken,
                                NotificationResponseTitle.SPLIT,
                                (sendGroup + NotificationResponseDescription.SPLIT),
                                dataSet);
                fcmSender.sendMessageTo(fcmMessageDto);
            }
        }
    }

    @Override
    public ResponseEntity<?> getIndividualNotification(String memberId) {
        Member member = new Member();
        member.setKakaoId(memberId);
        List<Notification> individualNotifications = notificationRepository.findAllByMember(member);

        return ResponseEntity.ok().body(individualNotifications);
    }

    /** 여행이 끝난 그룹중에서 정산을 완료안한 사람들에게 알림을 보낸다. */
    @Async
    @Scheduled(cron = "0 0 12 * * ?")
    public void sendToLunch() throws IOException {
        // 그룹중에서 정산이 안끝났는데 여행 기간이 지난 그룹을 전부 뽑아온다.
        List<UrgeTargetDto> allUrgedata = groupQueryRepository.findAllUrgeFcmtoken();
        MessageListDataReqDto messageListDataReqDto = new MessageListDataReqDto();

        pushListDataMSG(allUrgedata);
    }

    @Override
    public void pushListDataMSG(List<UrgeTargetDto> urgeTargetDtoList) throws IOException {
        NotificationType type = NotificationType.URGE;

        for (UrgeTargetDto data : urgeTargetDtoList) {
            String urgeFcm = data.getFcmToken();
            int groupId = data.getGroupMemberPK().getGroup().getGroupId();
            String memberId = data.getGroupMemberPK().getMember().getKakaoId();
            String title = NotificationResponseTitle.URGE;
            Member member = data.getGroupMemberPK().getMember();
            Group group = data.getGroupMemberPK().getGroup();
            String content =
                    group.getGroupName()
                            + "에서 "
                            + member.getName()
                            + NotificationResponseDescription.URGE;

            // Todo : db저장.
            Notification notification = new Notification();
            notification.setType(type);
            notification.setGroup(group);
            notification.setMember(member);
            notification.setTitle(title);
            notification.setContent(content);

            notificationRepository.save(notification);

            // Todo : 여기서 이제 재촉하기 알림을 보내면 돼
            FCMMessageDto fcmMessageDto = new FCMMessageDto();
            Map<String, String> dataSet = new HashMap<>();
            dataSet.put("groupId", String.valueOf(groupId));
            dataSet.put("type", type.toString());

            fcmMessageDto.setData(dataSet);
            fcmMessageDto.setTitle(title);
            fcmMessageDto.setBody(content);
            fcmMessageDto.setTargetToken(data.getFcmToken());
            fcmSender.sendMessageTo(fcmMessageDto);
        }
    }
}
