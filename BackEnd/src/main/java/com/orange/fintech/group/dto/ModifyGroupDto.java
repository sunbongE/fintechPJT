package com.orange.fintech.group.dto;

import jakarta.validation.constraints.NotBlank;
import java.time.LocalDate;
import lombok.Getter;

@Getter
public class ModifyGroupDto {

    @NotBlank private String groupName;
    private String theme;
    private LocalDate startDate;
    private LocalDate endDate;
}
