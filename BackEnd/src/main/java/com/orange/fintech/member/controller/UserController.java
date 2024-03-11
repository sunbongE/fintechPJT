package com.orange.fintech.member.controller;

import java.security.Principal;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/v1/user")
public class UserController {

    @GetMapping()
    public ResponseEntity<?> userC(Principal principal) {
        String userEmail = principal.getName();
        System.out.println("principal = " + principal.toString());

        return ResponseEntity.ok("** user Controller **" + userEmail);
    }
}
