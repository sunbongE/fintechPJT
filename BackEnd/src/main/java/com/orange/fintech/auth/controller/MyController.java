package com.orange.fintech.auth.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller("/my")
public class MyController {

    @GetMapping()
    public String myPage(){
        return "my";
    }
}
