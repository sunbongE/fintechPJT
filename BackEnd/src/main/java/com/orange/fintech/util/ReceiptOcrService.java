package com.orange.fintech.util;

import static org.springframework.http.MediaType.MULTIPART_FORM_DATA;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.orange.fintech.common.exception.BigFileException;
import com.orange.fintech.common.exception.EmptyFileException;
import com.orange.fintech.common.exception.NotValidExtensionException;
import java.io.File;
import java.text.SimpleDateFormat;
import java.util.*;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.io.FilenameUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.io.FileSystemResource;
import org.springframework.stereotype.Service;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.client.RestClient;
import org.springframework.web.multipart.MultipartFile;

@Slf4j
@Service
public class ReceiptOcrService {
    @Autowired FileUtil fileUtil;

    @Value("${clova.ocr.credentials.APIGW-Invoke-URL}")
    private String APIGW_Invoke_URL;

    @Value("${clova.ocr.credentials.Secret-Key}")
    private String Secret_Key;

    private Map<String, Object> messageMap;

    RestClient restClient = RestClient.create();

    public JsonNode singleRequest(MultipartFile receiptImage)
            throws EmptyFileException, BigFileException, NotValidExtensionException {
        // 0-1. 업로드 한 파일이 비어있는지 확인
        if (receiptImage.isEmpty()) {
            throw new EmptyFileException();
        }

        // 0-2. 파일 확장자 체크 (“jpg”, “jpeg”, “png”, "pdf","tiff" 이미지 포맷 지원)
        String extension = FilenameUtils.getExtension(receiptImage.getOriginalFilename());
        if (!fileUtil.isValidImageExtension(extension)) {
            throw new NotValidExtensionException();
        }

        // 0-3. 파일 용량 체크
        if (fileUtil.isLargerThan20MB(receiptImage)) {
            throw new BigFileException();
        }

        // 1. 요청 Body에 넣을 객체 생성 (requestBody #JSON)
        MultiValueMap<String, Object> requestBody = new LinkedMultiValueMap<>();

        // 2. requestBody 객체에 넣을 JSON 객체 생성 (messageMap) #샘플: {"version": "V2","requestId":
        // "string","timestamp": 0,"images": [{ "format": "jpg", "name": "20240124_102334" }]}
        messageMap = new HashMap<>();

        // 2-1. messageMap에 값 (key: version #String) 추가
        messageMap.put("version", "V2");

        // 2-2. messageMap에 추가할 값 (key: requestId #String, timestamp #String) 생성
        // 2-2-1. 현재 시각을 String 타입으로 생성
        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss.SSS"); // SSS: 밀리초
        Calendar calendar = Calendar.getInstance();
        String now = dateFormat.format(calendar.getTime());

        // 2-2-2. messageMap에 String 타입의 현재 시각을 value로 추가
        messageMap.put("requestId", now);
        messageMap.put("timestamp", System.currentTimeMillis());

        // 2-3. messageMap에 추가할 값 (key: images #list) 생성
        // 2-3-1. messageMap에 추가할 List 객체 생성 (images)
        List<Map<String, Object>> images = new ArrayList<>();

        // 2-3-2. images에 추가할 JSON 객체 생성 (image)
        Map<String, Object> image = new HashMap<>();

        // 2-3-3. image에 값 추가
        // 2-3-3-1. 클라이언트가 업로드한 파일의 확장자 추출
        image.put("format", extension);

        // 2-3-3-2. 클라이언트가 업로드한 파일의 이름 추출
        String filename = receiptImage.getOriginalFilename();
        image.put("name", filename);

        // 2-4. images 리스트에 image 객체 (JSON) 추가
        images.add(image);

        // 2-5. messageMap에 값 (key: images #list) 추가
        messageMap.put("images", images);

        // 3. 요청 Body에 넣을 객체인 requestBody에 값 (key: message #JSON) 추가
        requestBody.add("message", messageMap);

        // 4. 요청 Body에 들어갈 객체인 requestBody에 값 (key: file #FileSystemResource) 추가
        // 4-1. MultipartFile -> File 변환
        File convertedFile = fileUtil.multipartFile2File(receiptImage);
        // 4-2. File -> FileSystemResource 변환
        requestBody.add("file", new FileSystemResource(convertedFile));

        // 응답을 저장할 변수 선언
        RestClient.ResponseSpec response = null;
        String response2String = null;
        JsonNode response2Json = null;

        try {
            response =
                    restClient
                            .post()
                            .uri(APIGW_Invoke_URL)
                            .contentType(MULTIPART_FORM_DATA)
                            .header("X-OCR-SECRET", Secret_Key)
                            .body(requestBody)
                            .retrieve();

            response2String = response.body(String.class);
            ObjectMapper objectMapper = new ObjectMapper();

            try {
                response2Json = objectMapper.readTree(response2String);
            } catch (Exception e) {
                e.printStackTrace();
            }

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            fileUtil.removeFile(convertedFile); // 서비스 서버에 저장된 파일 삭제
        }

        return response2Json;
    }
}
