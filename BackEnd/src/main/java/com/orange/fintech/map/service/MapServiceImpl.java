package com.orange.fintech.map.service;

import com.orange.fintech.map.dto.LocationDto;
import com.orange.fintech.map.repository.LocationQueryRepository;
import java.util.List;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Slf4j
@Service
@Transactional
@RequiredArgsConstructor
public class MapServiceImpl implements MapService {

    private final LocationQueryRepository locationQueryRepository;

    @Override
    public List<LocationDto> getLocations(int groupId) {
        return locationQueryRepository.getGroupLocations(groupId);
    }
}
