package oracle.tdc.springboot;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class Controller {
    @GetMapping("/greetings")

    public String greetings(){
        return "Hello Spring Boot";
    }
}
