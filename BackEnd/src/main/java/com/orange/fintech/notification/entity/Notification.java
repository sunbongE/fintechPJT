package com.orange.fintech.notification.entity;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.fasterxml.jackson.annotation.JsonIgnore;
import com.orange.fintech.group.entity.Group;
import com.orange.fintech.member.entity.Member;
import jakarta.persistence.*;
import jakarta.validation.constraints.NotNull;
import java.time.LocalDateTime;
import lombok.Getter;
import lombok.Setter;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.OnDelete;
import org.hibernate.annotations.OnDeleteAction;

@Entity
@Getter
@Setter
@Table(name = "individual_notification")
public class Notification {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int individualNotificationId;

    @JsonIgnore()
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "kakao_id")
    @OnDelete(action = OnDeleteAction.CASCADE)
    private Member member;

    @NotNull
    @JsonIgnore
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "group_id")
    @OnDelete(action = OnDeleteAction.CASCADE)
    private Group group;

    @NotNull
    @Column(length = 15)
    private String title;

    @NotNull
    @Column(length = 50)
    private String content;

    @NotNull
    @JsonFormat(
            shape = JsonFormat.Shape.STRING,
            pattern = "yyyy-MM-dd HH:mm:ss",
            timezone = "Asia/Seoul")
    @CreationTimestamp
    private LocalDateTime time;

    @NotNull
    @Enumerated(EnumType.STRING)
    private NotificationType type;

    public Notification() {}

    public Notification(
            Member memeber,
            NotificationType notificationType,
            int groupId,
            String title,
            String content) {
        //        System.out.println("content = " + content);
        this.member = memeber;
        this.type = notificationType;
        Group tmp = new Group();
        tmp.setGroupId(groupId);
        this.group = tmp;
        this.title = title;
        this.content = content;
    }
}
