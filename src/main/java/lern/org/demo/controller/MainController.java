package lern.org.demo.controller;

import lern.org.demo.Greeting;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class MainController {

    @GetMapping("/api/hello")
    @CrossOrigin(origins = "http://localhost:3000/")
    public Greeting sayHello(){
        return new Greeting("Hello world");
    }
    @GetMapping("/api/chao")
    @CrossOrigin(origins = "http://localhost:3000/")
    public Greeting sayChao(){
        return new Greeting("Chao");
    }
}
