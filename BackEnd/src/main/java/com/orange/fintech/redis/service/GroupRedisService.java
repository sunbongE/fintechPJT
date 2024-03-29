package com.orange.fintech.redis.service;

import com.orange.fintech.group.dto.GroupMembersListDto;

public interface GroupRedisService {
    GroupMembersListDto getGroupMembersFromCache(int groupId);

    void deleteData(Integer key);

    void saveDataExpire(int groupId, GroupMembersListDto result);

    void deleteAllData(String kakaoId);
}
