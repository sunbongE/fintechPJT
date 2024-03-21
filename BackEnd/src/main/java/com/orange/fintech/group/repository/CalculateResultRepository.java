package com.orange.fintech.group.repository;

import com.orange.fintech.group.entity.CalculateResult;
import com.orange.fintech.group.entity.Group;
import java.util.List;
import org.springframework.data.jpa.repository.JpaRepository;

public interface CalculateResultRepository extends JpaRepository<CalculateResult, Integer> {

    CalculateResult findByGroup(Group group);

    List<CalculateResult> findAllByGroup(Group group);
}
