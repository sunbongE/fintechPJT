package com.orange.fintech.payment.entity;

import static com.querydsl.core.types.PathMetadataFactory.*;

import com.querydsl.core.types.dsl.*;

import com.querydsl.core.types.PathMetadata;
import javax.annotation.processing.Generated;
import com.querydsl.core.types.Path;
import com.querydsl.core.types.dsl.PathInits;


/**
 * QTransactionMemberPK is a Querydsl query type for TransactionMemberPK
 */
@Generated("com.querydsl.codegen.DefaultEmbeddableSerializer")
public class QTransactionMemberPK extends BeanPath<TransactionMemberPK> {

    private static final long serialVersionUID = 549076432L;

    private static final PathInits INITS = PathInits.DIRECT2;

    public static final QTransactionMemberPK transactionMemberPK = new QTransactionMemberPK("transactionMemberPK");

    public final com.orange.fintech.member.entity.QMember member;

    public final QTransaction transaction;

    public QTransactionMemberPK(String variable) {
        this(TransactionMemberPK.class, forVariable(variable), INITS);
    }

    public QTransactionMemberPK(Path<? extends TransactionMemberPK> path) {
        this(path.getType(), path.getMetadata(), PathInits.getFor(path.getMetadata(), INITS));
    }

    public QTransactionMemberPK(PathMetadata metadata) {
        this(metadata, PathInits.getFor(metadata, INITS));
    }

    public QTransactionMemberPK(PathMetadata metadata, PathInits inits) {
        this(TransactionMemberPK.class, metadata, inits);
    }

    public QTransactionMemberPK(Class<? extends TransactionMemberPK> type, PathMetadata metadata, PathInits inits) {
        super(type, metadata, inits);
        this.member = inits.isInitialized("member") ? new com.orange.fintech.member.entity.QMember(forProperty("member")) : null;
        this.transaction = inits.isInitialized("transaction") ? new QTransaction(forProperty("transaction"), inits.get("transaction")) : null;
    }

}

