package uk.gov.ho.dacc.fdp.integration.steps;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import uk.gov.ho.dacc.fdp.util.HashGenerator;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNotEquals;

class IntegrationTestStepsStringTypeTest {

    private final IntegrationTestSteps integrationTestSteps = new IntegrationTestSteps();

    @BeforeEach
    void setUp() {
        IntegrationTestSteps.testId = "test-id-123";
        IntegrationTestSteps.mappingVersion = "2.7.1";
    }

    @Test
    void shouldLeaveEscapedCurlyBracesUnhashed() {
        assertEquals("{literal-value}", integrationTestSteps.stringType("\\{literal-value\\}"));
    }

    @Test
    void shouldStillHashUnescapedCurlyBraces() {
        String hashedValue = integrationTestSteps.stringType("{literal-value}");

        assertEquals(HashGenerator.createHash("{literal-value}", IntegrationTestSteps.testId, false), hashedValue);
        assertNotEquals("{literal-value}", hashedValue);
    }

    @Test
    void shouldReplaceMappingVersionBeforeRestoringEscapedCurlyBraces() {
        assertEquals("{2.7.1}", integrationTestSteps.stringType("\\{mappingVersion\\}"));
    }
}

