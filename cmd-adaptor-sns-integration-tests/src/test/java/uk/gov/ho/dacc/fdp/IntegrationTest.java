package uk.gov.ho.dacc.fdp;

import io.cucumber.junit.Cucumber;
import io.cucumber.junit.CucumberOptions;
import lombok.extern.slf4j.Slf4j;
import org.junit.runner.RunWith;

@Slf4j
@RunWith(Cucumber.class)
@CucumberOptions(features = "src/test/resources/features"
        , glue = "uk.gov.ho.dacc.fdp.steps"
        , plugin = {"pretty", "summary", "uk.gov.ho.dacc.fdp.steps.SnsSteps", "html:target/cucumber.html"}
        , tags = "not @ignore"
)
public class IntegrationTest {
}
