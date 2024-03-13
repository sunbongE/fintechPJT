package com.orange.fintech.member.entity;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.orange.fintech.group.entity.Group;
import jakarta.persistence.*;
import jakarta.validation.constraints.NotNull;
import java.time.LocalDateTime;
import lombok.Getter;
import lombok.Setter;

@Entity
@Getter
@Setter
public class IndividualNotification {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int individualNotificationId;

    @ManyToOne
    @JoinColumn(name = "member_id")
    private Member member;

    @NotNull
    @ManyToOne
    @JoinColumn(name = "group_id")
    private Group group;

    @NotNull
    @Column(length = 15)
    private String title;

    @NotNull
    @Column(length = 30)
    private String content;

    @NotNull
    @JsonFormat(
            shape = JsonFormat.Shape.STRING,
            pattern = "yyyyMMdd HHmmss",
            timezone = "Asia/Seoul")
    private LocalDateTime time;

    public enum NotificationType {
        TYPE_A,
        TYPE_B,
        TYPE_C
    }

    @NotNull
    @Enumerated(EnumType.STRING)
    private NotificationType type;
}
