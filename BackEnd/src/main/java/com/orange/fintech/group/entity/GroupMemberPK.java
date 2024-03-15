package com.orange.fintech.group.entity;

import com.orange.fintech.member.entity.Member;
import jakarta.persistence.Embeddable;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import java.io.Serializable;
import lombok.*;

@Embeddable
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@EqualsAndHashCode
public class GroupMemberPK implements Serializable {

    @ManyToOne
    @JoinColumn(name = "kakao_id")
    private Member member;

    @ManyToOne
    @JoinColumn(name = "group_id")
    private Group group;
}
