package com.orange.fintech.member.entity;

import static com.querydsl.core.types.PathMetadataFactory.*;

import com.querydsl.core.types.dsl.*;

import com.querydsl.core.types.PathMetadata;
import javax.annotation.processing.Generated;
import com.querydsl.core.types.Path;
import com.querydsl.core.types.dsl.PathInits;


/**
 * QIndividualNotification is a Querydsl query type for IndividualNotification
 */
@Generated("com.querydsl.codegen.DefaultEntitySerializer")
public class QIndividualNotification extends EntityPathBase<IndividualNotification> {

    private static final long serialVersionUID = 1567788251L;

    private static final PathInits INITS = PathInits.DIRECT2;

    public static final QIndividualNotification individualNotification = new QIndividualNotification("individualNotification");

    public final StringPath content = createString("content");

    public final com.orange.fintech.group.entity.QGroup group;

    public final NumberPath<Integer> individualNotificationId = createNumber("individualNotificationId", Integer.class);

    public final QMember member;

    public final DateTimePath<java.time.LocalDateTime> time = createDateTime("time", java.time.LocalDateTime.class);

    public final StringPath title = createString("title");

    public final EnumPath<com.orange.fintech.common.NotificationType> type = createEnum("type", com.orange.fintech.common.NotificationType.class);

    public QIndividualNotification(String variable) {
        this(IndividualNotification.class, forVariable(variable), INITS);
    }

    public QIndividualNotification(Path<? extends IndividualNotification> path) {
        this(path.getType(), path.getMetadata(), PathInits.getFor(path.getMetadata(), INITS));
    }

    public QIndividualNotification(PathMetadata metadata) {
        this(metadata, PathInits.getFor(metadata, INITS));
    }

    public QIndividualNotification(PathMetadata metadata, PathInits inits) {
        this(IndividualNotification.class, metadata, inits);
    }

    public QIndividualNotification(Class<? extends IndividualNotification> type, PathMetadata metadata, PathInits inits) {
        super(type, metadata, inits);
        this.group = inits.isInitialized("group") ? new com.orange.fintech.group.entity.QGroup(forProperty("group")) : null;
        this.member = inits.isInitialized("member") ? new QMember(forProperty("member")) : null;
    }

}

