package com.orange.fintech.payment.entity;

import static com.querydsl.core.types.PathMetadataFactory.*;

import com.querydsl.core.types.dsl.*;

import com.querydsl.core.types.PathMetadata;
import javax.annotation.processing.Generated;
import com.querydsl.core.types.Path;
import com.querydsl.core.types.dsl.PathInits;


/**
 * QReceiptDetailMember is a Querydsl query type for ReceiptDetailMember
 */
@Generated("com.querydsl.codegen.DefaultEntitySerializer")
public class QReceiptDetailMember extends EntityPathBase<ReceiptDetailMember> {

    private static final long serialVersionUID = -555552928L;

    private static final PathInits INITS = PathInits.DIRECT2;

    public static final QReceiptDetailMember receiptDetailMember = new QReceiptDetailMember("receiptDetailMember");

    public final NumberPath<Integer> amountDue = createNumber("amountDue", Integer.class);

    public final QReceiptDetailMemberPK receiptDetailMemberPK;

    public QReceiptDetailMember(String variable) {
        this(ReceiptDetailMember.class, forVariable(variable), INITS);
    }

    public QReceiptDetailMember(Path<? extends ReceiptDetailMember> path) {
        this(path.getType(), path.getMetadata(), PathInits.getFor(path.getMetadata(), INITS));
    }

    public QReceiptDetailMember(PathMetadata metadata) {
        this(metadata, PathInits.getFor(metadata, INITS));
    }

    public QReceiptDetailMember(PathMetadata metadata, PathInits inits) {
        this(ReceiptDetailMember.class, metadata, inits);
    }

    public QReceiptDetailMember(Class<? extends ReceiptDetailMember> type, PathMetadata metadata, PathInits inits) {
        super(type, metadata, inits);
        this.receiptDetailMemberPK = inits.isInitialized("receiptDetailMemberPK") ? new QReceiptDetailMemberPK(forProperty("receiptDetailMemberPK"), inits.get("receiptDetailMemberPK")) : null;
    }

}

