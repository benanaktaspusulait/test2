package uk.gov.ho.dacc.fdp.testcontainers;

import org.junit.jupiter.api.Test;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.List;
import java.util.stream.Stream;

import static org.junit.jupiter.api.Assertions.assertTrue;

class TestcontainersSuiteCoverageTest {
    private static final Path FEATURES = Path.of("src", "test", "resources", "features");
    private static final int MINIMUM_FEATURE_COUNT = 7;
    private static final int MINIMUM_SCENARIO_COUNT = 14;

    @Test
    void fullSuiteCannotSilentlyLoseFeaturesOrScenarios() throws IOException {
        List<Path> featureFiles;
        try (Stream<Path> files = Files.list(FEATURES)) {
            featureFiles = files
                    .filter(path -> path.getFileName().toString().endsWith(".feature"))
                    .toList();
        }

        long scenarioCount = 0;
        for (Path featureFile : featureFiles) {
            try (Stream<String> lines = Files.lines(featureFile)) {
                scenarioCount += lines
                        .map(String::stripLeading)
                        .filter(line -> line.startsWith("Scenario:") || line.startsWith("Scenario Outline:"))
                        .count();
            }
        }

        assertTrue(featureFiles.size() >= MINIMUM_FEATURE_COUNT,
                "Testcontainers suite must include at least " + MINIMUM_FEATURE_COUNT + " feature files");
        assertTrue(scenarioCount >= MINIMUM_SCENARIO_COUNT,
                "Testcontainers suite must include at least " + MINIMUM_SCENARIO_COUNT + " scenarios");
    }
}
