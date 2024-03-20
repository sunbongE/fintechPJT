package com.orange.fintech.config;

import io.swagger.v3.oas.models.Components;
import io.swagger.v3.oas.models.OpenAPI;
import io.swagger.v3.oas.models.info.Info;
import io.swagger.v3.oas.models.security.SecurityRequirement;
import io.swagger.v3.oas.models.security.SecurityScheme;
import org.springdoc.core.models.GroupedOpenApi;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class SwaggerConfig {

    @Bean
    public OpenAPI openAPI() {

        Info info =
                new Info()
                        .title("Team Orange API")
                        .description("Spring Boot로 개발하는 RESTful API 명세서 입니다.")
                        .version("1.0.0");

        SecurityScheme securityScheme =
                new SecurityScheme()
                        .type(SecurityScheme.Type.APIKEY)
                        .in(SecurityScheme.In.HEADER)
                        .name("Authorization");

        Components components = new Components().addSecuritySchemes("Bearer Token", securityScheme);

        SecurityRequirement securityRequirement = new SecurityRequirement().addList("Bearer Token");

        return new OpenAPI().info(info).components(components).addSecurityItem(securityRequirement);
    }

    @Bean
    public GroupedOpenApi customTestOpenAPi() {
        String[] paths = {"/**"};

        return GroupedOpenApi.builder().group("API 1.0.0").pathsToMatch(paths).build();
    }
}
