package com.orange.fintech.group.repository;

import com.orange.fintech.group.entity.CalculateResult;
import com.orange.fintech.group.entity.Group;
import java.util.List;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

public interface CalculateResultRepository extends JpaRepository<CalculateResult, Integer> {

    CalculateResult findByGroup(Group group);

    //    List<CalculateResult> findAllByGroupFetch(Group group);
    @Query(
            "SELECT cr FROM CalculateResult cr join fetch sendMember join fetch receiveMember WHERE cr.group = :group")
    List<CalculateResult> findAllByGroup(@Param("group") Group group);
}
