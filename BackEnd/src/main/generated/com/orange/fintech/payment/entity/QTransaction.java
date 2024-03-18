package com.orange.fintech.payment.entity;

import static com.querydsl.core.types.PathMetadataFactory.*;

import com.querydsl.core.types.dsl.*;

import com.querydsl.core.types.PathMetadata;
import javax.annotation.processing.Generated;
import com.querydsl.core.types.Path;
import com.querydsl.core.types.dsl.PathInits;


/**
 * QTransaction is a Querydsl query type for Transaction
 */
@Generated("com.querydsl.codegen.DefaultEntitySerializer")
public class QTransaction extends EntityPathBase<Transaction> {

    private static final long serialVersionUID = 945049243L;

    private static final PathInits INITS = PathInits.DIRECT2;

    public static final QTransaction transaction = new QTransaction("transaction");

    public final com.orange.fintech.member.entity.QAccount account;

    public final com.orange.fintech.group.entity.QGroup group;

    public final com.orange.fintech.member.entity.QMember member;

    public final NumberPath<Long> transactionAfterBalance = createNumber("transactionAfterBalance", Long.class);

    public final NumberPath<Long> transactionBalance = createNumber("transactionBalance", Long.class);

    public final DatePath<java.time.LocalDate> transactionDate = createDate("transactionDate", java.time.LocalDate.class);

    public final NumberPath<Integer> transactionId = createNumber("transactionId", Integer.class);

    public final StringPath transactionSummary = createString("transactionSummary");

    public final TimePath<java.time.LocalTime> transactionTime = createTime("transactionTime", java.time.LocalTime.class);

    public final StringPath transactionType = createString("transactionType");

    public final StringPath transactionTypeName = createString("transactionTypeName");

    public final NumberPath<Integer> transactionUniqueNo = createNumber("transactionUniqueNo", Integer.class);

    public QTransaction(String variable) {
        this(Transaction.class, forVariable(variable), INITS);
    }

    public QTransaction(Path<? extends Transaction> path) {
        this(path.getType(), path.getMetadata(), PathInits.getFor(path.getMetadata(), INITS));
    }

    public QTransaction(PathMetadata metadata) {
        this(metadata, PathInits.getFor(metadata, INITS));
    }

    public QTransaction(PathMetadata metadata, PathInits inits) {
        this(Transaction.class, metadata, inits);
    }

    public QTransaction(Class<? extends Transaction> type, PathMetadata metadata, PathInits inits) {
        super(type, metadata, inits);
        this.account = inits.isInitialized("account") ? new com.orange.fintech.member.entity.QAccount(forProperty("account"), inits.get("account")) : null;
        this.group = inits.isInitialized("group") ? new com.orange.fintech.group.entity.QGroup(forProperty("group")) : null;
        this.member = inits.isInitialized("member") ? new com.orange.fintech.member.entity.QMember(forProperty("member")) : null;
    }

}

