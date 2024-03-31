package com.orange.fintech.group.controller;

import com.orange.fintech.common.BaseResponseBody;
import com.orange.fintech.group.dto.*;
import com.orange.fintech.group.entity.Group;
import com.orange.fintech.group.entity.GroupStatus;
import com.orange.fintech.group.service.GroupService;
import com.orange.fintech.payment.dto.CalculateResultDto;
import com.orange.fintech.payment.service.CalculateService;
import com.orange.fintech.util.ReceiptOcrService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import java.security.Principal;
import java.time.LocalDateTime;
import java.util.List;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.scheduling.annotation.Async;
import org.springframework.web.bind.annotation.*;

@Tag(name = "Group", description = "그룹 API")
@Slf4j
@RestController
@RequiredArgsConstructor
@RequestMapping("/api/v1/groups")
public class GroupController {

    private final GroupService groupService;
    private final CalculateService calculateService;

    @Autowired private final ReceiptOcrService receiptOcrService;

    @PostMapping()
    @Operation(summary = "그룹 생성", description = "그룹을 생성한다.")
    @ApiResponses({
        @ApiResponse(responseCode = "200", description = "성공"),
        @ApiResponse(responseCode = "500", description = "서버 오류")
    })
    public ResponseEntity<?> createGroup(
            @RequestBody @Valid GroupCreateDto dto, Principal principal) {

        try {
            String memberId = principal.getName();
            int groupId = groupService.createGroup(dto, memberId);
            return ResponseEntity.status(HttpStatus.OK).body(groupId);
        } catch (Exception e) {
            log.info("[ERROR] :{}", e.getMessage());
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
        String memberId = principal.getName();

        try {
            List<Group> groups = groupService.findGroups(memberId);

            return ResponseEntity.status(HttpStatus.OK).body(groups);
        } catch (Exception e) {
            log.info("[ERROR] :{}", e.getMessage());
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
        String memberId = principal.getName();

        try {

            if (!groupService.isExistMember(memberId, groupId)) {
                return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                        .body(BaseResponseBody.of(400, "그룹이 없거나 권한이 없습니다."));
            }

            Group group = groupService.getGroup(groupId);

            return ResponseEntity.status(HttpStatus.OK).body(group);
        } catch (Exception e) {
            log.info("[ERROR] :{}", e.getMessage());
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
        String memberId = principal.getName();

        try {
            if (!groupService.isExistMember(memberId, groupId)) {
                return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                        .body(BaseResponseBody.of(400, "그룹이 없거나 권한이 없습니다."));
            }

            Group group = groupService.modifyGroup(groupId, dto);

            return ResponseEntity.status(HttpStatus.OK).body(group);
        } catch (Exception e) {
            log.info("[ERROR] :{}", e.getMessage());
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
        String memberId = principal.getName();

        try {
            if (!groupService.isExistMember(memberId, groupId)) {
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
            log.info("[ERROR] :{}", e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(BaseResponseBody.of(500, "서버 오류"));
        }
    }

    @PostMapping("/{groupId}/invite")
    @Operation(summary = "그룹 참가", description = "링크를 클릭한 회원은 그룹에 초대됩니다.")
    @ApiResponses({
        @ApiResponse(responseCode = "200", description = "성공"),
        @ApiResponse(responseCode = "500", description = "서버 오류")
    })
    public ResponseEntity<?> joinGroup(@PathVariable("groupId") int groupId, Principal principal) {
        String memberId = principal.getName();

        try {

            boolean result = groupService.joinGroup(groupId, memberId);

            if (!result) {
                return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                        .body(BaseResponseBody.of(400, "여행 그룹에 참여할 수 없습니다."));
            }

            return ResponseEntity.status(HttpStatus.OK)
                    .body(BaseResponseBody.of(200, "여행 그룹에 참여했습니다."));

        } catch (Exception e) {
            log.info("[ERROR] :{}", e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(BaseResponseBody.of(500, "서버 오류"));
        }
    }

    @GetMapping("/{groupId}/members")
    @Operation(summary = "그룹원 조회", description = "그룹에 포함된 유저를 받아온다.")
    @ApiResponses({
        @ApiResponse(responseCode = "200", description = "성공"),
        @ApiResponse(responseCode = "500", description = "서버 오류")
    })
    public ResponseEntity<?> findGroupMembers(
            @PathVariable("groupId") int groupId, Principal principal) {
        // 시작시간 확인.
        LocalDateTime startTime = LocalDateTime.now();
        System.out.println("컨트롤러 시작 시간: " + startTime);

        String memberId = principal.getName();
        try {
            if (!groupService.isExistMember(memberId, groupId)) {
                return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                        .body(BaseResponseBody.of(400, "그룹이 없거나 권한이 없습니다."));
            }

            GroupMembersListDto result = groupService.findGroupMembers(groupId);
            LocalDateTime endTime = LocalDateTime.now();
            System.out.println("컨트롤러 종료 시간: " + endTime);
            return ResponseEntity.status(HttpStatus.OK).body(result);

        } catch (Exception e) {
            e.printStackTrace();
            log.info("[ERROR] :{}", e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(BaseResponseBody.of(500, "서버 오류"));
        }
    }

    @Async
    @PutMapping("/{groupId}/firstcall")
    @Operation(summary = "정산 내역 요청 및 취소", description = "정산 요청을 하여 회원의 상태가 변경된다.")
    //    @ApiResponses({
    //        @ApiResponse(responseCode = "200", description = "성공"),
    //        @ApiResponse(responseCode = "500", description = "서버 오류")
    //    })
    public void firstcall(@PathVariable("groupId") int groupId, Principal principal) {
        String memberId = principal.getName();

        try {
            if (!groupService.isExistMember(memberId, groupId)) {
                throw new RuntimeException("해당 멤버는 그룹에 속해 있지 않습니다.");
                //                return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                //                        .body(BaseResponseBody.of(400, "그룹이 없거나 권한이 없습니다."));
            }

            groupService.firstcall(groupId, memberId);
            //            if (result) {
            //                return
            // ResponseEntity.status(HttpStatus.OK).body(BaseResponseBody.of(200, "성공"));
            //            } else {
            //                return ResponseEntity.status(HttpStatus.BAD_REQUEST)
            //                        .body(BaseResponseBody.of(400, "실패"));
            //            }

        } catch (Exception e) {
            log.info("[ERROR] :{}", e.getMessage());
            //            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
            //                    .body(BaseResponseBody.of(500, "서버 오류"));
            return;
        }
    }

    @PutMapping("/{groupId}/secondcall")
    @Operation(summary = "정산 내역 요청 및 취소", description = "정산 요청을 하여 회원의 상태가 변경된다.")
    public ResponseEntity<?> secondcall(@PathVariable("groupId") int groupId, Principal principal) {
        String memberId = principal.getName();

        try {
            int result = groupService.secondcall(groupId, memberId);

            return ResponseEntity.status(HttpStatus.OK).body(result);
        } catch (Exception e) {
            e.printStackTrace();
            log.info("[ERROR] :{}", e.getMessage());
        }

        return ResponseEntity.status(HttpStatus.OK).body(null);
    }

    @PostMapping("/{groupId}/calculate")
    @Operation(summary = "최종 정산", description = "최종정산을 진행한다.")
    public ResponseEntity<?> finalCalculate(
            @PathVariable("groupId") int groupId, Principal principal) {
        String memberId = principal.getName();

        try {
            if (groupService.getGroupStatus(groupId).equals(GroupStatus.DONE)) {
                return ResponseEntity.status(HttpStatus.NOT_ACCEPTABLE)
                        .body(BaseResponseBody.of(400, "이미 정산된 내역"));
            }

            List<CalculateResultDto> calRes = calculateService.finalCalculator(groupId, memberId);
            if (calRes == null) {
                return ResponseEntity.status(HttpStatus.NOT_ACCEPTABLE)
                        .body(BaseResponseBody.of(406, "잔액이 부족해서 취소됨."));
            }
            log.info("정산 결과: {}", calRes);

            log.info("정산 송금 시작");
            calculateService.transfer(calRes, groupId);
            log.info("정산 송금 끝");

            return ResponseEntity.status(HttpStatus.OK).body(BaseResponseBody.of(200, "OK"));
        } catch (Exception e) {
            e.printStackTrace();
            log.info("[ERROR] :{}", e.getMessage());
        }

        return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                .body(BaseResponseBody.of(400, "BAD_REQUEST"));
    }

    // TODO: 최종정산결과
    @GetMapping("/{groupId}/calculate")
    @Operation(summary = "최종 정산 결과", description = "최종정산결과를 조회한다.")
    public ResponseEntity<?> getFinalCalculate(
            @PathVariable("groupId") int groupId, Principal principal) {
        String memberId = principal.getName();

        try {
            // 내 정산에 대한 결과?
            return ResponseEntity.status(HttpStatus.OK).body(BaseResponseBody.of(200, "OK"));
        } catch (Exception e) {
            e.printStackTrace();
            log.info("[ERROR] :{}", e.getMessage());
        }

        return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                .body(BaseResponseBody.of(400, "BAD_REQUEST"));
    }

    @GetMapping("/{groupId}/members/firstcall")
    @Operation(
            summary = "그룹에서 정산 요청 하기를 누른 사람 목록",
            description = "그룹에서 정산 요청 하기를 누른 사람 목록을 확인할 수 있다.")
    @ApiResponses({
        @ApiResponse(responseCode = "200", description = "성공"),
        @ApiResponse(responseCode = "500", description = "서버 오류")
    })
    public ResponseEntity<?> firstcallMembers(
            @PathVariable("groupId") int groupId, Principal principal) {
        String memberId = principal.getName();

        try {
            if (!groupService.isExistMember(memberId, groupId)) {
                return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                        .body(BaseResponseBody.of(400, "그룹이 없거나 권한이 없습니다."));
            }

            List<GroupMembersDto> result = groupService.firstcallMembers(groupId);

            if (result.size() == 0)
                return ResponseEntity.status(HttpStatus.OK)
                        .body(BaseResponseBody.of(200, "정산 요청한 사람이 없음"));
            return ResponseEntity.status(HttpStatus.OK).body(result);

        } catch (Exception e) {
            log.info("[ERROR] :{}", e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(BaseResponseBody.of(500, "서버 오류"));
        }
    }

    @GetMapping("/{groupId}/members/secondcall")
    @Operation(
            summary = "그룹에서 정산 요청 하기를 누른 사람 목록",
            description = "그룹에서 정산 요청 하기를 누른 사람 목록을 확인할 수 있다.")
    @ApiResponses({
        @ApiResponse(responseCode = "200", description = "성공"),
        @ApiResponse(responseCode = "500", description = "서버 오류")
    })
    public ResponseEntity<?> secondcallMembers(
            @PathVariable("groupId") int groupId, Principal principal) {
        String memberId = principal.getName();

        try {
            if (!groupService.isExistMember(memberId, groupId)) {
                return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                        .body(BaseResponseBody.of(400, "그룹이 없거나 권한이 없습니다."));
            }

            List<GroupMembersDto> result = groupService.secondcallMembers(groupId);

            if (result.size() == 0)
                return ResponseEntity.status(HttpStatus.OK)
                        .body(BaseResponseBody.of(200, "정산을 한 사람이 없음"));
            return ResponseEntity.status(HttpStatus.OK).body(result);

        } catch (Exception e) {
            log.info("[ERROR] :{}", e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(BaseResponseBody.of(500, "서버 오류"));
        }
    }

    @GetMapping("/{groupId}/result")
    @Operation(
            summary = "그룹에서 정산 요청 하기를 누른 사람 목록",
            description = "그룹에서 정산 요청 하기를 누른 사람 목록을 확인할 수 있다.")
    @ApiResponses({
        @ApiResponse(responseCode = "200", description = "성공"),
        @ApiResponse(responseCode = "500", description = "서버 오류")
    })
    public ResponseEntity<?> getCalculateResult(
            @PathVariable("groupId") int groupId, Principal principal) {
        String memberId = principal.getName();

        try {
            if (!groupService.isExistMember(memberId, groupId)) {
                return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                        .body(BaseResponseBody.of(400, "그룹이 없거나 권한이 없습니다."));
            }

            List<GroupCalculateResultDto> result = groupService.getCalculateResult(groupId);

            if (result == null)
                return ResponseEntity.status(HttpStatus.OK)
                        .body(BaseResponseBody.of(200, "정산 미완료"));
            return ResponseEntity.status(HttpStatus.OK).body(result);

        } catch (Exception e) {
            log.info("[ERROR] :{}", e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(BaseResponseBody.of(500, "서버 오류"));
        }
    }
}
