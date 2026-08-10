package uk.gov.ho.dacc.fdp;

import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;
import org.springframework.context.annotation.Profile;
import org.springframework.stereotype.Component;
import uk.gov.ho.dacc.fdp.service.CmdAdaptorService;

@Component
@RequiredArgsConstructor
@Profile("!test")
public class CommandLineStartupRunner implements CommandLineRunner {

    @Autowired
    private CmdAdaptorService cmdAdaptorService;

    @Override
    public void run(String... args) {
        cmdAdaptorService.run();
    }
}
