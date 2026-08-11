package uk.gov.ho.dacc.fdp.testcontainers;

import org.apache.kafka.clients.admin.AdminClient;
import org.apache.kafka.clients.admin.NewTopic;
import org.junit.Assume;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.boot.builder.SpringApplicationBuilder;
import org.springframework.context.ConfigurableApplicationContext;
import org.testcontainers.DockerClientFactory;
import org.testcontainers.containers.GenericContainer;
import org.testcontainers.containers.Network;
import org.testcontainers.containers.wait.strategy.Wait;
import org.testcontainers.lifecycle.Startables;
import org.testcontainers.images.builder.Transferable;
import org.testcontainers.utility.DockerImageName;
import uk.gov.ho.dacc.fdp.CmdAdaptorApplication;

import java.net.URI;
import java.net.InetAddress;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.time.Duration;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.UUID;
import java.util.concurrent.TimeUnit;
import java.util.stream.Stream;

public final class SnsTestcontainersEnvironment {
    private static final Logger LOG = LoggerFactory.getLogger(SnsTestcontainersEnvironment.class);

    private static final String REDIS_IMAGE = "redis:5.0.6";
    private static final String KAFKA_IMAGE = "confluentinc/cp-kafka:7.9.7";
    private static final String ZOOKEEPER_IMAGE = "confluentinc/cp-zookeeper:7.9.7";
    private static final String SCHEMA_REGISTRY_IMAGE = "confluentinc/cp-schema-registry:7.9.7";
    private static final String AGGREGATE_IMAGE_BASE = "docker.digital.homeoffice.gov.uk/dacc-aws/fdp-aggregate-";
    private static final String AGGREGATOR_CORE_VERSION = System.getProperty("aggregator.core.version", "10.3.11");
    private static final boolean TESTCONTAINERS_ENABLED =
            Boolean.parseBoolean(System.getProperty("sns.testcontainers.enabled", "false"));
    private static final boolean SKIP_IF_DOCKER_UNAVAILABLE =
            Boolean.parseBoolean(System.getProperty("sns.testcontainers.skip-if-docker-unavailable", "true"));
    private static final boolean AGGREGATORS_ENABLED =
            Boolean.parseBoolean(System.getProperty("sns.testcontainers.aggregators.enabled", "false"));

    private static final String KAFKA_ALIAS = "kafka";
    private static final String ZOOKEEPER_ALIAS = "zookeeper";
    private static final String REDIS_ALIAS = "redis";
    private static final String SCHEMA_REGISTRY_ALIAS = "schema-registry";

    private static final Network NETWORK = Network.newNetwork();
    private static final DockerImageName KAFKA_IMAGE_NAME = DockerImageName.parse(KAFKA_IMAGE)
            .asCompatibleSubstituteFor("apache/kafka");
    private static final String KAFKA_INTERNAL_BOOTSTRAP = "PLAINTEXT://" + KAFKA_ALIAS + ":29092";
    private static final String TOPIC_SUFFIX = "tc" + UUID.randomUUID().toString().replace("-", "").substring(0, 8);
    private static final String RUN_ID = UUID.randomUUID().toString().replace("-", "").substring(0, 8);

    private static final GenericContainer<?> REDIS = new GenericContainer<>(DockerImageName.parse(REDIS_IMAGE))
            .withNetwork(NETWORK)
            .withNetworkAliases(REDIS_ALIAS)
            .withExposedPorts(6379)
            .waitingFor(Wait.forLogMessage(".*Ready to accept connections.*", 1))
            .withStartupTimeout(Duration.ofSeconds(60));

    private static final GenericContainer<?> ZOOKEEPER = new GenericContainer<>(DockerImageName.parse(ZOOKEEPER_IMAGE))
            .withNetwork(NETWORK)
            .withNetworkAliases(ZOOKEEPER_ALIAS)
            .withEnv("ZOOKEEPER_CLIENT_PORT", "2181")
            .withEnv("ZOOKEEPER_TICK_TIME", "2000")
            .withExposedPorts(2181)
            .waitingFor(Wait.forListeningPort())
            .withStartupTimeout(Duration.ofSeconds(120));

    private static final GenericContainer<?> KAFKA = new CpKafkaContainer(KAFKA_IMAGE_NAME)
            .withNetwork(NETWORK)
            .withNetworkAliases(KAFKA_ALIAS)
            .withStartupTimeout(Duration.ofSeconds(120));

    private static final GenericContainer<?> SCHEMA_REGISTRY = new GenericContainer<>(DockerImageName.parse(SCHEMA_REGISTRY_IMAGE))
            .withNetwork(NETWORK)
            .withNetworkAliases(SCHEMA_REGISTRY_ALIAS)
            .withExposedPorts(8081)
            .withEnv("SCHEMA_REGISTRY_HOST_NAME", SCHEMA_REGISTRY_ALIAS)
            .withEnv("SCHEMA_REGISTRY_KAFKASTORE_BOOTSTRAP_SERVERS", KAFKA_INTERNAL_BOOTSTRAP)
            .withEnv("SCHEMA_REGISTRY_SCHEMA_COMPATIBILITY_LEVEL", "NONE")
            .waitingFor(Wait.forHttp("/subjects").forStatusCode(200))
            .withStartupTimeout(Duration.ofSeconds(120));

    private static final GenericContainer<?> AGGREGATE_PARTY = aggregateContainer(
            "party", 7101, 8101, 9011, "party-aggregate");
    private static final GenericContainer<?> AGGREGATE_OBJECT = aggregateContainer(
            "object", 7102, 8102, 9012, "object-aggregate");
    private static final GenericContainer<?> AGGREGATE_LOCATION = aggregateContainer(
            "location", 7103, 8103, 9013, "location-aggregate");
    private static final GenericContainer<?> AGGREGATE_EVENT = aggregateContainer(
            "event", 7104, 8104, 9014, "event-aggregate");
    private static final GenericContainer<?> AGGREGATE_SERVICE = aggregateContainer(
            "service", 7105, 8105, 9015, "service-aggregate");


    private static volatile boolean redisStarted = false;
    private static volatile boolean messagingStarted = false;
    private static volatile boolean applicationStarted = false;
    private static volatile boolean networkClosed = false;
    private static volatile boolean dockerAvailabilityChecked = false;
    private static volatile RuntimeException infrastructureStartupFailure;
    private static ConfigurableApplicationContext applicationContext;
    private static int applicationPort;

    private SnsTestcontainersEnvironment() {
    }

    public static synchronized void assumeDockerAvailableIfEnabled() {
        if (!TESTCONTAINERS_ENABLED || dockerAvailabilityChecked) {
            return;
        }

        String message = "SNS Testcontainers integration tests require a reachable Docker daemon with a supported "
                + "Docker API. Set sns.testcontainers.enabled=false, use a non-Testcontainers profile, or provide "
                + "Docker access to run these tests.";
        try {
            boolean dockerAvailable = DockerClientFactory.instance().isDockerAvailable();
            if (!dockerAvailable && SKIP_IF_DOCKER_UNAVAILABLE) {
                Assume.assumeTrue(message, false);
            }
            if (!dockerAvailable) {
                throw new IllegalStateException(message);
            }
            dockerAvailabilityChecked = true;
        } catch (RuntimeException e) {
            if (SKIP_IF_DOCKER_UNAVAILABLE) {
                Assume.assumeNoException(message, e);
            }
            throw e;
        }
    }

    public static synchronized void startInfrastructure() {
        if (networkClosed) {
            throw new IllegalStateException("SNS Testcontainers environment has already been shut down");
        }
        assumeDockerAvailableIfEnabled();
        if (messagingStarted) {
            return;
        }
        if (infrastructureStartupFailure != null) {
            throw infrastructureStartupFailure;
        }

        LOG.info("Starting SNS Testcontainers infrastructure");
        try {
            Startables.deepStart(Stream.of(REDIS, ZOOKEEPER).filter(container -> !container.isRunning())).join();
            redisStarted = true;
            KAFKA.start();
            SCHEMA_REGISTRY.start();
            messagingStarted = true;

            createRequiredTopics();
            validateSchemaRegistryRoundTrip();
        } catch (RuntimeException e) {
            messagingStarted = false;
            infrastructureStartupFailure = e;
            dumpContainerLogs("infrastructure startup failure: " + e.getMessage());
            shutdown();
            throw e;
        }
    }

    public static synchronized void startRedis() {
        assertEnvironmentOpen();
        if (redisStarted) {
            return;
        }

        try {
            REDIS.start();
            redisStarted = true;
        } catch (RuntimeException e) {
            dumpContainerLogs("Redis startup failure: " + e.getMessage());
            shutdown();
            throw e;
        }
    }

    public static synchronized void startApplication() {
        if (applicationStarted) {
            return;
        }

        startInfrastructure();

        Map<String, Object> props = new HashMap<>();
        props.put("spring.profiles.active", "int");
        props.put("spring.data.redis.host", getRedisHost());
        props.put("spring.data.redis.port", String.valueOf(getRedisPort()));

        props.put("app.kafka.bootstrap-servers", getKafkaBootstrapServers());
        props.put("app.kafka.schema-registry-url", getSchemaRegistryUrl());
        props.put("app.kafka.application-id", "fdp-cmd-adaptor-sns-" + TOPIC_SUFFIX);
        props.put("app.kafka.client-id", "fdp-cmd-adaptor-sns-" + TOPIC_SUFFIX);

        props.put("app.cdlz-kafka.bootstrap-servers", getKafkaBootstrapServers());
        props.put("app.cdlz-kafka.schema-registry-url", getSchemaRegistryUrl());
        props.put("app.cdlz-kafka.group-id", "cdlz-sns-" + TOPIC_SUFFIX);

        props.put("app.topic.adaptor-input", "fdp-sns-input");
        props.put("app.topic.cdlz-incoming", "landing-1");
        props.put("app.pipeline.kafka-topic-suffix", TOPIC_SUFFIX);

        props.put("app.lookup.eori.cdlz-incoming", "landing-413");
        props.put("app.lookup.eori.lookup-topic", "fdp-sns-lookup-eori");
        props.put("app.lookup.eori.application-id", "fdp-sns-lookup-eori-" + TOPIC_SUFFIX);
        props.put("app.lookup.eori.cdlz-application-id", "fdp-cdlz-sns-lookup-eori-" + TOPIC_SUFFIX);

        // application-int.yml resolves placeholders eagerly; provide env-style keys used there.
        props.put("FDP_APP_REDIS_END_POINT", getRedisHost());
        props.put("FDP_APP_REDIS_PORT", String.valueOf(getRedisPort()));
        props.put("FDP_KAFKA_BROKER", getKafkaBootstrapServers());
        props.put("FDP_KAFKA_SCHEMA_REGISTRY_URL", getSchemaRegistryUrl());
        props.put("FDP_KAFKA_STREAM_THREADS", "1");
        props.put("FDP_APP_CDL_KAFKA_BROKER", getKafkaBootstrapServers());
        props.put("FDP_APP_CDL_KAFKA_SCHEMA_REGISTRY_URL", getSchemaRegistryUrl());
        props.put("FDP_CMD_ADAPTOR_INCOMING_TOPIC", "landing-1");
        props.put("FDP_CMD_ADAPTOR_INCOMING_EORI_TOPIC", "landing-413");
        props.put("FDP_APP_KAFKA_TOPIC_SUFFIX", TOPIC_SUFFIX);
        props.put("LOG_LEVEL", "INFO");
        props.put("management.endpoints.web.base-path", "/actuator");

        try {
            applicationContext = new SpringApplicationBuilder(CmdAdaptorApplication.class)
                    .properties(props)
                    // Command line args have higher precedence than application.yml (which hardcodes 7112).
                    .run("--server.port=0");

            String configuredPort = applicationContext.getEnvironment().getProperty("local.server.port");
            if (configuredPort == null) {
                throw new IllegalStateException("Application started without local.server.port");
            }

            applicationPort = Integer.parseInt(configuredPort);
            startAggregatorsIfEnabled();
            applicationStarted = true;

            LOG.info("Started cmd-adaptor-sns test application on port {}", applicationPort);
        } catch (RuntimeException e) {
            dumpContainerLogs("application startup failure: " + e.getMessage());
            if (applicationContext != null) {
                applicationContext.close();
                applicationContext = null;
            }
            applicationStarted = false;
            shutdown();
            throw e;
        }
    }

    public static synchronized void stopAll() {
        if (applicationContext != null) {
            applicationContext.close();
            applicationContext = null;
            applicationStarted = false;
        }

        stopContainer(AGGREGATE_SERVICE);
        stopContainer(AGGREGATE_EVENT);
        stopContainer(AGGREGATE_LOCATION);
        stopContainer(AGGREGATE_OBJECT);
        stopContainer(AGGREGATE_PARTY);

        if (SCHEMA_REGISTRY.isRunning()) {
            SCHEMA_REGISTRY.stop();
        }
        if (KAFKA.isRunning()) {
            KAFKA.stop();
        }
        if (ZOOKEEPER.isRunning()) {
            ZOOKEEPER.stop();
        }
        if (REDIS.isRunning()) {
            REDIS.stop();
        }
        messagingStarted = false;
        redisStarted = false;
        if (applicationContext == null) {
            applicationStarted = false;
        }
    }

    public static synchronized void shutdown() {
        stopAll();
        if (!networkClosed) {
            NETWORK.close();
            networkClosed = true;
        }
    }

    public static synchronized void dumpContainerLogs(String reason) {
        LOG.error("SNS Testcontainers diagnostics requested: {}", reason);
        dumpContainerLog("redis", REDIS);
        dumpContainerLog("zookeeper", ZOOKEEPER);
        dumpContainerLog("kafka", KAFKA);
        dumpContainerLog("schema-registry", SCHEMA_REGISTRY);
        if (AGGREGATORS_ENABLED) {
            dumpContainerLog("aggregate-party", AGGREGATE_PARTY);
            dumpContainerLog("aggregate-object", AGGREGATE_OBJECT);
            dumpContainerLog("aggregate-location", AGGREGATE_LOCATION);
            dumpContainerLog("aggregate-event", AGGREGATE_EVENT);
            dumpContainerLog("aggregate-service", AGGREGATE_SERVICE);
        }
    }

    private static void dumpContainerLog(String name, GenericContainer<?> container) {
        try {
            if (container.getContainerId() == null) {
                LOG.error("--- {} container was not created; no logs available ---", name);
                return;
            }

            String logs = container.getLogs();
            LOG.error("--- {} container logs begin ---\n{}\n--- {} container logs end ---", name, logs, name);
        } catch (RuntimeException e) {
            LOG.error("Unable to collect {} container logs", name, e);
        }
    }

    public static GenericContainer<?> redisContainer() {
        startRedis();
        return REDIS;
    }

    public static String getRedisHost() {
        return redisContainer().getHost();
    }

    public static int getRedisPort() {
        return redisContainer().getMappedPort(6379);
    }

    public static String getKafkaBootstrapServers() {
        startInfrastructure();
        return kafkaBootstrapServers();
    }

    public static String getSchemaRegistryUrl() {
        startInfrastructure();
        return schemaRegistryUrl();
    }

    public static String getTopicSuffix() {
        return TOPIC_SUFFIX;
    }

    public static String getRunId() {
        return RUN_ID;
    }

    static Network sharedNetwork() {
        return NETWORK;
    }

    static String kafkaInternalBootstrapServers() {
        return KAFKA_ALIAS + ":29092";
    }

    static String schemaRegistryInternalUrl() {
        return "http://" + SCHEMA_REGISTRY_ALIAS + ":8081";
    }

    static String redisInternalHost() {
        return REDIS_ALIAS;
    }

    public static String getApplicationHost() {
        startApplication();
        if (applicationContext != null) {
            String configuredHost = applicationContext.getEnvironment().getProperty("local.server.address");
            if (configuredHost != null && !configuredHost.isBlank()) {
                return configuredHost;
            }
        }
        return InetAddress.getLoopbackAddress().getHostAddress();
    }

    public static int getApplicationPort() {
        startApplication();
        return applicationPort;
    }

    private static void startAggregatorsIfEnabled() {
        if (!AGGREGATORS_ENABLED) {
            return;
        }

        LOG.info("Starting SNS downstream aggregate containers for snapshot scenarios in parallel");
        Startables.deepStart(Stream.of(
                AGGREGATE_PARTY,
                AGGREGATE_OBJECT,
                AGGREGATE_LOCATION,
                AGGREGATE_EVENT,
                AGGREGATE_SERVICE)).join();

        Stream.of(
                Map.entry(AGGREGATE_PARTY, "party"),
                Map.entry(AGGREGATE_OBJECT, "object"),
                Map.entry(AGGREGATE_LOCATION, "location"),
                Map.entry(AGGREGATE_EVENT, "event"),
                Map.entry(AGGREGATE_SERVICE, "service"))
                .parallel()
                .forEach(entry -> waitForAggregateReadiness(entry.getKey(), entry.getValue()));
    }

    private static void waitForAggregateReadiness(GenericContainer<?> container, String aggregateType) {
        String host = container.getHost();
        int port = container.getFirstMappedPort();
        String profilePath = "/aggregate-" + aggregateType + "-" + TOPIC_SUFFIX + "/health/readiness";
        String actuatorPath = "/actuator/health/readiness";

        LOG.info("Waiting for aggregate readiness: type={}, host={}, port={}", aggregateType, host, port);

        HttpClient client = HttpClient.newHttpClient();
        int maxAttempts = 120;
        for (int attempt = 1; attempt <= maxAttempts; attempt++) {
            boolean up = isReadinessUp(client, host, port, profilePath) || isReadinessUp(client, host, port, actuatorPath);
            if (up) {
                LOG.info("Aggregate readiness confirmed for {} on attempt {}", aggregateType, attempt);
                return;
            }

            try {
                Thread.sleep(1000L);
            } catch (InterruptedException e) {
                Thread.currentThread().interrupt();
                throw new IllegalStateException("Interrupted while waiting for aggregate readiness: " + aggregateType, e);
            }
        }

        throw new IllegalStateException("Timed out waiting for aggregate readiness: " + aggregateType);
    }

    private static boolean isReadinessUp(HttpClient client, String host, int port, String path) {
        try {
            HttpRequest request = HttpRequest.newBuilder()
                    .uri(URI.create("http://" + host + ":" + port + path))
                    .header("Accept", "application/json")
                    .timeout(Duration.ofSeconds(2))
                    .GET()
                    .build();

            HttpResponse<String> response = client.send(request, HttpResponse.BodyHandlers.ofString());
            return response.statusCode() == 200
                    && response.body() != null
                    && response.body().contains("\"status\":\"UP\"");
        } catch (Exception e) {
            return false;
        }
    }

    private static void stopContainer(GenericContainer<?> container) {
        if (container.isRunning()) {
            container.stop();
        }
    }

    private static void assertEnvironmentOpen() {
        if (networkClosed) {
            throw new IllegalStateException("SNS Testcontainers environment has already been shut down");
        }
    }

    private static void createRequiredTopics() {
        Set<String> topicNames = new LinkedHashSet<>(requiredTopicNames());

        List<NewTopic> topics = new ArrayList<>();
        for (String topicName : topicNames) {
            topics.add(new NewTopic(topicName, 1, (short) 1));
        }

        Map<String, Object> config = new HashMap<>();
        config.put("bootstrap.servers", kafkaBootstrapServers());

        try (AdminClient adminClient = AdminClient.create(config)) {
            adminClient.createTopics(topics).all().get(60, TimeUnit.SECONDS);
        } catch (Exception e) {
            throw new IllegalStateException("Failed to create SNS test topics", e);
        }
    }

    private static List<String> requiredTopicNames() {
        List<String> templates = List.of(
                "fdp_cmd_suspense_{suffix}",
                "fdp_error_{suffix}",
                "fdp_matching_error_{suffix}",
                "fdp_targeted_delete_input_{suffix}",
                "fdp_party_cmd_{suffix}",
                "fdp_party_event_{suffix}",
                "fdp_party_snapshot_{suffix}",
                "fdp_party_error_{suffix}",
                "fdp_party_suspense_data_quality_{suffix}",
                "fdp_party_suspense_no_change_{suffix}",
                "fdp_party_suspense_late_arriving_{suffix}",
                "fdp-aggregate-party-{suffix}-fdp_pole_snapshot_state_store_party-changelog",
                "fdp-aggregate-party-{suffix}-fdp_v1_v2_state_store_party-changelog",
                "fdp_object_cmd_{suffix}",
                "fdp_object_event_{suffix}",
                "fdp_object_snapshot_{suffix}",
                "fdp_object_error_{suffix}",
                "fdp_object_suspense_data_quality_{suffix}",
                "fdp_object_suspense_no_change_{suffix}",
                "fdp_object_suspense_late_arriving_{suffix}",
                "fdp-aggregate-object-{suffix}-fdp_pole_snapshot_state_store_object-changelog",
                "fdp-aggregate-object-{suffix}-fdp_v1_v2_state_store_object-changelog",
                "fdp_location_cmd_{suffix}",
                "fdp_location_event_{suffix}",
                "fdp_location_snapshot_{suffix}",
                "fdp_location_error_{suffix}",
                "fdp_location_suspense_data_quality_{suffix}",
                "fdp_location_suspense_no_change_{suffix}",
                "fdp_location_suspense_late_arriving_{suffix}",
                "fdp-aggregate-location-{suffix}-fdp_pole_snapshot_state_store_location-changelog",
                "fdp-aggregate-location-{suffix}-fdp_v1_v2_state_store_location-changelog",
                "fdp_event_cmd_{suffix}",
                "fdp_event_event_{suffix}",
                "fdp_event_snapshot_{suffix}",
                "fdp_event_error_{suffix}",
                "fdp_event_suspense_data_quality_{suffix}",
                "fdp_event_suspense_no_change_{suffix}",
                "fdp_event_suspense_late_arriving_{suffix}",
                "fdp-aggregate-event-{suffix}-fdp_pole_snapshot_state_store_event-changelog",
                "fdp-aggregate-event-{suffix}-fdp_v1_v2_state_store_event-changelog",
                "fdp_service_cmd_{suffix}",
                "fdp_service_event_{suffix}",
                "fdp_service_snapshot_{suffix}",
                "fdp_service_error_{suffix}",
                "fdp_service_suspense_data_quality_{suffix}",
                "fdp_service_suspense_no_change_{suffix}",
                "fdp_service_suspense_late_arriving_{suffix}",
                "fdp-aggregate-service-{suffix}-fdp_pole_snapshot_state_store_service-changelog",
                "fdp-aggregate-service-{suffix}-fdp_v1_v2_state_store_service-changelog",
                "runlog_fdp_cmda_{suffix}",
                "runlog_fdp_del_{suffix}",
                "fdp_matchingv1v2_cmd_{suffix}",
                "fdp_polev1_address_event_{suffix}",
                "fdp_polev1_contact_event_{suffix}",
                "fdp_polev1_error_{suffix}",
                "fdp_polev1_event_event_{suffix}",
                "fdp_polev1_location_event_{suffix}",
                "fdp_polev1_locationvirtual_event_{suffix}",
                "fdp_polev1_object_event_{suffix}",
                "fdp_polev1_objectdetail_event_{suffix}",
                "fdp_polev1_organisation_event_{suffix}",
                "fdp_polev1_party_event_{suffix}",
                "fdp_polev1_person_event_{suffix}",
                "fdp_polev1_relationship_event_{suffix}",
                "fdp_polev1_service_event_{suffix}",
                "fdp_matching_deleted_{suffix}",
                "fdp_matching_merged_{suffix}",
                "fdp_matching_v1v2_merged_{suffix}",
                "fdp_profiling_from_matching_wash_{suffix}",
                "fdp_profiling_to_matching_wash_{suffix}",
                "to-matching-delta-address-{suffix}",
                "to-matching-delta-address-{suffix}-h",
                "to-matching-delta-consignment-{suffix}",
                "to-matching-delta-consignment-{suffix}-h",
                "to-matching-delta-contact-{suffix}",
                "to-matching-delta-contact-{suffix}-h",
                "to-matching-delta-movement-{suffix}",
                "to-matching-delta-movement-{suffix}-h",
                "to-matching-delta-object-{suffix}",
                "to-matching-delta-object-{suffix}-h",
                "to-matching-delta-organisation-{suffix}",
                "to-matching-delta-organisation-{suffix}-h",
                "to-matching-delta-person-{suffix}",
                "to-matching-delta-person-{suffix}-h",
                "to-matching-delta-virtual-{suffix}",
                "to-matching-delta-virtual-{suffix}-h",
                "to-matching-delta-transport-{suffix}",
                "to-matching-delta-transport-{suffix}-h",
                "to-matching-delta-error-{suffix}",
                "to-matching-delta-error-{suffix}-h",
                "to-matching-wash-address-{suffix}",
                "to-matching-wash-address-{suffix}-h",
                "to-matching-wash-consignment-{suffix}",
                "to-matching-wash-consignment-{suffix}-h",
                "to-matching-wash-contact-{suffix}",
                "to-matching-wash-contact-{suffix}-h",
                "to-matching-wash-movement-{suffix}",
                "to-matching-wash-movement-{suffix}-h",
                "to-matching-wash-object-{suffix}",
                "to-matching-wash-object-{suffix}-h",
                "to-matching-wash-organisation-{suffix}",
                "to-matching-wash-organisation-{suffix}-h",
                "to-matching-wash-person-{suffix}",
                "to-matching-wash-person-{suffix}-h",
                "to-matching-wash-virtual-{suffix}",
                "to-matching-wash-virtual-{suffix}-h",
                "to-matching-wash-transport-{suffix}",
                "to-matching-wash-transport-{suffix}-h",
                "to-matching-wash-error-{suffix}",
                "to-matching-wash-error-{suffix}-h",
                "from-matching-delta-address-{suffix}",
                "from-matching-delta-contact-{suffix}",
                "from-matching-delta-object-{suffix}",
                "from-matching-delta-organisation-{suffix}",
                "from-matching-delta-person-{suffix}",
                "from-matching-delta-virtual-{suffix}",
                "from-matching-delta-transport-{suffix}",
                "from-matching-wash-address-{suffix}",
                "from-matching-wash-contact-{suffix}",
                "from-matching-wash-object-{suffix}",
                "from-matching-wash-organisation-{suffix}",
                "from-matching-wash-person-{suffix}",
                "from-matching-wash-virtual-{suffix}",
                "from-matching-wash-transport-{suffix}",
                "fdp-sns-input_{suffix}",
                "fdp-sns-lookup-eori",
                "fdp-sns-lookup-aeo");

        List<String> requiredTopics = new ArrayList<>(templates.size() + 2);
        for (String template : templates) {
            requiredTopics.add(template.replace("{suffix}", TOPIC_SUFFIX));
        }
        requiredTopics.add("landing-1");
        requiredTopics.add("landing-413");
        return requiredTopics;
    }

    private static void validateSchemaRegistryRoundTrip() {
        try {
            HttpClient client = HttpClient.newHttpClient();
            String subject = "tc-sns-health-" + RUN_ID + "-value";
            String payload = "{\"schema\":\"{\\\"type\\\":\\\"record\\\",\\\"name\\\":\\\"Smoke\\\",\\\"fields\\\":[{\\\"name\\\":\\\"message\\\",\\\"type\\\":\\\"string\\\"}]}\"}";
            String schemaRegistryUrl = schemaRegistryUrl();

            HttpRequest registerRequest = HttpRequest.newBuilder()
                    .uri(URI.create(schemaRegistryUrl + "/subjects/" + subject + "/versions"))
                    .header("Content-Type", "application/vnd.schemaregistry.v1+json")
                    .POST(HttpRequest.BodyPublishers.ofString(payload))
                    .build();
            HttpResponse<String> registerResponse = client.send(registerRequest, HttpResponse.BodyHandlers.ofString());
            if (registerResponse.statusCode() != 200) {
                throw new IllegalStateException("Schema registration failed: " + registerResponse.body());
            }

            HttpRequest readRequest = HttpRequest.newBuilder()
                    .uri(URI.create(schemaRegistryUrl + "/subjects/" + subject + "/versions/latest"))
                    .GET()
                    .build();
            HttpResponse<String> readResponse = client.send(readRequest, HttpResponse.BodyHandlers.ofString());
            if (readResponse.statusCode() != 200 || !readResponse.body().contains("Smoke")) {
                throw new IllegalStateException("Schema Registry round trip validation failed");
            }
        } catch (Exception e) {
            throw new IllegalStateException("Schema Registry validation failed", e);
        }
    }

    private static String kafkaBootstrapServers() {
        return KAFKA.getHost() + ":" + KAFKA.getMappedPort(9092);
    }

    private static String schemaRegistryUrl() {
        return "http://" + SCHEMA_REGISTRY.getHost() + ":" + SCHEMA_REGISTRY.getMappedPort(8081);
    }


    private static GenericContainer<?> aggregateContainer(
            String aggregateType,
            int applicationPort,
            int debugPort,
            int jmxPort,
            String otelServiceName) {
        String jarName = "aggregate-" + aggregateType + ".jar";

        return new GenericContainer<>(DockerImageName.parse(AGGREGATE_IMAGE_BASE + aggregateType + ":" + AGGREGATOR_CORE_VERSION))
                .withNetwork(NETWORK)
                // Aggregate services call each other via fixed DNS names like aggregate-party:9101.
                .withNetworkAliases("aggregate-" + aggregateType, "fdp-aggregate-" + aggregateType)
                .withCreateContainerCmdModifier(cmd -> cmd.withPlatform("linux/amd64"))
                .withExposedPorts(applicationPort)
                .withEnv("SPRING_PROFILES_ACTIVE", "docker")
                .withEnv("LOG_LEVEL", "INFO")
                .withEnv("FDP_KAFKA_SCHEMA_REGISTRY_URL", "http://" + SCHEMA_REGISTRY_ALIAS + ":8081")
                .withEnv("FDP_KAFKA_STREAM_THREADS", "1")
                .withEnv("FDP_KAFKA_BROKER", KAFKA_ALIAS + ":29092")
                .withEnv("FDP_APP_KAFKA_TOPIC_SUFFIX", TOPIC_SUFFIX)
                .withEnv("FDP_APP_REDIS_NODES", REDIS_ALIAS + ":6379")
                .withEnv("FDP_APP_KAFKA_STREAM_MIN_INSYNC_REPLICAS", "1")
                .withEnv("FDP_APP_KAFKA_STREAM_REPLICATION_FACTOR", "1")
                .withEnv("OTEL_SERVICE_NAME", otelServiceName)
                .withEnv("OTEL_TRACES_EXPORTER", "none")
                .withEnv("OTEL_METRICS_EXPORTER", "none")
                .withEnv("OTEL_LOGS_EXPORTER", "none")
                .withEnv("OTEL_INSTRUMENTATION_KAFKA_CLIENTS_ENABLED", "true")
                .withCommand(
                        "java",
                        "-agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=*:" + debugPort,
                        "-Dcom.sun.management.jmxremote",
                        "-Dcom.sun.management.jmxremote.port=" + jmxPort,
                        "-Dcom.sun.management.jmxremote.rmi.port=" + jmxPort,
                        "-Dcom.sun.management.jmxremote.authenticate=false",
                        "-Dcom.sun.management.jmxremote.local.only=false",
                        "-Dcom.sun.management.jmxremote.ssl=false",
                        "-Djava.rmi.server.hostname=localhost",
                        "-jar",
                        "/home/fdpuser/" + jarName)
                .waitingFor(Wait.forListeningPort())
                .withStartupTimeout(Duration.ofSeconds(180));
    }

    private static final class CpKafkaContainer extends GenericContainer<CpKafkaContainer> {
        private CpKafkaContainer(DockerImageName imageName) {
            super(imageName);
            withExposedPorts(9092);
            withEnv("KAFKA_BROKER_ID", "1");
            withEnv("KAFKA_ZOOKEEPER_CONNECT", ZOOKEEPER_ALIAS + ":2181");
            withEnv("KAFKA_LISTENER_SECURITY_PROTOCOL_MAP", "PLAINTEXT:PLAINTEXT,PLAINTEXT_HOST:PLAINTEXT");
            withEnv("KAFKA_INTER_BROKER_LISTENER_NAME", "PLAINTEXT");
            withEnv("KAFKA_LISTENERS", "PLAINTEXT://0.0.0.0:29092,PLAINTEXT_HOST://0.0.0.0:9092");
            withEnv("KAFKA_ADVERTISED_LISTENERS", "PLAINTEXT://" + KAFKA_ALIAS + ":29092,PLAINTEXT_HOST://localhost:9092");
            withEnv("KAFKA_OFFSETS_TOPIC_REPLICATION_FACTOR", "1");
            withEnv("KAFKA_GROUP_INITIAL_REBALANCE_DELAY_MS", "100");
            withEnv("KAFKA_AUTO_CREATE_TOPICS_ENABLE", "false");
            withCommand("sh", "-c", "while [ ! -f /testcontainers_start.sh ]; do sleep 0.1; done; bash /testcontainers_start.sh");
            waitingFor(Wait.forListeningPort());
        }

        @Override
        protected void containerIsStarting(com.github.dockerjava.api.command.InspectContainerResponse containerInfo) {
            String advertisedListeners = "PLAINTEXT://" + KAFKA_ALIAS + ":29092,PLAINTEXT_HOST://"
                    + getHost() + ":" + getMappedPort(9092);

            String command = "#!/bin/bash\n"
                    + "export KAFKA_ADVERTISED_LISTENERS='" + advertisedListeners + "'\n"
                    + "/etc/confluent/docker/run\n";

            copyFileToContainer(Transferable.of(command.getBytes(StandardCharsets.UTF_8), 511),
                    "/testcontainers_start.sh");
        }
    }
}
