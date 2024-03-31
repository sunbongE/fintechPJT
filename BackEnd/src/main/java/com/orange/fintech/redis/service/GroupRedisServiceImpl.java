package com.orange.fintech.redis.service;

import com.orange.fintech.group.dto.GroupMembersListDto;
import com.orange.fintech.group.entity.Group;
import com.orange.fintech.group.repository.GroupQueryRepository;
import com.orange.fintech.member.repository.MemberRepository;
import jakarta.annotation.Resource;
import java.time.Duration;
import java.util.List;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.redis.core.HashOperations;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.stereotype.Service;

@Service
@Slf4j
public class GroupRedisServiceImpl implements GroupRedisService {

    @Autowired MemberRepository memberRepository;

    @Autowired GroupQueryRepository queryRepository;
    static final String GroupKEY = "GROUP_MEMBERS";

    @Resource(name = "redisTemplateGroup")
    private HashOperations<String, String, GroupMembersListDto> hashOpsGroup;

    @Autowired private RedisTemplate<String, Object> redisTemplate;

    @Override
    public GroupMembersListDto getGroupMembersFromCache(int groupId) {
        try {
            //            HashOperations<String,String ,GroupMembersListDto> hashOperations =
            // redisTemplate.opsForHash();
            GroupMembersListDto result =
                    hashOpsGroup.get(
                            GroupKEY + "-" + String.valueOf(groupId), String.valueOf(groupId));
            //            log.info("result(getGroupMembersFromCache) :{}",
            // hashOperations.get(GroupKEY,String.valueOf(groupId)));
            if (result == null) {
                return null;
            }

            //            return (List<GroupMembersDto>) groupMembersDtos;
            return result;

        } catch (ClassCastException cce) {
            cce.printStackTrace();
            return null;
        }
    }

    @Override
    public void saveDataExpire(int groupId, GroupMembersListDto result) {

        //        log.info("넘어오는 result :{}", result);
        hashOpsGroup.put(GroupKEY + "-" + groupId, String.valueOf(groupId), result);
        // 만료 시간 설정
        Duration expiredDuration = Duration.ofDays(7);
        redisTemplate.expire(GroupKEY, expiredDuration);
    }

    @Override
    public void deleteAllData(String kakaoId) {

        //        Member member = memberRepository.findById(kakaoId).get();

        List<Group> groupIdList = queryRepository.findAllMyGroupId(kakaoId);

        for (Group group : groupIdList) {
            hashOpsGroup.delete(
                    GroupKEY + "-" + group.getGroupId(), String.valueOf(group.getGroupId()));
        }
    }

    @Override
    public void deleteData(Integer groupId) {
        log.info("deleteData: {}", groupId);
        hashOpsGroup.delete(GroupKEY + "-" + groupId, String.valueOf(groupId));
    }
}
