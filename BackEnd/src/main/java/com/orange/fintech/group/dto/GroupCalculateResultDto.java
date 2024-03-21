package com.orange.fintech.group.dto;

import com.orange.fintech.group.entity.CalculateResult;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Getter;
import lombok.ToString;

@Getter
@ToString
@Schema(description = "최종 정산 내역 Dto")
public class GroupCalculateResultDto {

    // 받은 사람
    @Schema(description = "돈 받은 사람 식별번호")
    private String receiveKakaoId;

    @Schema(description = "돈 받은 사람 이름")
    private String receiveName;

    @Schema(description = "돈 받은 사람 썸네일 이미지 주소")
    private String receiveImage;

    // 보낸 사람
    @Schema(description = "돈 보낸 사람 식별자")
    private String sendKakaoId;

    @Schema(description = "돈 보낸 사람 이름")
    private String sendName;

    @Schema(description = "돈 보낸 사람 썸네일 이미지 주소")
    private String sendImage;

    // 송금 금액
    @Schema(description = "송금 금액")
    private long amount;

    public GroupCalculateResultDto(CalculateResult calculateResult) {
        this.receiveKakaoId = calculateResult.getReceiveMember().getKakaoId();
        this.receiveImage = calculateResult.getReceiveMember().getThumbnailImage();
        this.receiveName = calculateResult.getReceiveMember().getName();
        this.sendKakaoId = calculateResult.getSendMember().getKakaoId();
        this.sendImage = calculateResult.getSendMember().getThumbnailImage();
        this.sendName = calculateResult.getSendMember().getName();
        this.amount = calculateResult.getAmount();
    }
}
