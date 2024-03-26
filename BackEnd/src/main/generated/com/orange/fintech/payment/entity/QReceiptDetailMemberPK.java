package com.orange.fintech.payment.entity;

import static com.querydsl.core.types.PathMetadataFactory.*;

import com.querydsl.core.types.dsl.*;

import com.querydsl.core.types.PathMetadata;
import javax.annotation.processing.Generated;
import com.querydsl.core.types.Path;
import com.querydsl.core.types.dsl.PathInits;


/**
 * QReceiptDetailMemberPK is a Querydsl query type for ReceiptDetailMemberPK
 */
@Generated("com.querydsl.codegen.DefaultEmbeddableSerializer")
public class QReceiptDetailMemberPK extends BeanPath<ReceiptDetailMemberPK> {

    private static final long serialVersionUID = -1310416549L;

    private static final PathInits INITS = PathInits.DIRECT2;

    public static final QReceiptDetailMemberPK receiptDetailMemberPK = new QReceiptDetailMemberPK("receiptDetailMemberPK");

    public final com.orange.fintech.member.entity.QMember member;

    public final QReceiptDetail receiptDetail;

    public QReceiptDetailMemberPK(String variable) {
        this(ReceiptDetailMemberPK.class, forVariable(variable), INITS);
    }

    public QReceiptDetailMemberPK(Path<? extends ReceiptDetailMemberPK> path) {
        this(path.getType(), path.getMetadata(), PathInits.getFor(path.getMetadata(), INITS));
    }

    public QReceiptDetailMemberPK(PathMetadata metadata) {
        this(metadata, PathInits.getFor(metadata, INITS));
    }

    public QReceiptDetailMemberPK(PathMetadata metadata, PathInits inits) {
        this(ReceiptDetailMemberPK.class, metadata, inits);
    }

    public QReceiptDetailMemberPK(Class<? extends ReceiptDetailMemberPK> type, PathMetadata metadata, PathInits inits) {
        super(type, metadata, inits);
        this.member = inits.isInitialized("member") ? new com.orange.fintech.member.entity.QMember(forProperty("member")) : null;
        this.receiptDetail = inits.isInitialized("receiptDetail") ? new QReceiptDetail(forProperty("receiptDetail"), inits.get("receiptDetail")) : null;
    }

}

