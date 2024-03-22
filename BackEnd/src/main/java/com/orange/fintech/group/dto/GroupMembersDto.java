package com.orange.fintech.group.dto;

import java.io.Serializable;
import lombok.*;

@Getter
@Setter
@ToString
public class GroupMembersDto implements Serializable {

    String name;
    String kakaoId;
    String thumbnailImage;
}
