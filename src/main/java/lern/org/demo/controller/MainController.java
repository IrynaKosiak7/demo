package lern.org.demo.controller;

import lern.org.demo.Greeting;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.oauth2.core.user.OAuth2User;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;


@RestController
@RequestMapping("/api")
@Validated
public class MainController {

    @GetMapping("/hello")
    @CrossOrigin(origins = "http://localhost:3000/")
    public Greeting sayHello() {
        OAuth2User user = ((OAuth2User) SecurityContextHolder.getContext().getAuthentication().getPrincipal());
        return new Greeting("Hello!");
    }

    @GetMapping("/chao")
    @CrossOrigin(origins = "http://localhost:3000/")
    @PreAuthorize("hasRole('ROLE_EDIT')")
    public Greeting sayChao() {
        OAuth2User user = ((OAuth2User) SecurityContextHolder.getContext().getAuthentication().getPrincipal());
        return new Greeting("Chao! Come back!");
    }

}
