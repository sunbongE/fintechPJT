package com.orange.fintech.map.service;

import com.orange.fintech.map.dto.LocationDto;
import java.util.List;

public interface MapService {

    List<LocationDto> getLocations(int groupId);
}
