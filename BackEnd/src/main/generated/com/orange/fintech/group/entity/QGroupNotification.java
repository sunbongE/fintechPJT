package com.orange.fintech.group.entity;

import static com.querydsl.core.types.PathMetadataFactory.*;

import com.querydsl.core.types.dsl.*;

import com.querydsl.core.types.PathMetadata;
import javax.annotation.processing.Generated;
import com.querydsl.core.types.Path;
import com.querydsl.core.types.dsl.PathInits;


/**
 * QGroupNotification is a Querydsl query type for GroupNotification
 */
@Generated("com.querydsl.codegen.DefaultEntitySerializer")
public class QGroupNotification extends EntityPathBase<GroupNotification> {

    private static final long serialVersionUID = -1144705874L;

    private static final PathInits INITS = PathInits.DIRECT2;

    public static final QGroupNotification groupNotification = new QGroupNotification("groupNotification");

    public final StringPath content = createString("content");

    public final QGroup group;

    public final NumberPath<Integer> groupNotificationId = createNumber("groupNotificationId", Integer.class);

    public final DateTimePath<java.time.LocalDateTime> time = createDateTime("time", java.time.LocalDateTime.class);

    public final StringPath title = createString("title");

    public final EnumPath<com.orange.fintech.common.NotificationType> type = createEnum("type", com.orange.fintech.common.NotificationType.class);

    public QGroupNotification(String variable) {
        this(GroupNotification.class, forVariable(variable), INITS);
    }

    public QGroupNotification(Path<? extends GroupNotification> path) {
        this(path.getType(), path.getMetadata(), PathInits.getFor(path.getMetadata(), INITS));
    }

    public QGroupNotification(PathMetadata metadata) {
        this(metadata, PathInits.getFor(metadata, INITS));
    }

    public QGroupNotification(PathMetadata metadata, PathInits inits) {
        this(GroupNotification.class, metadata, inits);
    }

    public QGroupNotification(Class<? extends GroupNotification> type, PathMetadata metadata, PathInits inits) {
        super(type, metadata, inits);
        this.group = inits.isInitialized("group") ? new QGroup(forProperty("group")) : null;
    }

}

