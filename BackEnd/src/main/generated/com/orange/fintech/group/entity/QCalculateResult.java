package com.orange.fintech.group.entity;

import static com.querydsl.core.types.PathMetadataFactory.*;

import com.querydsl.core.types.dsl.*;

import com.querydsl.core.types.PathMetadata;
import javax.annotation.processing.Generated;
import com.querydsl.core.types.Path;
import com.querydsl.core.types.dsl.PathInits;


/**
 * QCalculateResult is a Querydsl query type for CalculateResult
 */
@Generated("com.querydsl.codegen.DefaultEntitySerializer")
public class QCalculateResult extends EntityPathBase<CalculateResult> {

    private static final long serialVersionUID = 1996999623L;

    private static final PathInits INITS = PathInits.DIRECT2;

    public static final QCalculateResult calculateResult = new QCalculateResult("calculateResult");

    public final NumberPath<Long> amount = createNumber("amount", Long.class);

    public final NumberPath<Integer> calculateResultId = createNumber("calculateResultId", Integer.class);

    public final QGroup group;

    public final com.orange.fintech.member.entity.QMember receiveMember;

    public final com.orange.fintech.member.entity.QMember sendMember;

    public QCalculateResult(String variable) {
        this(CalculateResult.class, forVariable(variable), INITS);
    }

    public QCalculateResult(Path<? extends CalculateResult> path) {
        this(path.getType(), path.getMetadata(), PathInits.getFor(path.getMetadata(), INITS));
    }

    public QCalculateResult(PathMetadata metadata) {
        this(metadata, PathInits.getFor(metadata, INITS));
    }

    public QCalculateResult(PathMetadata metadata, PathInits inits) {
        this(CalculateResult.class, metadata, inits);
    }

    public QCalculateResult(Class<? extends CalculateResult> type, PathMetadata metadata, PathInits inits) {
        super(type, metadata, inits);
        this.group = inits.isInitialized("group") ? new QGroup(forProperty("group")) : null;
        this.receiveMember = inits.isInitialized("receiveMember") ? new com.orange.fintech.member.entity.QMember(forProperty("receiveMember")) : null;
        this.sendMember = inits.isInitialized("sendMember") ? new com.orange.fintech.member.entity.QMember(forProperty("sendMember")) : null;
    }

}

