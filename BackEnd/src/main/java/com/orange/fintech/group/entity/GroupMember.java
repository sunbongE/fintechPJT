package com.orange.fintech.group.entity;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;
import org.hibernate.annotations.ColumnDefault;
import org.hibernate.annotations.DynamicInsert;

@Entity
@Getter
@Setter
@DynamicInsert
public class GroupMember {

    @EmbeddedId private GroupMemberPK groupMemberPK;

    @Column(nullable = false)
    @ColumnDefault("true")
    Boolean state;

    @Column(nullable = false)
    @ColumnDefault("false")
    Boolean fistCallDone;

    @Column(nullable = false)
    @ColumnDefault("false")
    Boolean secondCallDone;
}
