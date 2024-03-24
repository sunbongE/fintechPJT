package com.orange.fintech.util;

import com.drew.imaging.ImageMetadataReader;
import com.drew.imaging.ImageProcessingException;
import com.drew.metadata.Directory;
import com.drew.metadata.Metadata;
import com.drew.metadata.MetadataException;
import com.drew.metadata.exif.ExifIFD0Directory;
import java.awt.*;
import java.awt.image.BufferedImage;
import java.io.File;
import java.io.IOException;
import javax.imageio.ImageIO;
import org.apache.commons.io.FilenameUtils;
import org.imgscalr.Scalr;
import org.springframework.stereotype.Component;

@Component
public class ImageUtil {

    // EXIF에서 회전 정보를 가져오는 메소드
    public int getOrientation(Metadata metadata) {
        int orientation = 1; // 정방향
        Directory directory = metadata.getFirstDirectoryOfType(ExifIFD0Directory.class);

        // directory는 있는데 그 안에 orientation값이 없을 수 있으므로 null 체크
        if (directory != null && directory.containsTag(ExifIFD0Directory.TAG_ORIENTATION)) {
            try {
                orientation = directory.getInt(ExifIFD0Directory.TAG_ORIENTATION);
            } catch (MetadataException e) {
                throw new RuntimeException(e);
            }
        }

        return orientation;
    }

    // 원본 이미지의 EXIF를 가져와 대상 이미지에 회전 적용
    public BufferedImage adjustImageRotation(
            File originalFile, BufferedImage passedThumbnailImage) {
        Metadata metadata = null;

        try {
            metadata = ImageMetadataReader.readMetadata(originalFile);
        } catch (ImageProcessingException e) {
            throw new RuntimeException(e);
        } catch (IOException e) {
            throw new RuntimeException(e);
        }

        int orientation = getOrientation(metadata);
        BufferedImage rotatedThumbnailImage = null;

        if (orientation == 6) {
            // 90-degree, clockwise rotation (to the right).
            rotatedThumbnailImage = Scalr.rotate(passedThumbnailImage, Scalr.Rotation.CW_90);
        } else if (orientation == 3) {
            // 180-degree, clockwise rotation (to the right).
            rotatedThumbnailImage = Scalr.rotate(passedThumbnailImage, Scalr.Rotation.CW_180);
        } else if (orientation == 8) {
            // 270-degree, clockwise rotation (to the right).
            rotatedThumbnailImage = Scalr.rotate(passedThumbnailImage, Scalr.Rotation.CW_270);
        } else {
            rotatedThumbnailImage = passedThumbnailImage;
        }

        return rotatedThumbnailImage;
    }

    public File createThumbnailImage(File originalImageFile, int targetWidth, int targetHeight)
            throws IOException {
        // 원본 이미지 읽기
        BufferedImage originalImage = ImageIO.read(originalImageFile);

        // 원본 이미지의 EXIF를 가져와 원본 이미지의 사본 (BufferedImage 객체) 회전
        originalImage = adjustImageRotation(originalImageFile, originalImage);

        // 썸네일 이미지 해상도 계산
        int originalWidth = originalImage.getWidth();
        int originalHeight = originalImage.getHeight();

        // 원본 이미지의 해상도가 썸네일 이미지의 해상도보다 작은 경우 Input 그대로 리턴 (해상도 늘리지 않음)
        if (originalWidth <= targetWidth || originalHeight <= targetHeight) {
            return originalImageFile;
        }

        float scale =
                Math.min(
                        (float) targetWidth / originalWidth, (float) targetHeight / originalHeight);

        // 아래 두 줄의 코드가 깔끔한 방법이지만 ((원본) 641 × 641 이미지를 (썸네일) 최대 한 변의 길이가 640인 이미지로 만든다고 했을 때 다시 641 ×
        // 641 이미지가 생성됨 #소수점 오차를 해결하기 위한 방법)
        // int scaledWidth = (int) (originalWidth * scale);
        // int scaledHeight = (int) (originalHeight * scale);

        int scaledWidth = 0;
        int scaledHeight = 0;

        if (originalWidth > originalHeight) {
            scaledWidth = targetWidth;
            scaledHeight = (int) (originalHeight * scale);
        } else {
            scaledWidth = (int) (originalWidth * scale);
            scaledHeight = targetWidth;
        }

        // 썸네일 이미지 생성
        File thumbnailFile = null;
        try {
            String extension = FilenameUtils.getExtension(originalImageFile.getName());
            BufferedImage thumbnailImage = null;

            if (extension.equals("png")) {
                thumbnailImage =
                        new BufferedImage(scaledWidth, scaledHeight, BufferedImage.TYPE_INT_ARGB);
            } else if (extension.equals("jpg")
                    || extension.equals("jpeg")
                    || extension.equals("tiff")) {
                // Images having 4 color channels should not be written to a jpeg file -Stack
                // Overflow
                thumbnailImage =
                        new BufferedImage(scaledWidth, scaledHeight, BufferedImage.TYPE_INT_RGB);
            }

            Graphics2D g2 = thumbnailImage.createGraphics();
            g2.drawImage(originalImage, 0, 0, scaledWidth, scaledHeight, null);
            g2.dispose();

            // profile.png -> profile_thumbnail.png
            thumbnailFile =
                    new File(
                            FilenameUtils.getBaseName(originalImageFile.getName())
                                    + "_thumbnail."
                                    + extension);
            ImageIO.write(thumbnailImage, extension, thumbnailFile);
        } catch (Exception e) {
            throw new IOException();
        }

        return thumbnailFile;
    }
}
