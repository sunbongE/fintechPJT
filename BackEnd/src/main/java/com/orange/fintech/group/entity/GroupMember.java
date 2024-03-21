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

    @ColumnDefault("true")
    Boolean state;

    @ColumnDefault("false")
    Boolean fistCallDone;

    @ColumnDefault("false")
    Boolean secondCallDone;
}
