package uk.gov.ho.dacc.fdp.integration;

import io.cucumber.junit.Cucumber;
import io.cucumber.junit.CucumberOptions;
import lombok.extern.slf4j.Slf4j;
import org.junit.runner.RunWith;

@SuppressWarnings("squid:S2187")
@Slf4j
@RunWith(Cucumber.class)
@CucumberOptions(
        features = "src/test/resources/features",
        glue = "uk.gov.ho.dacc.fdp.integration.steps",
        plugin = "uk.gov.ho.dacc.fdp.integration.steps.IntegrationTestSteps",
        tags = "not @ignore"
//        tags = "@invalidGBSourceData"
        //dryRun = true

)

public class IntegrationTest {
}