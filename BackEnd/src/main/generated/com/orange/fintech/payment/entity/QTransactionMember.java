package com.orange.fintech.payment.entity;

import static com.querydsl.core.types.PathMetadataFactory.*;

import com.querydsl.core.types.dsl.*;

import com.querydsl.core.types.PathMetadata;
import javax.annotation.processing.Generated;
import com.querydsl.core.types.Path;
import com.querydsl.core.types.dsl.PathInits;


/**
 * QTransactionMember is a Querydsl query type for TransactionMember
 */
@Generated("com.querydsl.codegen.DefaultEntitySerializer")
public class QTransactionMember extends EntityPathBase<TransactionMember> {

    private static final long serialVersionUID = 1609508117L;

    private static final PathInits INITS = PathInits.DIRECT2;

    public static final QTransactionMember transactionMember = new QTransactionMember("transactionMember");

    public final NumberPath<Integer> totalAmount = createNumber("totalAmount", Integer.class);

    public final QTransactionMemberPK transactionMemberPK;

    public QTransactionMember(String variable) {
        this(TransactionMember.class, forVariable(variable), INITS);
    }

    public QTransactionMember(Path<? extends TransactionMember> path) {
        this(path.getType(), path.getMetadata(), PathInits.getFor(path.getMetadata(), INITS));
    }

    public QTransactionMember(PathMetadata metadata) {
        this(metadata, PathInits.getFor(metadata, INITS));
    }

    public QTransactionMember(PathMetadata metadata, PathInits inits) {
        this(TransactionMember.class, metadata, inits);
    }

    public QTransactionMember(Class<? extends TransactionMember> type, PathMetadata metadata, PathInits inits) {
        super(type, metadata, inits);
        this.transactionMemberPK = inits.isInitialized("transactionMemberPK") ? new QTransactionMemberPK(forProperty("transactionMemberPK"), inits.get("transactionMemberPK")) : null;
    }

}

