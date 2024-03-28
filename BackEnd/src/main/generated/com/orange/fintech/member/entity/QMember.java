package com.orange.fintech.member.entity;

import static com.querydsl.core.types.PathMetadataFactory.*;

import com.querydsl.core.types.dsl.*;

import com.querydsl.core.types.PathMetadata;
import javax.annotation.processing.Generated;
import com.querydsl.core.types.Path;
import com.querydsl.core.types.dsl.PathInits;


/**
 * QMember is a Querydsl query type for Member
 */
@Generated("com.querydsl.codegen.DefaultEntitySerializer")
public class QMember extends EntityPathBase<Member> {

    private static final long serialVersionUID = -800586927L;

    public static final QMember member = new QMember("member1");

    public final ListPath<com.orange.fintech.account.entity.Account, com.orange.fintech.account.entity.QAccount> accounts = this.<com.orange.fintech.account.entity.Account, com.orange.fintech.account.entity.QAccount>createList("accounts", com.orange.fintech.account.entity.Account.class, com.orange.fintech.account.entity.QAccount.class, PathInits.DIRECT2);

    public final StringPath email = createString("email");

    public final StringPath kakaoId = createString("kakaoId");

    public final StringPath name = createString("name");

    public final StringPath pin = createString("pin");

    public final StringPath profileImage = createString("profileImage");

    public final EnumPath<Roles> role = createEnum("role", Roles.class);

    public final StringPath thumbnailImage = createString("thumbnailImage");

    public final StringPath userKey = createString("userKey");

    public QMember(String variable) {
        super(Member.class, forVariable(variable));
    }

    public QMember(Path<? extends Member> path) {
        super(path.getType(), path.getMetadata());
    }

    public QMember(PathMetadata metadata) {
        super(Member.class, metadata);
    }

}

