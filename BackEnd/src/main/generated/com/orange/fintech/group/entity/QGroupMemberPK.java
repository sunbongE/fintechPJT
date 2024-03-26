package com.orange.fintech.group.entity;

import static com.querydsl.core.types.PathMetadataFactory.*;

import com.querydsl.core.types.dsl.*;

import com.querydsl.core.types.PathMetadata;
import javax.annotation.processing.Generated;
import com.querydsl.core.types.Path;
import com.querydsl.core.types.dsl.PathInits;


/**
 * QGroupMemberPK is a Querydsl query type for GroupMemberPK
 */
@Generated("com.querydsl.codegen.DefaultEmbeddableSerializer")
public class QGroupMemberPK extends BeanPath<GroupMemberPK> {

    private static final long serialVersionUID = 816534360L;

    private static final PathInits INITS = PathInits.DIRECT2;

    public static final QGroupMemberPK groupMemberPK = new QGroupMemberPK("groupMemberPK");

    public final QGroup group;

    public final com.orange.fintech.member.entity.QMember member;

    public QGroupMemberPK(String variable) {
        this(GroupMemberPK.class, forVariable(variable), INITS);
    }

    public QGroupMemberPK(Path<? extends GroupMemberPK> path) {
        this(path.getType(), path.getMetadata(), PathInits.getFor(path.getMetadata(), INITS));
    }

    public QGroupMemberPK(PathMetadata metadata) {
        this(metadata, PathInits.getFor(metadata, INITS));
    }

    public QGroupMemberPK(PathMetadata metadata, PathInits inits) {
        this(GroupMemberPK.class, metadata, inits);
    }

    public QGroupMemberPK(Class<? extends GroupMemberPK> type, PathMetadata metadata, PathInits inits) {
        super(type, metadata, inits);
        this.group = inits.isInitialized("group") ? new QGroup(forProperty("group")) : null;
        this.member = inits.isInitialized("member") ? new com.orange.fintech.member.entity.QMember(forProperty("member")) : null;
    }

}

