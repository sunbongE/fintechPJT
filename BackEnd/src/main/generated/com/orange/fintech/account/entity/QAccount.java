package com.orange.fintech.account.entity;

import static com.querydsl.core.types.PathMetadataFactory.*;

import com.querydsl.core.types.dsl.*;

import com.querydsl.core.types.PathMetadata;
import javax.annotation.processing.Generated;
import com.querydsl.core.types.Path;
import com.querydsl.core.types.dsl.PathInits;


/**
 * QAccount is a Querydsl query type for Account
 */
@Generated("com.querydsl.codegen.DefaultEntitySerializer")
public class QAccount extends EntityPathBase<Account> {

    private static final long serialVersionUID = 1045619043L;

    private static final PathInits INITS = PathInits.DIRECT2;

    public static final QAccount account = new QAccount("account");

    public final StringPath accountNo = createString("accountNo");

    public final NumberPath<Long> balance = createNumber("balance", Long.class);

    public final StringPath bankCode = createString("bankCode");

    public final BooleanPath isPrimaryAccount = createBoolean("isPrimaryAccount");

    public final com.orange.fintech.member.entity.QMember member;

    public final ListPath<com.orange.fintech.payment.entity.Transaction, com.orange.fintech.payment.entity.QTransaction> transactionList = this.<com.orange.fintech.payment.entity.Transaction, com.orange.fintech.payment.entity.QTransaction>createList("transactionList", com.orange.fintech.payment.entity.Transaction.class, com.orange.fintech.payment.entity.QTransaction.class, PathInits.DIRECT2);

    public QAccount(String variable) {
        this(Account.class, forVariable(variable), INITS);
    }

    public QAccount(Path<? extends Account> path) {
        this(path.getType(), path.getMetadata(), PathInits.getFor(path.getMetadata(), INITS));
    }

    public QAccount(PathMetadata metadata) {
        this(metadata, PathInits.getFor(metadata, INITS));
    }

    public QAccount(PathMetadata metadata, PathInits inits) {
        this(Account.class, metadata, inits);
    }

    public QAccount(Class<? extends Account> type, PathMetadata metadata, PathInits inits) {
        super(type, metadata, inits);
        this.member = inits.isInitialized("member") ? new com.orange.fintech.member.entity.QMember(forProperty("member")) : null;
    }

}

