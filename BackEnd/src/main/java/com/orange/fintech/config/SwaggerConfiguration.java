package com.orange.fintech.config;

import io.swagger.v3.oas.annotations.OpenAPIDefinition;
import io.swagger.v3.oas.annotations.info.Info;
import lombok.RequiredArgsConstructor;
import org.springdoc.core.models.GroupedOpenApi;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@OpenAPIDefinition(
        info =
                @Info(
                        title = "Team Orange Swagger",
                        description = "Spring Boot로 개발하는 RESTful API 명세서 입니다.",
                        version = "v1.0.0"))
@Configuration
@RequiredArgsConstructor
public class SwaggerConfiguration {

    @Bean
    public GroupedOpenApi customTestOpenAPi() {
        String[] paths = {"/**"};

        return GroupedOpenApi.builder()
                .group("Team Orange에서 사용하는 도메인에 대한 API")
                .pathsToMatch(paths)
                .build();
    }
}
