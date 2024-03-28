package com.orange.fintech.member.controller;

import com.orange.fintech.account.entity.Account;
import com.orange.fintech.account.service.AccountService;
import com.orange.fintech.auth.dto.CustomUserDetails;
import com.orange.fintech.common.BaseResponseBody;
import com.orange.fintech.common.exception.BigFileException;
import com.orange.fintech.common.exception.EmptyFileException;
import com.orange.fintech.common.exception.NotValidExtensionException;
import com.orange.fintech.member.entity.Member;
import com.orange.fintech.member.repository.MemberRepository;
import com.orange.fintech.member.service.MemberService;
import com.orange.fintech.oauth.dto.MemberSearchResponseDto;
import com.orange.fintech.util.FileService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.tags.Tag;
import java.io.IOException;
import java.security.Principal;
import java.util.List;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.client.RestClient;
import org.springframework.web.multipart.MultipartFile;

@Slf4j
@Tag(name = "Member", description = "회원 API")
@RestController
@RequiredArgsConstructor
@RequestMapping("/api/v1/members")
public class MemberController {

    @Autowired FileService fileService;

    @Autowired MemberService memberService;

    @Autowired AccountService accountService;
    @Autowired MemberRepository memberRepository;

    @GetMapping("/account")
    @Operation(
            summary = "서비스에 등록된 회원 본인의 계좌 정보 조회",
            description = "<strong>서비스에 등록된</strong> 회원 본인의 계좌정보</strong>를 조회한다.")
    @ApiResponses({
        @ApiResponse(responseCode = "200", description = "정상 반환"),
        @ApiResponse(responseCode = "404", description = "계좌 정보 없음 (DB 레코드 유실)"),
        @ApiResponse(responseCode = "500", description = "서버 오류")
    })
    public ResponseEntity<?> getMyAccountList(
            @AuthenticationPrincipal CustomUserDetails customUserDetails) {
        String kakaoId = customUserDetails.getUsername();

        Member member = memberService.findByKakaoId(kakaoId);
        List<Account> myAccounts = memberService.findAccountsByKakaoId(member);

        if (myAccounts != null && !myAccounts.isEmpty()) {
            return ResponseEntity.status(HttpStatus.OK).body(myAccounts);
        }

        return ResponseEntity.status(HttpStatus.NOT_FOUND).body("일치하는 계좌 정보 없음");
    }

    @PutMapping("/account")
    @Operation(
            summary = "계좌 정보 수정 (주 계좌 설정)",
            description = "<string>회원 본인의 <strong>계좌 정보</strong>를 수정한다.")
    @ApiResponses({
        @ApiResponse(responseCode = "200", description = "정상 저장"),
        @ApiResponse(responseCode = "500", description = "서버 오류")
    })
    public ResponseEntity<?> updatePrimaryAccount(
            @AuthenticationPrincipal CustomUserDetails customUserDetails, String accountNo) {
        String kakaoId = customUserDetails.getUsername();

        accountService.updatePrimaryAccount(kakaoId, accountNo);

        //        if(accountService.insertAccount(kakaoId, account)) {
        return ResponseEntity.ok(BaseResponseBody.of(200, "계좌 정보 추가 성공"));
        //        }

        //        return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
        //                .body(BaseResponseBody.of(500, "Pin 번호 수정 중 오류 발생"));
    }

    @GetMapping("/{email}")
    @Operation(summary = "사용자 검색", description = "<strong>이메일 아이디</strong>로 사용자를 검색한다.")
    @ApiResponses({
        @ApiResponse(responseCode = "200", description = "일치하는 유저 정보 있음"),
        @ApiResponse(responseCode = "404", description = "일치하는 유저 정보 없음"),
        @ApiResponse(responseCode = "500", description = "서버 오류")
    })
    public ResponseEntity<?> searchUser(@PathVariable(name = "email") String email) {
        MemberSearchResponseDto memberSearchResponseDto = memberService.findByEmail(email);

        if (memberSearchResponseDto != null) {
            return ResponseEntity.status(HttpStatus.OK).body(memberSearchResponseDto);
        }

        return ResponseEntity.status(HttpStatus.NOT_FOUND).body("일치하는 유저 정보 없음");
    }

    @PostMapping("/pin")
    @Operation(summary = "핀 번호 등록", description = "앱에서 사용할 PIN 번호를 등록한다.")
    @ApiResponses({
        @ApiResponse(responseCode = "200", description = "정상 등록"),
        @ApiResponse(responseCode = "500", description = "서버 오류")
    })
    public ResponseEntity<?> registerPin(
            @AuthenticationPrincipal CustomUserDetails customUserDetails,
            @RequestBody @Parameter(description = "핀 번호", example = "123456") String pin) {

        String kakaoId = customUserDetails.getUsername();

        if (memberService.updatePin(kakaoId, pin)) {
            return ResponseEntity.ok(BaseResponseBody.of(200, "PIN 번호 수정 완료"));
        }

        return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                .body(BaseResponseBody.of(500, "PIN 번호 수정 중 오류 발생"));
    }

    @PutMapping("/pin")
    @Operation(summary = "핀 번호 확인", description = "핀 번호가 일치하는지 대조한다.")
    @ApiResponses({
        @ApiResponse(responseCode = "200", description = "PIN 번호 일치"),
        @ApiResponse(responseCode = "401", description = "PIN 번호 틀림")
    })
    public ResponseEntity<?> verifyPin(
            @AuthenticationPrincipal CustomUserDetails customUserDetails,
            @RequestBody @Parameter(description = "핀 번호", example = "123456") String pin) {

        String kakaoId = customUserDetails.getUsername();

        if (memberService.verifyPin(kakaoId, pin)) {
            return ResponseEntity.ok(BaseResponseBody.of(200, "PIN 번호가 일치합니다."));
        }

        return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
                .body(BaseResponseBody.of(401, "PIN 번호가 틀립니다."));
    }

    @DeleteMapping()
    @Operation(summary = "회원 탈퇴", description = "회원 탈퇴를 진행한다.")
    @ApiResponses({
        @ApiResponse(responseCode = "200", description = "정상 탈퇴"),
        @ApiResponse(responseCode = "500", description = "서버 오류")
    })
    public ResponseEntity<?> withdraw(
            @AuthenticationPrincipal CustomUserDetails customUserDetails) {
        String kakaoId = customUserDetails.getUsername();

        if (memberService.deleteUser(kakaoId)) {
            return ResponseEntity.ok(BaseResponseBody.of(200, "정상적으로 탈퇴되었습니다."));
        }

        return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                .body(BaseResponseBody.of(500, "탈퇴 중 오류 발생"));
    }

    @PutMapping(
            value = "/profile",
            consumes = {MediaType.MULTIPART_FORM_DATA_VALUE})
    @Operation(summary = "회원정보수정:프로필사진", description = "회원의 프로필 이미지를 변경한다.")
    @ApiResponses({
        @ApiResponse(responseCode = "200", description = "정상 수정"),
        @ApiResponse(responseCode = "400", description = "비어있는 파일"),
        @ApiResponse(responseCode = "413", description = "20MB를 초과하는 파일"),
        @ApiResponse(responseCode = "415", description = "지원하지 않는 확장자"),
        @ApiResponse(responseCode = "500", description = "서버 오류"),
        @ApiResponse(responseCode = "503", description = "서버 오류 (File IO)")
    })
    public ResponseEntity<?> updateProfileImage(
            @AuthenticationPrincipal CustomUserDetails customUserDetails,
            @RequestPart(value = "file", required = true) MultipartFile profileImage) {

        String kakaoId = customUserDetails.getUsername();
        Member member = memberService.findByKakaoId(kakaoId);

        try {
            memberService.updateProfileImage(profileImage, member);

            return ResponseEntity.status(HttpStatus.OK)
                    .body(memberService.getSelfProfileURL(kakaoId));
        } catch (EmptyFileException e) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                    .body(BaseResponseBody.of(400, "파일이 비어있습니다."));
        } catch (BigFileException e) {
            return ResponseEntity.status(HttpStatus.PAYLOAD_TOO_LARGE)
                    .body(BaseResponseBody.of(413, "업로드한 파일의 용량이 20MB 이상입니다."));
        } catch (NotValidExtensionException e) {
            return ResponseEntity.status(HttpStatus.UNSUPPORTED_MEDIA_TYPE)
                    .body(
                            BaseResponseBody.of(
                                    415, "지원하는 확장자가 아닙니다. 지원하는 이미지 형식: jpg, jpeg, pdf, tiff"));
        } catch (IOException e) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                    .body(BaseResponseBody.of(503, "썸네일 이미지 생성 중 예외 발생 (서비스 서버 오류)"));
        } catch (Exception e) {
            e.printStackTrace();

            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(BaseResponseBody.of(500, "서버 오류"));
        }
    }

    @GetMapping("/profile")
    @Operation(
            summary = "프로필 이미지 조회",
            description = "사용자 본인의 (카카오 CDN 또는 Amazon S3) 프로필 이미지 경로를 조회한다.")
    @ApiResponses({
        @ApiResponse(responseCode = "200", description = "정상 반환"),
        @ApiResponse(responseCode = "500", description = "서버 오류")
    })
    public ResponseEntity<?> getSelfProfileURL(
            @AuthenticationPrincipal CustomUserDetails customUserDetails) {
        String kakaoId = customUserDetails.getUsername();

        return ResponseEntity.status(HttpStatus.OK).body(memberService.getSelfProfileURL(kakaoId));
    }

    @DeleteMapping("/profile")
    @Operation(
            summary = "프로필 이미지 삭제",
            description = "사용자 본인의 (카카오 CDN 또는 Amazon S3) 프로필 이미지를 삭제한다.")
    @ApiResponses({
        @ApiResponse(responseCode = "200", description = "정상 삭제"),
        @ApiResponse(responseCode = "500", description = "서버 오류")
    })
    public ResponseEntity<?> deleteSelfProfileURL(
            @AuthenticationPrincipal CustomUserDetails customUserDetails) {
        String kakaoId = customUserDetails.getUsername();

        if (fileService.deleteProfileImageFilesOnAmazonS3(kakaoId)) {
            return ResponseEntity.ok(BaseResponseBody.of(200, "정상적으로 삭제되었습니다."));
        }

        return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                .body(BaseResponseBody.of(500, "서버 오류"));
    }

    @PostMapping("/mydata/search")
    @Operation(summary = "싸피은행에서 회원정보 불러오기. ", description = "싸피은행에서 회원정보 불러오기.")
    @ApiResponses({
        @ApiResponse(responseCode = "200", description = "성공"),
        @ApiResponse(responseCode = "500", description = "서버 오류")
    })
    public ResponseEntity<?> searchMember(Principal principal) {

        try {
            RestClient restClient = RestClient.create();
            Member member = memberRepository.findById(principal.getName()).get();
            String email = member.getEmail();
            if (email == null)
                return ResponseEntity.badRequest()
                        .body(BaseResponseBody.of(400, "회원정보로 가입된 은행정보가 없습니다."));

            return memberService.searchMember(email);

        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.internalServerError().body(BaseResponseBody.of(500, "서버 에러"));
        }
    }
}
