package com.orange.fintech.group.controller;

import com.orange.fintech.common.BaseResponseBody;
import com.orange.fintech.group.dto.GroupCreateDto;
import com.orange.fintech.group.dto.ModifyGroupDto;
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
    @Operation(summary = "내가 포함된 그룹 목록 조회", description = "내가 포함된 그룹 목록을 조회한다.")
    @ApiResponses({
        @ApiResponse(responseCode = "200", description = "성공"),
        @ApiResponse(responseCode = "500", description = "서버 오류")
    })
    public ResponseEntity<?> findGroups(Principal principal) {
        log.info("** principal :{}", principal.getName());
        log.info("** findGroups 호출~~~!!!");
        String memberId = principal.getName();
        //        String memberId = "3388366548";

        try {
            List<Group> groups = groupService.findGroups(memberId);

            return ResponseEntity.status(HttpStatus.OK).body(groups);
        } catch (Exception e) {
            log.info(e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(BaseResponseBody.of(500, "서버 오류"));
        }
    }

    @GetMapping("/{groupId}")
    @Operation(summary = "그룹 상세 조회", description = "사용자가 선택한 그룹을 상세 조회한다.")
    @ApiResponses({
        @ApiResponse(responseCode = "200", description = "성공"),
        @ApiResponse(responseCode = "500", description = "서버 오류")
    })
    public ResponseEntity<?> getGroup(@PathVariable("groupId") int groupId, Principal principal) {
        log.info("** principal :{}", principal.getName());
        String memberId = principal.getName();

        //        String memberId = "3388366548";

        try {

            // 회원이 선택한 그룹의 존재여부와 포함되어(권한)있는지 확인.
            if (!groupService.check(memberId, groupId)) {
                return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                        .body(BaseResponseBody.of(400, "그룹이 없거나 권한이 없습니다."));
            }

            Group group = groupService.getGroup(groupId);

            return ResponseEntity.status(HttpStatus.OK).body(group);
        } catch (Exception e) {
            log.info(e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(BaseResponseBody.of(500, "서버 오류"));
        }
    }

    @PutMapping("/{groupId}")
    @Operation(summary = "그룹 수정", description = "그룹명, 테마, 여행기간 등을 수정할 수 있다.")
    @ApiResponses({
        @ApiResponse(responseCode = "200", description = "성공"),
        @ApiResponse(responseCode = "500", description = "서버 오류")
    })
    public ResponseEntity<?> modifyGroup(
            @PathVariable("groupId") int groupId,
            @RequestBody @Valid ModifyGroupDto dto,
            Principal principal) {
        log.info("** principal :{}", principal.getName());
        String memberId = principal.getName();

        //        String memberId = "3388366548";

        try {
            // 회원이 선택한 그룹의 존재여부와 포함되어(권한)있는지 확인.
            if (!groupService.check(memberId, groupId)) {
                return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                        .body(BaseResponseBody.of(400, "그룹이 없거나 권한이 없습니다."));
            }

            Group group = groupService.modifyGroup(groupId, dto);

            return ResponseEntity.status(HttpStatus.OK).body(group);
        } catch (Exception e) {
            log.info(e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(BaseResponseBody.of(500, "서버 오류"));
        }
    }

    @PostMapping("/{groupId}")
    @Operation(summary = "그룹 나가기", description = "그룹을 나갈 수 있습니다.")
    @ApiResponses({
        @ApiResponse(responseCode = "200", description = "성공"),
        @ApiResponse(responseCode = "500", description = "서버 오류")
    })
    public ResponseEntity<BaseResponseBody> leaveGroup(
            @PathVariable("groupId") int groupId, Principal principal) {
        log.info("** principal :{}", principal.getName());
        String memberId = principal.getName();

        try {
            // 회원이 선택한 그룹의 존재여부와 포함되어(권한)있는지 확인.
            if (!groupService.check(memberId, groupId)) {
                return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                        .body(BaseResponseBody.of(400, "그룹이 없거나 권한이 없습니다."));
            }

            boolean result = groupService.leaveGroup(groupId, memberId);

            if (result) {
                return ResponseEntity.status(HttpStatus.OK)
                        .body(BaseResponseBody.of(200, "방을 나갔습니다."));
            }
            return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                    .body(BaseResponseBody.of(400, "정산이 완료되지 않아 나가기가 제한됩니다. 정산완료하기 누르세요!"));
        } catch (Exception e) {
            log.info(e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(BaseResponseBody.of(500, "서버 오류"));
        }
    }
}
