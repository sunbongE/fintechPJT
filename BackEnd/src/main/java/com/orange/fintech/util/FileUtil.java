package com.orange.fintech.util;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import org.springframework.stereotype.Component;
import org.springframework.web.multipart.MultipartFile;

@Component
public class FileUtil {
    private String[] imageExtensions = {"jpg", "jpeg", "png", "pdf", "tiff"};

    public File multipartFile2File(MultipartFile multipartFile) {
        File file = new File(multipartFile.getOriginalFilename());

        try {
            file.createNewFile();
            FileOutputStream fos = new FileOutputStream(file);
            fos.write(multipartFile.getBytes());
            fos.close();
        } catch (IOException e) {
            throw new RuntimeException(e);
        }

        return file;
    }

    public void removeFile(File targetFile) { // 로컬파일 삭제
        if (targetFile.exists()) {
            if (targetFile.delete()) {
                // System.out.println("파일이 삭제되었습니다.");
            } else {
                // System.out.println("파일이 삭제되지 못했습니다.");
            }
        }
    }

    public boolean isValidImageExtension(String extension) {
        for (String validExtension : imageExtensions) {
            if (validExtension.equals(extension)) {
                return true;
            }
        }

        return false;
    }

    public boolean isLargerThan20MB(MultipartFile receiptImage) {
        // CLOVA OCR 20MB 초과 업로드 불가
        if (receiptImage.getSize() > 2 * Math.pow(10, 7)) {
            return true;
        }

        return false;
    }
}
