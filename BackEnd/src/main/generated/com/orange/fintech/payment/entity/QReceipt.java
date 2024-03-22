package com.orange.fintech.payment.entity;

import static com.querydsl.core.types.PathMetadataFactory.*;

import com.querydsl.core.types.dsl.*;

import com.querydsl.core.types.PathMetadata;
import javax.annotation.processing.Generated;
import com.querydsl.core.types.Path;
import com.querydsl.core.types.dsl.PathInits;


/**
 * QReceipt is a Querydsl query type for Receipt
 */
@Generated("com.querydsl.codegen.DefaultEntitySerializer")
public class QReceipt extends EntityPathBase<Receipt> {

    private static final long serialVersionUID = -1860479883L;

    private static final PathInits INITS = PathInits.DIRECT2;

    public static final QReceipt receipt = new QReceipt("receipt");

    public final NumberPath<Integer> approvalAmount = createNumber("approvalAmount", Integer.class);

    public final NumberPath<Long> authNumber = createNumber("authNumber", Long.class);

    public final StringPath businessName = createString("businessName");

    public final StringPath location = createString("location");

    public final NumberPath<Integer> receiptId = createNumber("receiptId", Integer.class);

    public final NumberPath<Integer> totalPrice = createNumber("totalPrice", Integer.class);

    public final QTransaction transaction;

    public final DatePath<java.time.LocalDate> transactionDate = createDate("transactionDate", java.time.LocalDate.class);

    public final TimePath<java.time.LocalTime> transactionTime = createTime("transactionTime", java.time.LocalTime.class);

    public final BooleanPath visibility = createBoolean("visibility");

    public QReceipt(String variable) {
        this(Receipt.class, forVariable(variable), INITS);
    }

    public QReceipt(Path<? extends Receipt> path) {
        this(path.getType(), path.getMetadata(), PathInits.getFor(path.getMetadata(), INITS));
    }

    public QReceipt(PathMetadata metadata) {
        this(metadata, PathInits.getFor(metadata, INITS));
    }

    public QReceipt(PathMetadata metadata, PathInits inits) {
        this(Receipt.class, metadata, inits);
    }

    public QReceipt(Class<? extends Receipt> type, PathMetadata metadata, PathInits inits) {
        super(type, metadata, inits);
        this.transaction = inits.isInitialized("transaction") ? new QTransaction(forProperty("transaction"), inits.get("transaction")) : null;
    }

}

