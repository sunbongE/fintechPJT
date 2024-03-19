package com.orange.fintech.group.controller;

import com.orange.fintech.common.BaseResponseBody;
import com.orange.fintech.group.dto.GroupCreateDto;
import com.orange.fintech.group.entity.Group;
import com.orange.fintech.group.service.GroupService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import java.security.Principal;
import java.util.List;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@Tag(name = "Group", description = "그룹 API")
@Slf4j
@RestController
@RequiredArgsConstructor
@RequestMapping("/api/v1/groups")
public class GroupController {

    private final GroupService groupService;

    @PostMapping()
    @Operation(summary = "그룹 생성", description = "그룹을 생성한다.")
    @ApiResponses({
        @ApiResponse(responseCode = "200", description = "성공"),
        @ApiResponse(responseCode = "500", description = "서버 오류")
    })
    public ResponseEntity<?> createGroup(@RequestBody @Valid GroupCreateDto dto) {

        try {
            groupService.createGroup(dto);
            return ResponseEntity.status(HttpStatus.OK).body(BaseResponseBody.of(200, "성공"));
        } catch (Exception e) {
            log.info(e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(BaseResponseBody.of(500, "서버 오류"));
        }
    }

    @GetMapping()
    @Operation(summary = "내가 포함된 그룹 조회", description = "내가 포함된 그룹을 조회한다.")
    @ApiResponses({
        @ApiResponse(responseCode = "200", description = "성공"),
        @ApiResponse(responseCode = "500", description = "서버 오류")
    })
    public ResponseEntity<?> findGroups(Principal principal) {
        //        String memberId = principal.getName();
        String memberId = "3388366548";

        try {
            //            List<Group> groups = groupService.findGroups(memberId)
            //                    .stream()
            //                    .map(GroupMember::getGroupMemberPK)
            //                    .map(groupMemberPK -> groupMemberPK.getGroup())
            //                    .toList();
            List<Group> groups = groupService.findGroups(memberId);

            return ResponseEntity.status(HttpStatus.OK).body(groups);
        } catch (Exception e) {
            log.info(e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(BaseResponseBody.of(500, "서버 오류"));
        }
    }
}
