package com.orange.fintech.util;

import com.orange.fintech.common.exception.BigFileException;
import com.orange.fintech.common.exception.EmptyFileException;
import com.orange.fintech.common.exception.NotValidExtensionException;
import com.orange.fintech.member.entity.Member;
import java.io.IOException;
import org.springframework.web.multipart.MultipartFile;

public interface FileService {
    boolean deleteFileOnAmazonS3(String path);

    boolean deleteProfileImageFilesOnAmazonS3(String kakaoId);

    boolean uploadProfileImageToAmazonS3(MultipartFile multipartFile, Member member)
            throws IOException, EmptyFileException, BigFileException, NotValidExtensionException;

    String getProfileImageUrl(String kakaoId);

    String getProfileThumbnailImageUrl(String kakaoId);

    String getProfileAndThumbnailImageUrl(String kakaoId);
}
