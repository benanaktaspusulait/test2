package uk.gov.ho.dacc.fdp.testcontainers;

import com.github.dockerjava.api.exception.NotFoundException;
import org.junit.jupiter.api.AfterAll;
import org.junit.jupiter.api.BeforeAll;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.testcontainers.DockerClientFactory;
import org.testcontainers.containers.GenericContainer;
import org.testcontainers.containers.wait.strategy.Wait;
import org.testcontainers.utility.DockerImageName;

import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.time.Duration;

import static org.junit.jupiter.api.Assertions.assertTrue;
import static org.junit.jupiter.api.Assertions.fail;

@ExtendWith(TestcontainersFailureDiagnostics.class)
class BuiltImageRuntimeIntegrationTest {
    private static final Logger LOG = LoggerFactory.getLogger(BuiltImageRuntimeIntegrationTest.class);
    private static final String IMAGE_UNDER_TEST =
            System.getProperty("sns.runtime.image", "docker-compose-command-adaptor:latest");
    private static final Duration READINESS_TIMEOUT = Duration.ofSeconds(120);
    private static final Duration REQUEST_TIMEOUT = Duration.ofSeconds(2);
    private static final HttpClient HTTP_CLIENT = HttpClient.newHttpClient();

    private static GenericContainer<?> commandAdaptor;

    @BeforeAll
    static void beforeAll() {
        ensureDockerImageExists(IMAGE_UNDER_TEST);

        SnsTestcontainersEnvironment.startInfrastructure();
        commandAdaptor = new GenericContainer<>(DockerImageName.parse(IMAGE_UNDER_TEST))
                .withNetwork(SnsTestcontainersEnvironment.sharedNetwork())
                .withNetworkAliases("command-adaptor")
                .withExposedPorts(7112)
                .withEnv("SPRING_PROFILES_ACTIVE", "docker")
                .withEnv("FDP_APP_KAFKA_TOPIC_SUFFIX", SnsTestcontainersEnvironment.getTopicSuffix())
                .withEnv("FDP_KAFKA_BROKER", SnsTestcontainersEnvironment.kafkaInternalBootstrapServers())
                .withEnv("FDP_KAFKA_SCHEMA_REGISTRY_URL", SnsTestcontainersEnvironment.schemaRegistryInternalUrl())
                .withEnv("FDP_APP_REDIS_END_POINT", SnsTestcontainersEnvironment.redisInternalHost())
                .withEnv("FDP_APP_REDIS_PORT", "6379")
                .withEnv("OTEL_TRACES_EXPORTER", "none")
                .withEnv("OTEL_METRICS_EXPORTER", "none")
                .withEnv("OTEL_LOGS_EXPORTER", "none")
                .waitingFor(Wait.forListeningPort())
                .withStartupTimeout(READINESS_TIMEOUT);

        try {
            commandAdaptor.start();
        } catch (RuntimeException e) {
            dumpCommandAdaptorLogs("container failed to start");
            throw e;
        }
    }


    @AfterAll
    static void afterAll() {
        if (commandAdaptor != null && commandAdaptor.isRunning()) {
            commandAdaptor.stop();
        }
    }

    @Test
    void builtImageBootsAndReachesReadiness() {
        waitForReady("/actuator/health/readiness");
        assertTrue(commandAdaptor.isRunning(), "Built image container must remain running after readiness");
    }

    private static void ensureDockerImageExists(String imageName) {
        try {
            DockerClientFactory.instance().client().inspectImageCmd(imageName).exec();
            LOG.info("Validated local image exists: {}", imageName);
        } catch (NotFoundException notFound) {
            throw new IllegalStateException("Required local image not found: " + imageName, notFound);
        }
    }

    private static void waitForReady(String readinessPath) {
        long deadline = System.nanoTime() + READINESS_TIMEOUT.toNanos();
        String readinessUrl = "http://" + commandAdaptor.getHost() + ":" + commandAdaptor.getMappedPort(7112) + readinessPath;
        String lastFailure = "no successful readiness response";

        while (System.nanoTime() < deadline) {
            try {
                HttpRequest request = HttpRequest.newBuilder()
                        .uri(URI.create(readinessUrl))
                        .header("Accept", "application/json")
                        .timeout(REQUEST_TIMEOUT)
                        .GET()
                        .build();
                HttpResponse<String> response = HTTP_CLIENT.send(request, HttpResponse.BodyHandlers.ofString());
                if (response.statusCode() == 200 && response.body() != null && response.body().contains("\"status\":\"UP\"")) {
                    LOG.info("Readiness confirmed at {}", readinessUrl);
                    return;
                }
                lastFailure = "status=" + response.statusCode() + " body=" + response.body();
            } catch (Exception e) {
                lastFailure = e.toString();
            }

            if (!commandAdaptor.isRunning()) {
                dumpCommandAdaptorLogs("container exited before readiness");
                fail("Built image container exited before readiness. Last readiness failure: " + lastFailure);
            }

            try {
                Thread.sleep(500L);
            } catch (InterruptedException e) {
                Thread.currentThread().interrupt();
                fail("Interrupted while waiting for readiness");
            }
        }

        dumpCommandAdaptorLogs("readiness timeout");
        SnsTestcontainersEnvironment.dumpContainerLogs("image readiness timeout");
        fail("Readiness did not reach UP within " + READINESS_TIMEOUT.toSeconds() + "s. Last failure: " + lastFailure);
    }

    private static void dumpCommandAdaptorLogs(String reason) {
        if (commandAdaptor == null || commandAdaptor.getContainerId() == null) {
            LOG.error("Built image diagnostics requested ({}), but command-adaptor container was not created", reason);
            return;
        }
        try {
            LOG.error("Built image diagnostics requested: {}", reason);
            LOG.error("Built image container state: {}", commandAdaptor.getCurrentContainerInfo().getState());
            LOG.error("--- command-adaptor container logs begin ---\n{}\n--- command-adaptor container logs end ---",
                    commandAdaptor.getLogs());
        } catch (RuntimeException e) {
            LOG.error("Unable to collect command-adaptor container diagnostics", e);
        }
    }
}

