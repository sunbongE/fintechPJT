package com.orange.fintech.member.controller;

import com.orange.fintech.auth.dto.CustomUserDetails;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.security.Principal;

@RestController
@RequestMapping("/api/v1/user")
public class UserController {

    @GetMapping()
    public ResponseEntity<?> userC(Principal principal){
        String userEmail = principal.getName();
        System.out.println("principal = " + principal.toString());

        return ResponseEntity.ok("** user Controller **"+userEmail);
    }
}
