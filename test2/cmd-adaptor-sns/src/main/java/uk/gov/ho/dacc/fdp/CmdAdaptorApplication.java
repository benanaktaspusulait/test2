package uk.gov.ho.dacc.fdp;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication(
        scanBasePackages = {"uk.gov.ho.dacc.fdp"},
        exclude = {org.springframework.boot.autoconfigure.gson.GsonAutoConfiguration.class}
)
public class CmdAdaptorApplication {
    public static void main(String[] args) {
        SpringApplication.run(CmdAdaptorApplication.class, args);
    }
}
