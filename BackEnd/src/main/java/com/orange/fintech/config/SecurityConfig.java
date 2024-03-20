package com.orange.fintech.config;

//import com.orange.fintech.jwt.JWTFilter;
import com.orange.fintech.jwt.JWTFilter;
import com.orange.fintech.jwt.JWTUtil;
//import com.orange.fintech.oauth.handler.CustomSuccessHandler;
//import com.orange.fintech.oauth.service.CustomOAuth2UserService;
import com.orange.fintech.jwt.JwtAuthenticationFilter;
import jakarta.servlet.http.HttpServletRequest;
import lombok.AllArgsConstructor;
import lombok.NoArgsConstructor;
import lombok.RequiredArgsConstructor;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.config.annotation.authentication.configuration.AuthenticationConfiguration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.oauth2.client.web.OAuth2LoginAuthenticationFilter;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;
import org.springframework.web.cors.CorsConfiguration;
import org.springframework.web.cors.CorsConfigurationSource;

import java.util.Collections;

@Configuration
@RequiredArgsConstructor
@EnableWebSecurity
public class SecurityConfig {

    private final JWTFilter jwtFilter;
    private final JwtAuthenticationFilter jwtAuthenticationFilter;
    private final JWTUtil jwtUtil;

//    public SecurityConfig(JwtAuthenticationFilter jwtAuthenticationFilter,AuthenticationConfiguration authenticationConfiguration, JWTFilter jwtFilter, JWTUtil jwtUtil) {
//        this.jwtFilter = jwtFilter;
//        this.jwtAuthenticationFilter = jwtAuthenticationFilter;
//        this.jwtUtil = jwtUtil;
//    }

    @Bean
    public AuthenticationManager authenticationManager(AuthenticationConfiguration configuration) throws Exception {

        return configuration.getAuthenticationManager();
    }

    @Bean
    public BCryptPasswordEncoder bCryptPasswordEncoder() {

        return new BCryptPasswordEncoder();
    }

    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {

        http
                .cors((cors) -> cors
                        .configurationSource(new CorsConfigurationSource() {
                            @Override
                            public CorsConfiguration getCorsConfiguration(HttpServletRequest request) {
                                CorsConfiguration configuration = new CorsConfiguration();

                                configuration.setAllowedOrigins(Collections.singletonList("http://localhost:5000"));
                                configuration.setAllowedMethods(Collections.singletonList("*"));
                                configuration.setAllowCredentials(true);
                                configuration.setAllowedHeaders(Collections.singletonList("*"));
                                configuration.setMaxAge(3600L);
                                configuration.setExposedHeaders(Collections.singletonList("Set-Cookie"));
                                configuration.setExposedHeaders(Collections.singletonList("Authorization"));

                                return configuration;

                            }
                        }));
        http
                .csrf((auth) -> auth.disable());

        http
                .formLogin((auth) -> auth.disable());

        http
                .httpBasic((auth) -> auth.disable());

        //oauth2
//        http
//                .oauth2Login((oauth2) -> oauth2
//                        .userInfoEndpoint((userInfoEndpointConfig) -> userInfoEndpointConfig
//                                .userService(customOAuth2UserService))
//                        .successHandler(customSuccessHandler)
//                );



        http
                .authorizeHttpRequests((auth) -> auth
                        .requestMatchers("/","/swagger-resources/**", "/v3/api-docs/**", "/swagger-ui/**", "/api/v1/auth/**").permitAll()
                        .requestMatchers("/api/v1/admin/**").hasRole("ADMIN")
                        .requestMatchers("/api/v1/groups/**","/api/v1/members/**").hasRole("USER")
                        .anyRequest().authenticated());


        http
                .sessionManagement((session) -> session
                        .sessionCreationPolicy(SessionCreationPolicy.STATELESS));
        //JWTFilter 추가
        http
                .addFilterBefore(jwtAuthenticationFilter, UsernamePasswordAuthenticationFilter.class);

        return http.build();
    }
}