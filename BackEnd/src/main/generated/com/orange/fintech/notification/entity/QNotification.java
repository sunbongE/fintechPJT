package com.orange.fintech.notification.entity;

import static com.querydsl.core.types.PathMetadataFactory.*;

import com.querydsl.core.types.dsl.*;

import com.querydsl.core.types.PathMetadata;
import javax.annotation.processing.Generated;
import com.querydsl.core.types.Path;
import com.querydsl.core.types.dsl.PathInits;


/**
 * QNotification is a Querydsl query type for Notification
 */
@Generated("com.querydsl.codegen.DefaultEntitySerializer")
public class QNotification extends EntityPathBase<Notification> {

    private static final long serialVersionUID = -1668372429L;

    private static final PathInits INITS = PathInits.DIRECT2;

    public static final QNotification notification = new QNotification("notification");

    public final StringPath content = createString("content");

    public final com.orange.fintech.group.entity.QGroup group;

    public final NumberPath<Integer> individualNotificationId = createNumber("individualNotificationId", Integer.class);

    public final com.orange.fintech.member.entity.QMember member;

    public final DateTimePath<java.time.LocalDateTime> time = createDateTime("time", java.time.LocalDateTime.class);

    public final StringPath title = createString("title");

    public final EnumPath<NotificationType> type = createEnum("type", NotificationType.class);

    public QNotification(String variable) {
        this(Notification.class, forVariable(variable), INITS);
    }

    public QNotification(Path<? extends Notification> path) {
        this(path.getType(), path.getMetadata(), PathInits.getFor(path.getMetadata(), INITS));
    }

    public QNotification(PathMetadata metadata) {
        this(metadata, PathInits.getFor(metadata, INITS));
    }

    public QNotification(PathMetadata metadata, PathInits inits) {
        this(Notification.class, metadata, inits);
    }

    public QNotification(Class<? extends Notification> type, PathMetadata metadata, PathInits inits) {
        super(type, metadata, inits);
        this.group = inits.isInitialized("group") ? new com.orange.fintech.group.entity.QGroup(forProperty("group")) : null;
        this.member = inits.isInitialized("member") ? new com.orange.fintech.member.entity.QMember(forProperty("member")) : null;
    }

}

