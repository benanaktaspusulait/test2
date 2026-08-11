package uk.gov.ho.dacc.fdp;

import io.cucumber.junit.Cucumber;
import io.cucumber.junit.CucumberOptions;
import lombok.extern.slf4j.Slf4j;
import org.junit.ClassRule;
import org.junit.runner.RunWith;
import org.junit.rules.ExternalResource;
import uk.gov.ho.dacc.fdp.testcontainers.SnsTestcontainersEnvironment;

@Slf4j
@RunWith(Cucumber.class)
@CucumberOptions(features = "src/test/resources/features"
        , glue = "uk.gov.ho.dacc.fdp.steps"
        , plugin = {"pretty", "summary", "uk.gov.ho.dacc.fdp.steps.SnsSteps", "html:target/cucumber.html"}
)
public class IntegrationTest {
    @ClassRule
    public static final ExternalResource testcontainersPrerequisites = new ExternalResource() {
        @Override
        protected void before() {
            SnsTestcontainersEnvironment.assumeDockerAvailableIfEnabled();
        }
    };
}
