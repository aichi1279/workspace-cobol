package com.example.demo;

public class CobolNative {

    static {
        System.loadLibrary("coboljni");
    }

    public native String callHello(String name);
}   