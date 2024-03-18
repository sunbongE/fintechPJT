package com.orange.fintech.payment.entity;

import static com.querydsl.core.types.PathMetadataFactory.*;

import com.querydsl.core.types.dsl.*;

import com.querydsl.core.types.PathMetadata;
import javax.annotation.processing.Generated;
import com.querydsl.core.types.Path;
import com.querydsl.core.types.dsl.PathInits;


/**
 * QReceiptDetail is a Querydsl query type for ReceiptDetail
 */
@Generated("com.querydsl.codegen.DefaultEntitySerializer")
public class QReceiptDetail extends EntityPathBase<ReceiptDetail> {

    private static final long serialVersionUID = 1129606438L;

    private static final PathInits INITS = PathInits.DIRECT2;

    public static final QReceiptDetail receiptDetail = new QReceiptDetail("receiptDetail");

    public final NumberPath<Integer> count = createNumber("count", Integer.class);

    public final StringPath menu = createString("menu");

    public final QReceipt receipt;

    public final NumberPath<Integer> receiptDetailId = createNumber("receiptDetailId", Integer.class);

    public final NumberPath<Integer> unitPrice = createNumber("unitPrice", Integer.class);

    public QReceiptDetail(String variable) {
        this(ReceiptDetail.class, forVariable(variable), INITS);
    }

    public QReceiptDetail(Path<? extends ReceiptDetail> path) {
        this(path.getType(), path.getMetadata(), PathInits.getFor(path.getMetadata(), INITS));
    }

    public QReceiptDetail(PathMetadata metadata) {
        this(metadata, PathInits.getFor(metadata, INITS));
    }

    public QReceiptDetail(PathMetadata metadata, PathInits inits) {
        this(ReceiptDetail.class, metadata, inits);
    }

    public QReceiptDetail(Class<? extends ReceiptDetail> type, PathMetadata metadata, PathInits inits) {
        super(type, metadata, inits);
        this.receipt = inits.isInitialized("receipt") ? new QReceipt(forProperty("receipt"), inits.get("receipt")) : null;
    }

}

