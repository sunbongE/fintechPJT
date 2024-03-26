package com.orange.fintech.payment.entity;

import static com.querydsl.core.types.PathMetadataFactory.*;

import com.querydsl.core.types.dsl.*;

import com.querydsl.core.types.PathMetadata;
import javax.annotation.processing.Generated;
import com.querydsl.core.types.Path;
import com.querydsl.core.types.dsl.PathInits;


/**
 * QTransactionDetail is a Querydsl query type for TransactionDetail
 */
@Generated("com.querydsl.codegen.DefaultEntitySerializer")
public class QTransactionDetail extends EntityPathBase<TransactionDetail> {

    private static final long serialVersionUID = 1352053452L;

    private static final PathInits INITS = PathInits.DIRECT2;

    public static final QTransactionDetail transactionDetail = new QTransactionDetail("transactionDetail");

    public final com.orange.fintech.group.entity.QGroup group;

    public final StringPath memo = createString("memo");

    public final BooleanPath receiptEnrolled = createBoolean("receiptEnrolled");

    public final NumberPath<Integer> remainder = createNumber("remainder", Integer.class);

    public final QTransaction transaction;

    public final NumberPath<Integer> transactionId = createNumber("transactionId", Integer.class);

    public QTransactionDetail(String variable) {
        this(TransactionDetail.class, forVariable(variable), INITS);
    }

    public QTransactionDetail(Path<? extends TransactionDetail> path) {
        this(path.getType(), path.getMetadata(), PathInits.getFor(path.getMetadata(), INITS));
    }

    public QTransactionDetail(PathMetadata metadata) {
        this(metadata, PathInits.getFor(metadata, INITS));
    }

    public QTransactionDetail(PathMetadata metadata, PathInits inits) {
        this(TransactionDetail.class, metadata, inits);
    }

    public QTransactionDetail(Class<? extends TransactionDetail> type, PathMetadata metadata, PathInits inits) {
        super(type, metadata, inits);
        this.group = inits.isInitialized("group") ? new com.orange.fintech.group.entity.QGroup(forProperty("group")) : null;
        this.transaction = inits.isInitialized("transaction") ? new QTransaction(forProperty("transaction"), inits.get("transaction")) : null;
    }

}

