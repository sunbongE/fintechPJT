package com.orange.fintech.group.entity;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;
import org.hibernate.annotations.ColumnDefault;

@Entity
@Getter
@Setter
public class GroupMember {

    @EmbeddedId
    private GroupMemberPK groupMemberPK;

    @ColumnDefault("true")
    Boolean state;

    @ColumnDefault("false")
    Boolean fistCallDone;

    @ColumnDefault("false")
    Boolean secondCallDone;
}
