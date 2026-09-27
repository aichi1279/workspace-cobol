package com.example.demo;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class HelloController {

    private final CobolService cobolService;

    public HelloController(CobolService cobolService) {
        this.cobolService = cobolService;
    }

    @GetMapping("/api/hello")
    public String hello(
            @RequestParam(defaultValue = "World") String name) {

        return cobolService.hello(name);
    }
}