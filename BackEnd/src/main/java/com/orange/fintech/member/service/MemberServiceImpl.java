package com.orange.fintech.member.service;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.orange.fintech.account.entity.Account;
import com.orange.fintech.account.repository.AccountRepository;
import com.orange.fintech.common.BaseResponseBody;
import com.orange.fintech.common.exception.BigFileException;
import com.orange.fintech.common.exception.EmptyFileException;
import com.orange.fintech.common.exception.NotValidExtensionException;
import com.orange.fintech.jwt.JWTUtil;
import com.orange.fintech.member.dto.PrimaryAccountRes;
import com.orange.fintech.member.entity.FcmToken;
import com.orange.fintech.member.entity.Member;
import com.orange.fintech.member.repository.FcmTokenRepository;
import com.orange.fintech.member.repository.MemberRepository;
import com.orange.fintech.member.repository.ProfileImageRepository;
import com.orange.fintech.oauth.dto.MemberSearchResponseDto;
import com.orange.fintech.redis.service.RedisService;
import com.orange.fintech.util.FileService;
import jakarta.transaction.Transactional;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.ResponseEntity;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestClient;
import org.springframework.web.multipart.MultipartFile;

@Slf4j
@Service
public class MemberServiceImpl implements MemberService {
    @Autowired MemberRepository memberRepository;

    @Autowired AccountRepository accountRepository;

    @Autowired RedisService redisService;

    @Autowired JWTUtil jWTUtil;

    @Autowired PasswordEncoder passwordEncoder;

    @Autowired FileService fileService;

    @Autowired ProfileImageRepository profileImageRepository;

    @Autowired FcmTokenRepository fcmTokenRepository;

    static final String SUCCESS = "\"succeed\"";

    @Value("${ssafy.bank.search}")
    private String searchMember;

    @Value("${ssafy.bank.api-key}")
    private String apiKey;

    @Override
    public ResponseEntity<?> searchMember(String email) throws JsonProcessingException {

        RestClient restClient = RestClient.create();
        RestClient.ResponseSpec response = null;

        Map<String, String> req = new HashMap<>();
        req.put("userId", email);
        req.put("apiKey", apiKey);

        response = restClient.post().uri(searchMember).body(req).retrieve();
        JsonNode bankResponse = new ObjectMapper().readTree(response.body(String.class));

        String statudCode = String.valueOf(bankResponse.get("code"));
        //        log.info("statudCode: {}",statudCode);

        if (statudCode.equals(SUCCESS)) {
            JsonNode userKey = bankResponse.get("payload").get("userKey");
            String data = userKey.toString().substring(1, userKey.toString().length() - 1);
            log.info("저장할 데이터:{}", data);

            Member member = memberRepository.findByEmail(email);

            member.setUserKey(data);
            memberRepository.save(member);

            //            log.info("userKey : {}", userKey);
            return ResponseEntity.ok().body(BaseResponseBody.of(200, "성공적으로 userKey 저장함."));
        } else {
            return ResponseEntity.ok().body(BaseResponseBody.of(400, "잘못된 요청"));
        }
    }

    // 그룹원 검색 응답
    @Override
    public MemberSearchResponseDto findByEmail(String email) {
        Member member = memberRepository.findByEmail(email);

        MemberSearchResponseDto memberSearchResponseDto = new MemberSearchResponseDto();
        memberSearchResponseDto.setKakaoId(member.getKakaoId());
        memberSearchResponseDto.setEmail(member.getEmail());
        memberSearchResponseDto.setName(member.getName());
        memberSearchResponseDto.setProfileImage(member.getProfileImage());
        memberSearchResponseDto.setThumbnailImage(member.getThumbnailImage());

        return memberSearchResponseDto;
    }

    @Override
    public List<Account> findAccountsByKakaoId(Member member) {
        List<Account> accountList = accountRepository.findByMember(member);

        return accountList;
    }

    @Override
    public PrimaryAccountRes findMyPrimaryAccount(Member member) {
        List<Account> accountList = accountRepository.findByMemberAndIsPrimaryAccountIsTrue(member);
        log.info("accountList: {}", accountList);
        return PrimaryAccountRes.of(accountList.get(0));
    }

    @Override
    public Member findByKakaoId(String id) {
        return memberRepository.findByKakaoId(id);
    }

    @Override
    @Transactional
    public boolean logout(String accessToken, String fcmToken) {
        String id = jWTUtil.getKakaoId(accessToken);

        if (redisService.delete(id)) {
            return true;
        }

        return false;
    }

    @Override
    public boolean updatePin(String kakaoId, String pin) {
        Member member = findByKakaoId(kakaoId);
        member.setPin(passwordEncoder.encode(pin));

        try {
            memberRepository.save(member);
        } catch (Exception e) {
            e.printStackTrace();

            return false;
        }

        return true;
    }

    @Override
    public boolean verifyPin(String kakaoId, String pin) {
        Member member = findByKakaoId(kakaoId);

        return passwordEncoder.matches(pin, member.getPin());
    }

    @Override
    public boolean deleteUser(String kakaoId) {
        try {
            // 1. Member 테이블에서 레코드 삭제
            memberRepository.deleteById(kakaoId);

            // 2. Redis에서 Refresh token 삭제
            redisService.delete(kakaoId);

            return true;
        } catch (Exception e) {
            e.printStackTrace();

            return false;
        }
    }

    @Override
    public boolean updateProfileImage(MultipartFile multipartFile, Member member)
            throws IOException, EmptyFileException, BigFileException, NotValidExtensionException {
        return fileService.uploadProfileImageToAmazonS3(multipartFile, member);
    }

    @Override
    public String getSelfProfileURL(String kakaoId) {
        return fileService.getProfileAndThumbnailImageUrl(kakaoId);
    }

    @Override
    public void saveFcmToken(String kakaoId, String fcmTokenString) {
        FcmToken fcmTokenRecord = new FcmToken();

        fcmTokenRecord.setMember(memberRepository.findByKakaoId(kakaoId));
        fcmTokenRecord.setFcmToken(fcmTokenString);

        fcmTokenRepository.save(fcmTokenRecord);
    }
}
