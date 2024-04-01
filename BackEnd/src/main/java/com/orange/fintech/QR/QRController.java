package com.orange.fintech.QR;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller("/")
public class QRController {

    @GetMapping()
    public String QRpage() {
        return "main";
    }
}
