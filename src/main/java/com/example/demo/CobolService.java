package com.example.demo;

import org.springframework.stereotype.Service;

@Service
public class CobolService {

    private final CobolNative cobolNative = new CobolNative();

    public String hello(String name) {
        return cobolNative.callHello(name);
    }
}