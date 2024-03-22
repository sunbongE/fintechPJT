package com.orange.fintech.group.dto;

import lombok.*;
import org.springframework.data.redis.core.RedisHash;

import java.io.Serializable;

@Getter
@Setter
@ToString
public class GroupMembersDto implements Serializable {

    String name;
    String kakaoId;
    String thumbnailImage;
}
