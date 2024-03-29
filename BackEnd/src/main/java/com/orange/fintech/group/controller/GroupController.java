package com.orange.fintech.group.controller;

import com.orange.fintech.common.BaseResponseBody;
import com.orange.fintech.group.dto.*;
import com.orange.fintech.group.entity.Group;
import com.orange.fintech.group.service.GroupService;
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
import org.springframework.security.core.annotation.AuthenticationPrincipal;

import org.springframework.web.bind.annotation.*;

@Tag(name = "Group", description = "그룹 API")
@Slf4j
@RestController
@RequiredArgsConstructor
@RequestMapping("/api/v1/groups")
public class GroupController {

    private final GroupService groupService;

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
    @ApiResponses({
        @ApiResponse(responseCode = "200", description = "성공"),
        @ApiResponse(responseCode = "500", description = "서버 오류")
    })
    public ResponseEntity<BaseResponseBody> secondcall(
            @PathVariable("groupId") int groupId, Principal principal) {
        String memberId = principal.getName();

        try {
            if (!groupService.isExistMember(memberId, groupId)) {
                return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                        .body(BaseResponseBody.of(400, "그룹이 없거나 권한이 없습니다."));
            }

            boolean result = groupService.secondcall(groupId, memberId);
            if (result) {
                return ResponseEntity.status(HttpStatus.OK).body(BaseResponseBody.of(200, "성공"));
            } else {
                return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                        .body(BaseResponseBody.of(400, "실패"));
            }

        } catch (Exception e) {
            log.info("[ERROR] :{}", e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(BaseResponseBody.of(500, "서버 오류"));
        }
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

    //    @PostMapping(
    //            value = "/{groupId}/payments/{paymentId}/singlereceipt",
    //            consumes = {MediaType.MULTIPART_FORM_DATA_VALUE})
    //    @Operation(
    //            summary = "영수증 단건 등록",
    //            description = "<strong>(클로바 OCR API요청)</strong> 영수증 1개를 업로드한다.")
    //    @ApiResponses({
    //        @ApiResponse(responseCode = "200", description = "정상 등록"),
    //        @ApiResponse(responseCode = "400", description = "비어있는 파일"),
    //        @ApiResponse(responseCode = "413", description = "20MB를 초과하는 파일"),
    //        @ApiResponse(responseCode = "415", description = "지원하지 않는 확장자"),
    //        @ApiResponse(responseCode = "500", description = "서버 오류")
    //    })
    //    public ResponseEntity<?> uploadSingleReceipt(
    //            @AuthenticationPrincipal CustomUserDetails customUserDetails,
    //            @PathVariable @Parameter(description = "그룹 아이디", in = ParameterIn.PATH) int
    // groupId,
    //            @PathVariable @Parameter(description = "거래 아이디", in = ParameterIn.PATH) int
    // paymentId,
    //            @RequestPart(value = "file", required = true) MultipartFile receiptImage) {
    //
    //        try {
    //            JsonNode singleResponse = receiptOcrService.singleRequest(receiptImage);
    //
    //            return ResponseEntity.status(HttpStatus.OK).body(singleResponse);
    //        } catch (EmptyFileException e) {
    //            return ResponseEntity.status(HttpStatus.BAD_REQUEST)
    //                    .body(BaseResponseBody.of(400, "파일이 비어있습니다."));
    //        } catch (BigFileException e) {
    //            return ResponseEntity.status(HttpStatus.PAYLOAD_TOO_LARGE)
    //                    .body(BaseResponseBody.of(413, "업로드한 파일의 용량이 20MB 이상입니다."));
    //        } catch (NotValidExtensionException e) {
    //            return ResponseEntity.status(HttpStatus.UNSUPPORTED_MEDIA_TYPE)
    //                    .body(
    //                            BaseResponseBody.of(
    //                                    415, "지원하는 확장자가 아닙니다. 지원하는 이미지 형식: jpg, jpeg, png, pdf,
    // tiff"));
    //        } catch (Exception e) {
    //            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
    //                    .body(BaseResponseBody.of(500, "서버 오류"));
    //        }
    //    }
}
