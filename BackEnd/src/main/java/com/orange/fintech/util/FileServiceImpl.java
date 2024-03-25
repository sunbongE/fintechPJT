package com.orange.fintech.util;

import com.amazonaws.SdkClientException;
import com.amazonaws.services.s3.AmazonS3;
import com.amazonaws.services.s3.model.CannedAccessControlList;
import com.amazonaws.services.s3.model.PutObjectRequest;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.orange.fintech.common.exception.BigFileException;
import com.orange.fintech.common.exception.EmptyFileException;
import com.orange.fintech.common.exception.NotValidExtensionException;
import com.orange.fintech.member.entity.Member;
import com.orange.fintech.member.entity.ProfileImage;
import com.orange.fintech.member.repository.MemberRepository;
import com.orange.fintech.member.repository.ProfileImageRepository;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.net.URL;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.HashMap;
import java.util.Map;
import org.apache.commons.io.FilenameUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

@Service()
public class FileServiceImpl implements FileService {
    @Value("${spring.servlet.multipart.location}")
    private String uploadPath;

    @Value("${cloud.aws.s3.bucket}")
    private String bucket;

    @Autowired AmazonS3 amazonS3Client;

    @Autowired ProfileImageRepository profileImageRepository;

    @Autowired FileUtil fileUtil;

    @Autowired ImageUtil imageUtil;

    @Autowired MemberRepository memberRepository;

    @Override
    public boolean deleteFileOnAmazonS3(String path) {
        try {
            amazonS3Client.deleteObject(bucket, path);

            return true;
        } catch (SdkClientException e) {
            e.printStackTrace();
        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    /**
     * Amazon S3에서 프로필 이미지, 썸네일 이미지 삭제 후 true/false를 리턴하는 메소드 (삭제 성공/실패와는 무관하게 DB의 레코드는 초기화한다.)
     *
     * @param kakaoId
     * @return true: 삭제 성공, false: 삭제 실패
     * @throws IOException
     */
    @Override
    public boolean deleteProfileImageFilesOnAmazonS3(String kakaoId) {
        boolean result = false;
        ProfileImage profileImage = profileImageRepository.findByKakaoId(kakaoId);

        if (deleteFileOnAmazonS3(profileImage.getProfileImagePath())
                && deleteFileOnAmazonS3(profileImage.getThumbnailImagePath())) {
            result = true;
        }

        profileImage.setProfileImagePath("");
        profileImage.setThumbnailImagePath("");

        return result;
    }

    @Override
    public boolean uploadProfileImageToAmazonS3(MultipartFile multipartFile, Member member)
            throws IOException, EmptyFileException, BigFileException, NotValidExtensionException {
        // 1. 파일 유효성 검사
        // 1-1. 업로드 한 파일이 비어있는지 확인
        if (multipartFile.isEmpty()) {
            throw new EmptyFileException();
        }

        // 1-2. 클라이언트가 업로드한 파일의 확장자 추출 (이미지 확장자인지 검사)
        String extension = FilenameUtils.getExtension(multipartFile.getOriginalFilename());
        if (!fileUtil.isValidImageExtension(extension) || extension.equals("pdf")) {
            throw new NotValidExtensionException();
        }

        // 1-3. 파일 용량 체크
        if (fileUtil.isLargerThan20MB(multipartFile)) {
            throw new BigFileException();
        }

        // 2. File 객체 생성
        File convertedFile = null;

        // 2-1. 파일 명 결정
        // application.properties 파일에 저장된 ${spring.servlet.multipart.location} 값 불러옴 (Amazon S3에 저장할
        // 디렉토리 경로) 예: orange/upload/
        Path root = Paths.get(uploadPath);

        // 카카오 ID + '_' + {파일 명}으로 결정 예: orange/upload/3388366548/3388366548_profile.png
        String amazonProfileFilePath =
                member.getKakaoId() + "/" + member.getKakaoId() + "_profile." + extension;
        String amazonProfileThumbnailFilePath =
                member.getKakaoId() + "/" + member.getKakaoId() + "_thumbnail." + extension;

        // 2-2. 파일 객체 생성 (MultipartFile -> File) (썸네일 생성 및 Amazon S3 업로드 위함)
        convertedFile = fileUtil.multipartFile2File(multipartFile);

        // 2-3. 한 변의 길이가 최대 640인 썸네일 이미지 생성
        File thumbnailFile = imageUtil.createThumbnailImage(convertedFile, 640, 640);

        // 3. ProfileImage 레코드 조회 -> 레코드가 존재하면 AmazonS3의 기존 프로필 이미지 삭제
        ProfileImage profileImage = profileImageRepository.findByMember(member);
        if (profileImage != null) {
            deleteProfileImageFilesOnAmazonS3(member.getKakaoId());
        }

        // 4. Amazon S3 파일 업로드
        try (InputStream inputStream = multipartFile.getInputStream()) {
            // 3-1. 원본 이미지 업로드
            amazonS3Client.putObject(
                    new PutObjectRequest(bucket, amazonProfileFilePath, convertedFile)
                            .withCannedAcl(CannedAccessControlList.PublicRead));

            // 3-2. 썸네일 이미지 업로드
            amazonS3Client.putObject(
                    new PutObjectRequest(bucket, amazonProfileThumbnailFilePath, thumbnailFile)
                            .withCannedAcl(CannedAccessControlList.PublicRead));

        } catch (Exception e) {
            e.printStackTrace();

            return false;
        }

        // 4. 테이블에 프로필 이미지 경로 추가
        // 기존 레코드 없으면 추가, 있으면 업데이트 (사용자가 앱 내에서 프로필 사진을 수정한 적이 있는 경우 레코드 존재)
        if (profileImage == null) {
            profileImage = new ProfileImage();
            profileImage.setMember(member);
        } else { // 4-2. AmazonS3의 기존 프로필 이미지 삭제
            deleteProfileImageFilesOnAmazonS3(member.getKakaoId());
        }

        // 4-3. profile_image 테이블에 Amazon S3 기준 파일 경로 저장
        profileImage.setProfileImagePath(amazonProfileFilePath);
        profileImage.setThumbnailImagePath(amazonProfileThumbnailFilePath);

        profileImageRepository.save(profileImage);

        // 4-3. member 테이블에 Amazon S3 기준 파일 경로 저장
        member.setProfileImage(getProfileThumbnailImageUrl(member.getKakaoId()));
        member.setThumbnailImage(getProfileThumbnailImageUrl(member.getKakaoId()));

        memberRepository.save(member);

        // 5. MultipartFile -> File로 변환하면서 로컬에 저장된 파일 삭제
        fileUtil.removeFile(convertedFile);
        fileUtil.removeFile(thumbnailFile);

        return true;
    }

    @Override
    public String getProfileImageUrl(String kakaoId) {
        URL url =
                amazonS3Client.getUrl(
                        bucket,
                        profileImageRepository.findByKakaoId(kakaoId).getProfileImagePath());

        return url.toString();
    }

    @Override
    public String getProfileThumbnailImageUrl(String kakaoId) {
        URL url =
                amazonS3Client.getUrl(
                        bucket,
                        profileImageRepository.findByKakaoId(kakaoId).getThumbnailImagePath());

        return url.toString();
    }

    @Override
    public String getProfileAndThumbnailImageUrl(String kakaoId) {
        ProfileImage profileImage = profileImageRepository.findByKakaoId(kakaoId);
        URL profileImagePathURL = amazonS3Client.getUrl(bucket, profileImage.getProfileImagePath());
        URL thumbnailImagePathURL =
                amazonS3Client.getUrl(bucket, profileImage.getThumbnailImagePath());

        Map<String, Object> profileAndThumbnailImageUrl = new HashMap<>();

        profileAndThumbnailImageUrl.put("profileImagePath", profileImagePathURL.toString());
        profileAndThumbnailImageUrl.put("thumbnailImagePathURL", thumbnailImagePathURL.toString());

        ObjectMapper objectMapper = new ObjectMapper();

        try {
            return objectMapper.writeValueAsString(profileAndThumbnailImageUrl);
        } catch (JsonProcessingException e) {
            throw new RuntimeException(e);
        }
    }
}
