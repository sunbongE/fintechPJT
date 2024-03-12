package com.orange.fintech.auth.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller("/my")
public class MyController {

    @GetMapping()
    public String myPage(){
        System.out.println("myPage 호출");
        return "my";
    }
}
