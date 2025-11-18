package com.example.java_spring_jenkins;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;


@RestController
public class HelloController {
	  @GetMapping("/")
	    public String hello() {
	        return "Hello World java";
	    }
}




