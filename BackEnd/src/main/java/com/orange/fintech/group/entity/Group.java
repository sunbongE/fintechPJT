package com.orange.fintech.group.entity;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.orange.fintech.group.dto.GroupCreateDto;
import jakarta.persistence.*;
import jakarta.validation.constraints.NotNull;
import java.time.LocalDate;
import lombok.Getter;
import lombok.Setter;
import org.hibernate.annotations.ColumnDefault;
import org.hibernate.annotations.DynamicInsert;

@Entity
@Getter
@Setter
@DynamicInsert
@Table(name = "trip_group")
// @DynamicUpdate
public class Group {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int groupId;

    @NotNull
    @Column(length = 10)
    private String groupName;

    @NotNull
    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd", timezone = "Asia/Seoul")
    private LocalDate startDate;

    @NotNull
    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd", timezone = "Asia/Seoul")
    private LocalDate endDate;

    @Column(length = 5)
    private String theme;

    @NotNull
    @ColumnDefault("false")
    private Boolean isCalculateDone;

    public Group(GroupCreateDto dto) {
        this.groupName = dto.getGroupName();
        this.startDate = dto.getStartDate();
        this.endDate = dto.getEndDate();
        this.theme = dto.getTheme();
    }

    public Group() {}

    @Override
    public String toString() {
        return "Group{"
                + "groupId="
                + groupId
                + ", groupName='"
                + groupName
                + '\''
                + ", startDate="
                + startDate
                + ", endDate="
                + endDate
                + ", theme='"
                + theme
                + '\''
                + ", isCalculateDone="
                + isCalculateDone
                + '}';
    }
}
