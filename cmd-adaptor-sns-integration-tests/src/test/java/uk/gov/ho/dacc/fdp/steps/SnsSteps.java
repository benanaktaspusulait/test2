package uk.gov.ho.dacc.fdp.steps;

import com.fasterxml.jackson.databind.ObjectMapper;
import io.confluent.kafka.schemaregistry.client.rest.exceptions.RestClientException;
import io.confluent.kafka.serializers.KafkaAvroDeserializer;
import io.confluent.kafka.serializers.KafkaAvroDeserializerConfig;
import io.confluent.kafka.streams.serdes.avro.SpecificAvroSerializer;
import io.cucumber.java.Before;
import io.cucumber.java.DataTableType;
import io.cucumber.java.ParameterType;
import io.cucumber.java.en.And;
import io.cucumber.java.en.Given;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import io.cucumber.plugin.EventListener;
import io.cucumber.plugin.event.EventPublisher;
import io.cucumber.plugin.event.Status;
import io.cucumber.plugin.event.TestCaseFinished;
import io.cucumber.plugin.event.TestRunFinished;
import io.cucumber.plugin.event.TestRunStarted;
import lombok.SneakyThrows;
import org.apache.avro.generic.GenericRecord;
import org.apache.avro.specific.SpecificRecordBase;
import org.apache.commons.lang3.RandomStringUtils;
import org.apache.commons.lang3.StringUtils;
import org.apache.kafka.clients.consumer.ConsumerConfig;
import org.apache.kafka.clients.consumer.ConsumerRecord;
import org.apache.kafka.clients.consumer.ConsumerRecords;
import org.apache.kafka.clients.consumer.KafkaConsumer;
import org.apache.kafka.clients.producer.KafkaProducer;
import org.apache.kafka.clients.producer.ProducerConfig;
import org.apache.kafka.clients.producer.ProducerRecord;
import org.apache.kafka.common.TopicPartition;
import org.apache.kafka.common.header.internals.RecordHeader;
import org.apache.kafka.common.serialization.StringSerializer;
import uk.gov.ho.dacc.fdp.cmd.event.CmdEventPoleRecord;
import uk.gov.ho.dacc.fdp.cmd.location.CmdLocationPoleRecord;
import uk.gov.ho.dacc.fdp.cmd.object.CmdObjectPoleRecord;
import uk.gov.ho.dacc.fdp.cmd.party.CmdPartyPoleRecord;
import uk.gov.ho.dacc.fdp.cmd.service.CmdServicePoleRecord;
import uk.gov.ho.dacc.fdp.factory.AvroObjectBuilder;
import uk.gov.ho.dacc.fdp.log.EventPOLEContextRecord;
import uk.gov.ho.dacc.fdp.testcontainers.SnsTestcontainersEnvironment;
import uk.gov.ho.dacc.fdp.util.EventPOLEContextRecordDecoder;
import uk.gov.ho.dacc.fdp.util.HashGenerator;
import uk.gov.ho.dacc.pole.event.EventRecord;
import uk.gov.ho.dacc.pole.identity.IdentityRecord;
import uk.gov.ho.dacc.pole.identity.PoleV2IdRecord;
import uk.gov.ho.dacc.pole.location.LocationRecord;
import uk.gov.ho.dacc.pole.location.LocationStateRecord;
import uk.gov.ho.dacc.pole.object.ObjectRecord;
import uk.gov.ho.dacc.pole.object.ObjectStateRecord;
import uk.gov.ho.dacc.pole.party.PartyRecord;
import uk.gov.ho.dacc.pole.party.PartyStateRecord;
import uk.gov.ho.dacc.pole.service.ServiceRecord;
import uk.gov.ho.dacc.pole.service.ServiceStateRecord;
import uk.gov.ho.dacc.rl.entry.EntryRecord;
import uk.gov.ho.dsa.cdl.hmrc.eori.CdlzLandingRecord;
import uk.gov.ho.dsa.cdl.hmrc.snsens.StreamIngestRecord;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.time.Duration;
import java.util.*;
import java.util.concurrent.atomic.AtomicBoolean;
import java.util.concurrent.atomic.AtomicInteger;

import static org.junit.Assert.*;
import static uk.gov.ho.dacc.fdp.assertions.EventAssertions.assertEventRecord;
import static uk.gov.ho.dacc.fdp.assertions.LocationAssertions.assertLocationRecord;
import static uk.gov.ho.dacc.fdp.assertions.ObjectAssertions.assertObjectRecord;
import static uk.gov.ho.dacc.fdp.assertions.PartyAssertions.assertPartyRecord;
import static uk.gov.ho.dacc.fdp.assertions.ServiceAssertions.assertServiceRecord;
import static uk.gov.ho.dacc.fdp.util.TestUtils.matchExpectedPoleV2Id;

@SuppressWarnings("unchecked")
public class SnsSteps implements EventListener {
    public static final String PARTY = "Party";
    public static final String OBJECT = "Object";
    public static final String LOCATION = "Location";
    public static final String EVENT = "Event";
    public static final String SERVICE = "Service";
    public static final String RUNLOG = "RunLog";
    private static final String PARTY_RECORD = "partyRecord";
    private static final String OBJECT_RECORD = "objectRecord";
    private static final String LOCATION_RECORD = "locationRecord";
    private static final String EVENT_RECORD = "eventRecord";
    private static final String SERVICE_RECORD = "serviceRecord";
    static final String BOOTSTRAP_SERVER_HOST_PROPERTY = "kafka.bootstrap.server.host";
    static final String BOOTSTRAP_SERVER_PORT_PROPERTY = "kafka.bootstrap.server.port";
    static final String REGISTRY_SERVER_HOST_PROPERTY = "kafka.schemaregistry.server.host";
    static final String REGISTRY_SERVER_PORT_PROPERTY = "kafka.schemaregistry.server.port";
    static final String FDP_APP_KAFKA_TOPIC_SUFFIX = "fdp.app.kafka.topic.suffix";
    static final int MAX_RETRIES_GET_CONSUMER_RECORDS = 500;
    static final int INITIAL_POLL_DURATION_MS = 1000;
    static final int POLL_DURATION_MS = 500;
    private static final Duration INITIAL_POLL_DURATION = Duration.ofMillis(INITIAL_POLL_DURATION_MS);
    private static final Duration POLL_DURATION = Duration.ofMillis(POLL_DURATION_MS);
    private static final Duration REQUEST_TIMEOUT = Duration.ofSeconds(2);
    private static final Duration KAFKA_CLIENT_CLOSE_TIMEOUT = Duration.ofSeconds(5);
    private static final HttpClient HTTP_CLIENT = HttpClient.newHttpClient();
    private static final org.slf4j.Logger log = org.slf4j.LoggerFactory.getLogger(SnsSteps.class);
    private static final String CMD_TOPIC_TEST = "CT";
    private static final String SNAPSHOT_TOPIC_TEST = "ST";
    private static final boolean TESTCONTAINERS_ENABLED =
            Boolean.parseBoolean(System.getProperty("sns.testcontainers.enabled", "false"));
    private static final AtomicBoolean RUNTIME_INITIALIZED = new AtomicBoolean(false);
    private static final AtomicInteger COMPLETED_SCENARIOS = new AtomicInteger();
    private static final int EXPECTED_SCENARIOS =
            Integer.parseInt(System.getProperty("sns.testcontainers.expected-scenarios", "0"));
    private static final String PARTY_CMD_TOPIC_PREFIX = "fdp_party_cmd_";
    private static final String PARTY_SNAPSHOT_TOPIC_PREFIX = "fdp_party_snapshot_";
    private static final String OBJECT_CMD_TOPIC_PREFIX = "fdp_object_cmd_";
    private static final String OBJECT_SNAPSHOT_TOPIC_PREFIX = "fdp_object_snapshot_";
    private static final String LOCATION_CMD_TOPIC_PREFIX = "fdp_location_cmd_";
    private static final String LOCATION_SNAPSHOT_TOPIC_PREFIX = "fdp_location_snapshot_";
    private static final String EVENT_CMD_TOPIC_PREFIX = "fdp_event_cmd_";
    private static final String EVENT_SNAPSHOT_TOPIC_PREFIX = "fdp_event_snapshot_";
    private static final String SERVICE_CMD_TOPIC_PREFIX = "fdp_service_cmd_";
    private static final String SERVICE_SNAPSHOT_TOPIC_PREFIX = "fdp_service_snapshot_";
    private static final String RUNLOG_CMD_TOPIC_PREFIX = "runlog_fdp_cmda_";
    private static Properties properties = new Properties();
    private static String partyCmdTopic = PARTY_CMD_TOPIC_PREFIX;
    private static String partySnapshotTopic = PARTY_SNAPSHOT_TOPIC_PREFIX;
    private static String objectCmdTopic = OBJECT_CMD_TOPIC_PREFIX;
    private static String objectSnapshotTopic = OBJECT_SNAPSHOT_TOPIC_PREFIX;
    private static String locationCmdTopic = LOCATION_CMD_TOPIC_PREFIX;
    private static String locationSnapshotTopic = LOCATION_SNAPSHOT_TOPIC_PREFIX;
    private static String eventCmdTopic = EVENT_CMD_TOPIC_PREFIX;
    private static String eventSnapshotTopic = EVENT_SNAPSHOT_TOPIC_PREFIX;
    private static String serviceCmdTopic = SERVICE_CMD_TOPIC_PREFIX;
    private static String serviceSnapshotTopic = SERVICE_SNAPSHOT_TOPIC_PREFIX;
    private static String runlogCmdTopic = RUNLOG_CMD_TOPIC_PREFIX;
    // Avro payloads used in steps
    private static StreamIngestRecord streamIngestRecord;
    private static CdlzLandingRecord eoriCdlzLandingRecord;
    private static String testId;
    private static final String MAPPING_VERSION = Optional.ofNullable(System.getProperty("mapping.version"))
            .map(value -> value.replaceAll("(?i)-SNAPSHOT", ""))
            .orElse("1.2.19");
    private static KafkaProducer kafkaProducer;
    private static Properties consumerConfig = new Properties();
    private static KafkaConsumer<PoleV2IdRecord, CmdPartyPoleRecord> kafkaConsumerPartyCmd;
    private static KafkaConsumer<PoleV2IdRecord, PartyStateRecord> kafkaConsumerPartySnapshot;
    private static KafkaConsumer<PoleV2IdRecord, CmdObjectPoleRecord> kafkaConsumerObjectCmd;
    private static KafkaConsumer<PoleV2IdRecord, ObjectStateRecord> kafkaConsumerObjectSnapshot;
    private static KafkaConsumer<PoleV2IdRecord, CmdLocationPoleRecord> kafkaConsumerLocationCmd;
    private static KafkaConsumer<PoleV2IdRecord, LocationStateRecord> kafkaConsumerLocationSnapshot;
    private static KafkaConsumer<PoleV2IdRecord, CmdEventPoleRecord> kafkaConsumerEventCmd;
    private static KafkaConsumer<PoleV2IdRecord, EventRecord> kafkaConsumerEventSnapshot;
    private static KafkaConsumer<PoleV2IdRecord, CmdServicePoleRecord> kafkaConsumerServiceCmd;
    private static KafkaConsumer<PoleV2IdRecord, ServiceStateRecord> kafkaConsumerServiceSnapshot;
    private static KafkaConsumer<IdentityRecord, EntryRecord> kafkaConsumerRunlogCmd;
    private static Map<String, ? super Set<? extends SpecificRecordBase>> scenarioCache = new HashMap<>();
    ObjectMapper om = new ObjectMapper();

    static {
        if (!TESTCONTAINERS_ENABLED) {
            InputStream stream = Thread
                    .currentThread()
                    .getContextClassLoader()
                    .getResourceAsStream("configuration.properties");
            try {
                properties.load(stream);
            } catch (IOException e) {
                throw new RuntimeException("Could not load test properties - failing");
            }

            configureTopicNames(String.valueOf(properties.get(FDP_APP_KAFKA_TOPIC_SUFFIX)));
            logLoadedProperties();
        } else {
            log.info("Testcontainers runtime bootstrap is deferred to TestRunStarted");
        }
    }

    private static void ensureRuntimeInitialized() {
        if (RUNTIME_INITIALIZED.get()) {
            return;
        }

        synchronized (SnsSteps.class) {
            if (RUNTIME_INITIALIZED.get()) {
                return;
            }

            if (TESTCONTAINERS_ENABLED) {
                SnsTestcontainersEnvironment.startApplication();

                String bootstrap = SnsTestcontainersEnvironment.getKafkaBootstrapServers().replace("PLAINTEXT://", "");
                properties.put(BOOTSTRAP_SERVER_HOST_PROPERTY, bootstrap.substring(0, bootstrap.lastIndexOf(':')));
                properties.put(BOOTSTRAP_SERVER_PORT_PROPERTY, bootstrap.substring(bootstrap.lastIndexOf(':') + 1));

                String registryUrl = SnsTestcontainersEnvironment.getSchemaRegistryUrl().replace("http://", "");
                properties.put(REGISTRY_SERVER_HOST_PROPERTY, registryUrl.substring(0, registryUrl.lastIndexOf(':')));
                properties.put(REGISTRY_SERVER_PORT_PROPERTY, registryUrl.substring(registryUrl.lastIndexOf(':') + 1));
                properties.put(FDP_APP_KAFKA_TOPIC_SUFFIX, SnsTestcontainersEnvironment.getTopicSuffix());

                System.setProperty("sut.host", SnsTestcontainersEnvironment.getApplicationHost());
                System.setProperty("sut.port", String.valueOf(SnsTestcontainersEnvironment.getApplicationPort()));
            }

            configureTopicNames(String.valueOf(properties.get(FDP_APP_KAFKA_TOPIC_SUFFIX)));
            logLoadedProperties();
            RUNTIME_INITIALIZED.set(true);
        }
    }

    private static void configureTopicNames(String suffix) {
        partyCmdTopic = PARTY_CMD_TOPIC_PREFIX + suffix;
        partySnapshotTopic = PARTY_SNAPSHOT_TOPIC_PREFIX + suffix;
        objectCmdTopic = OBJECT_CMD_TOPIC_PREFIX + suffix;
        objectSnapshotTopic = OBJECT_SNAPSHOT_TOPIC_PREFIX + suffix;
        locationCmdTopic = LOCATION_CMD_TOPIC_PREFIX + suffix;
        locationSnapshotTopic = LOCATION_SNAPSHOT_TOPIC_PREFIX + suffix;
        eventCmdTopic = EVENT_CMD_TOPIC_PREFIX + suffix;
        eventSnapshotTopic = EVENT_SNAPSHOT_TOPIC_PREFIX + suffix;
        serviceCmdTopic = SERVICE_CMD_TOPIC_PREFIX + suffix;
        serviceSnapshotTopic = SERVICE_SNAPSHOT_TOPIC_PREFIX + suffix;
        runlogCmdTopic = RUNLOG_CMD_TOPIC_PREFIX + suffix;
    }

    private static void logLoadedProperties() {
        log.info("Loaded properties:");
        properties.keySet().forEach(a -> log.info("  - Key: {}            Value {}", a, properties.get(a)));
    }

    @SneakyThrows
    public static KafkaConsumer<?, ?> awakeConsumer(String topic) {
        KafkaConsumer<?, ?> kafkaConsumer = new KafkaConsumer<>(consumerConfig);
        kafkaConsumer.assign(Collections.singletonList(new TopicPartition(topic, 0)));
        kafkaConsumer.poll(INITIAL_POLL_DURATION);
        log.info("=====> Assigned to topic {}", topic);
        return kafkaConsumer;
    }

    protected static StreamIngestRecord buildStreamIngestRecord(final Map<String, String> sourceDataTableMap) {
        AvroObjectBuilder avroObjectBuilder = new AvroObjectBuilder();
        StreamIngestRecord.Builder landingRecordBuilder = StreamIngestRecord.newBuilder();
        avroObjectBuilder.buildItem(landingRecordBuilder, sourceDataTableMap);
        StreamIngestRecord landingRecord = landingRecordBuilder.build();
        log.info("SNS StreamIngestRecord: {}", landingRecord);
        return landingRecord;
    }

    protected static CdlzLandingRecord buildEoriCdlzLandingRecord(final Map<String, String> sourceDataTableMap) {
        AvroObjectBuilder avroObjectBuilder = new AvroObjectBuilder();
        CdlzLandingRecord.Builder landingRecordBuilder = CdlzLandingRecord.newBuilder();
        avroObjectBuilder.buildItem(landingRecordBuilder, sourceDataTableMap);
        CdlzLandingRecord landingRecord = landingRecordBuilder.build();
        log.info("EORI CdlzLandingRecord: {}", landingRecord);
        return landingRecord;
    }

    @Override
    public void setEventPublisher(EventPublisher eventPublisher) {
        eventPublisher.registerHandlerFor(TestCaseFinished.class,
                event -> COMPLETED_SCENARIOS.incrementAndGet());
        eventPublisher.registerHandlerFor(TestRunStarted.class, event -> {
            ensureRuntimeInitialized();
            final String bootstrapServer =
                    properties.get(BOOTSTRAP_SERVER_HOST_PROPERTY) + ":" + properties.get(BOOTSTRAP_SERVER_PORT_PROPERTY);
            final String registryServer = getSchemaRegistryUrl();
            log.info("Initializing the Test Suite");
            Properties producerConfig = new Properties();
            producerConfig.put(ProducerConfig.CLIENT_ID_CONFIG, "test_client_" + testId);
            producerConfig.put(ProducerConfig.BOOTSTRAP_SERVERS_CONFIG, bootstrapServer);
            producerConfig.put("schema.registry.url", registryServer);
            producerConfig.put(ProducerConfig.KEY_SERIALIZER_CLASS_CONFIG, StringSerializer.class);
            producerConfig.put(ProducerConfig.VALUE_SERIALIZER_CLASS_CONFIG, SpecificAvroSerializer.class);
            kafkaProducer = new KafkaProducer<>(producerConfig);

            consumerConfig.put(ConsumerConfig.BOOTSTRAP_SERVERS_CONFIG, bootstrapServer);
            if (TESTCONTAINERS_ENABLED) {
                consumerConfig.put(ConsumerConfig.GROUP_ID_CONFIG, "e2e-testing-" + SnsTestcontainersEnvironment.getRunId());
            } else {
                consumerConfig.put(ConsumerConfig.GROUP_ID_CONFIG, "e2e-testing");
            }
            consumerConfig.put(ConsumerConfig.KEY_DESERIALIZER_CLASS_CONFIG, KafkaAvroDeserializer.class);
            consumerConfig.put(ConsumerConfig.VALUE_DESERIALIZER_CLASS_CONFIG, KafkaAvroDeserializer.class);
            consumerConfig.put(KafkaAvroDeserializerConfig.SPECIFIC_AVRO_READER_CONFIG, "true");
            consumerConfig.put("schema.registry.url", registryServer);
            consumerConfig.put("max.poll.records", 10);

            kafkaConsumerPartyCmd = (KafkaConsumer<PoleV2IdRecord, CmdPartyPoleRecord>) awakeConsumer(partyCmdTopic);
            kafkaConsumerObjectCmd =
                    (KafkaConsumer<PoleV2IdRecord, CmdObjectPoleRecord>) awakeConsumer(objectCmdTopic);
            kafkaConsumerLocationCmd =
                    (KafkaConsumer<PoleV2IdRecord, CmdLocationPoleRecord>) awakeConsumer(locationCmdTopic);
            kafkaConsumerEventCmd =
                    (KafkaConsumer<PoleV2IdRecord, CmdEventPoleRecord>) awakeConsumer(eventCmdTopic);
            kafkaConsumerServiceCmd =
                    (KafkaConsumer<PoleV2IdRecord, CmdServicePoleRecord>) awakeConsumer(serviceCmdTopic);
            kafkaConsumerPartySnapshot =
                    (KafkaConsumer<PoleV2IdRecord, PartyStateRecord>) awakeConsumer(partySnapshotTopic);
            kafkaConsumerObjectSnapshot =
                    (KafkaConsumer<PoleV2IdRecord, ObjectStateRecord>) awakeConsumer(objectSnapshotTopic);
            kafkaConsumerLocationSnapshot =
                    (KafkaConsumer<PoleV2IdRecord, LocationStateRecord>) awakeConsumer(locationSnapshotTopic);
            kafkaConsumerEventSnapshot =
                    (KafkaConsumer<PoleV2IdRecord, EventRecord>) awakeConsumer(eventSnapshotTopic);
            kafkaConsumerServiceSnapshot =
                    (KafkaConsumer<PoleV2IdRecord, ServiceStateRecord>) awakeConsumer(serviceSnapshotTopic);

            kafkaConsumerRunlogCmd =
                    (KafkaConsumer<IdentityRecord, EntryRecord>) awakeConsumer(runlogCmdTopic);
        });
        eventPublisher.registerHandlerFor(TestRunFinished.class, event -> {
            if (TESTCONTAINERS_ENABLED && event.getResult().getStatus() == Status.FAILED) {
                SnsTestcontainersEnvironment.dumpContainerLogs("Cucumber test run failed");
            }
            if (kafkaProducer != null) {
                kafkaProducer.close(KAFKA_CLIENT_CLOSE_TIMEOUT);
            }
            closeQuietly(kafkaConsumerPartyCmd);
            closeQuietly(kafkaConsumerObjectCmd);
            closeQuietly(kafkaConsumerLocationCmd);
            closeQuietly(kafkaConsumerEventCmd);
            closeQuietly(kafkaConsumerServiceCmd);
            closeQuietly(kafkaConsumerPartySnapshot);
            closeQuietly(kafkaConsumerObjectSnapshot);
            closeQuietly(kafkaConsumerLocationSnapshot);
            closeQuietly(kafkaConsumerEventSnapshot);
            closeQuietly(kafkaConsumerServiceSnapshot);
            closeQuietly(kafkaConsumerRunlogCmd);

            if (TESTCONTAINERS_ENABLED) {
                SnsTestcontainersEnvironment.shutdown();
            }
            if (TESTCONTAINERS_ENABLED && COMPLETED_SCENARIOS.get() < EXPECTED_SCENARIOS) {
                throw new IllegalStateException("Testcontainers suite executed " + COMPLETED_SCENARIOS.get()
                        + " scenarios; expected at least " + EXPECTED_SCENARIOS);
            }
        });
    }

    private static void closeQuietly(KafkaConsumer<?, ?> consumer) {
        if (consumer != null) {
            consumer.close(KAFKA_CLIENT_CLOSE_TIMEOUT);
        }
    }

    @When("Readiness health check is completed")
    public void waitForReadiness() {
        ensureRuntimeInitialized();
        String host = System.getProperty("sut.host", System.getenv().getOrDefault("SUT_HOST", "localhost"));
        String port = System.getProperty("sut.port", System.getenv().getOrDefault("SUT_PORT", "7112"));
        String topicSuffix = properties.getProperty("fdp.app.kafka.topic.suffix", "0");
        String readinessUrl = String.format("http://%s:%s/actuator/health/readiness", host, port);
        String profileReadinessUrl = String.format("http://%s:%s/cmd-adaptor-sns-%s/health/readiness", host, port, topicSuffix);
        log.info("Waiting for readiness at {} or {}", readinessUrl, profileReadinessUrl);
        String[] readinessUrls = {readinessUrl, profileReadinessUrl};

        int maxAttempts = 90; // up to ~90s
        int delayMs = 1000;
        String lastFailure = "No successful readiness response";
        for (int i = 1; i <= maxAttempts; i++) {
            try {
                for (String url : readinessUrls) {
                    HttpRequest request = HttpRequest.newBuilder()
                            .uri(URI.create(url))
                            .header("Accept", "application/json")
                            .timeout(REQUEST_TIMEOUT)
                            .GET()
                            .build();
                    HttpResponse<String> response = HTTP_CLIENT.send(request, HttpResponse.BodyHandlers.ofString());
                    if (response.statusCode() == 200 && response.body() != null && response.body().contains("\"status\":\"UP\"")) {
                        log.info("Readiness confirmed at {} on attempt {}", url, i);
                        return;
                    }
                    lastFailure = String.format("%s returned status=%s body=%s", url, response.statusCode(), response.body());
                }
                log.debug("Readiness not yet UP on attempt {}/{}", i, maxAttempts);
            } catch (Exception e) {
                lastFailure = e.toString();
                log.debug("Readiness check attempt {}/{} failed: {}", i, maxAttempts, e.toString());
            }
            try { Thread.sleep(delayMs); } catch (InterruptedException ie) { Thread.currentThread().interrupt(); }
        }
        fail("Readiness health check did not reach UP within " + maxAttempts + " attempts. Last failure: " + lastFailure);
    }

    private String getSchemaRegistryUrl() {
        return "http://" + properties.get(REGISTRY_SERVER_HOST_PROPERTY) + ":" + properties.get(REGISTRY_SERVER_PORT_PROPERTY);
    }

    @Before
    public void beforeScenario() {
        testId = RandomStringUtils.randomAlphabetic(12);
        log.info("Setting up Scenario");
        log.info("=====> Setting TestId = {}", testId);
    }

    @ParameterType("COMMANDS|SNAPSHOTS|COMMAND|SNAPSHOT")
    public String testType(String testType) {
        return testType;
    }

    @ParameterType("Party|Object|Location|Event|Service|RunLog")
    public String commandOutputType(String commandOutputType) {
        return commandOutputType;
    }

    @Given("template {word} source data with the following attributes")
    public void inputCdlzSourceData(final String inputType, final Map<String, String> sourceDataTableMap) {
        log.info("Executing step [Given: the following template of Sns data]");
        final Map<String, String> dynamicMap = new HashMap<>(sourceDataTableMap);
        dynamicMap.replaceAll((key, value) -> value.replaceAll("\\{testId}", testId));
        if ("StreamIngestRecord".equals(inputType)) {
            streamIngestRecord = buildStreamIngestRecord(dynamicMap);
        } else if ("EoriCdlzLandingRecord".equals(inputType)) {
            eoriCdlzLandingRecord = buildEoriCdlzLandingRecord(dynamicMap);
        } else {
            throw new RuntimeException("Input Type not found");
        }
    }

    @Given("template {word} with the base file {string}")
    @SneakyThrows
    public void inputCdlzSourceDataFromFile(final String inputType, final String inputFileStr) {
        var scenarioBase = getAttributesFromFile(inputFileStr);
        inputCdlzSourceData(inputType, scenarioBase);
    }

    private Map<String, String> getAttributesFromFile(String inputFileStr) throws IOException {
        File inputFile = new File("src/test/resources/features/" + inputFileStr).getAbsoluteFile();
        if (!inputFile.exists()) {
            fail("File " + inputFileStr + " does not exist");
        }
        List<String> baseInput = Files.readAllLines(inputFile.toPath());
        var scenarioBase = new HashMap<String, String>();
        for (String line : baseInput) {
            String[] splitLine = line.split("\\|");
            var key = splitLine[1].replaceAll("\"", "").trim();
            var value = splitLine[2].replaceAll("\"", "").trim();
            scenarioBase.put(key, value);
        }
        return scenarioBase;
    }

    @When("StreamIngestRecord source data is presented with attributes as per the template to the input topic with " +
            "prefix {word}")
    public void sourceDataIsPresented(final String inputTopicPrefix) throws Exception {
        final String inputTopicName =
                inputTopicPrefix + "_" + properties.get(FDP_APP_KAFKA_TOPIC_SUFFIX);
        log.info("When: Executing step [Sns templated source data is presented], testId = {}", testId);
        final ProducerRecord<String, GenericRecord> rec = new ProducerRecord<>(inputTopicName, streamIngestRecord);
        rec.headers().add(new RecordHeader("testId", testId.getBytes(StandardCharsets.UTF_8)));
        kafkaProducer.send(rec).get();
    }

    @When("Eori CDLZ data is presented as per the template to the landing topic {word}")
    public void cdlzDataIsPresented(final String landingTopic) throws Exception {
        log.info("When: Executing step [Eori templated CLDZ data is presented], testId = {}", testId);
        final ProducerRecord<String, GenericRecord> rec = new ProducerRecord<>(landingTopic, eoriCdlzLandingRecord);
        rec.headers().add(new RecordHeader("testId", testId.getBytes(StandardCharsets.UTF_8)));
        kafkaProducer.send(rec).get();
    }

    private boolean haveTestIdHeader(ConsumerRecord<?, ?> rec) {
        return rec.headers().lastHeader("testId") != null &&
                Arrays.equals(rec.headers().lastHeader("testId").value(), testId.getBytes(StandardCharsets.UTF_8));
    }

    private Object pollRecords(
            final int number,
            final String testType,
            final String valueName,
            KafkaConsumer consumerCmd,
            KafkaConsumer consumerSnapshot) {
        Set<Object> records = new LinkedHashSet<>();
        int index = 0;
        while (records.size() < number && ++index < MAX_RETRIES_GET_CONSUMER_RECORDS) {
            log.debug("Retrieving records, attempt {}, record count {}", index, records.size());
            if (testType.equals(CMD_TOPIC_TEST)) {
                ConsumerRecords<PoleV2IdRecord, SpecificRecordBase> messages =
                        consumerCmd.poll(POLL_DURATION);
                for (ConsumerRecord<PoleV2IdRecord, SpecificRecordBase> message : messages) {
                    if (haveTestIdHeader(message)) {
                        records.add(message.value().get(valueName));
                        if (records.size() >= number) {
                            break;
                        }
                    }
                }
            } else {
                ConsumerRecords<PoleV2IdRecord, SpecificRecordBase> messages =
                        consumerSnapshot.poll(POLL_DURATION);
                for (ConsumerRecord<PoleV2IdRecord, SpecificRecordBase> message : messages) {
                    if (haveTestIdHeader(message)) {
                        if (valueName.equals(EVENT_RECORD)) {
                            records.add(message.value());
                        } else {
                            records.add(message.value().get("snapshot"));
                        }
                        if (records.size() >= number) {
                            break;
                        }
                    }
                }
            }
        }
        log.info("Records count: {}", records.size());
        return records;
    }

    private Set<EntryRecord> pollForRunlogRecords(final int number) {
        Set<EntryRecord> runlogRecords = new LinkedHashSet<>();
        int index = 0;
        while (runlogRecords.size() < number && ++index < MAX_RETRIES_GET_CONSUMER_RECORDS) {
            log.debug("Retrieving runlog records, attempt {}, record count {}", index, runlogRecords.size());
            ConsumerRecords<IdentityRecord, EntryRecord> records =
                    kafkaConsumerRunlogCmd.poll(POLL_DURATION);
            for (ConsumerRecord<IdentityRecord, EntryRecord> rec : records) {
                log.debug("Runlog record id = {}, has testId header = {}",
                        rec.value().getMetadata().getIdentityRecord().getId(),
                        haveTestIdHeader(rec));

                if (haveTestIdHeader(rec)) {
                    runlogRecords.add(rec.value());
                    if (runlogRecords.size() >= number) {
                        break;
                    }
                }
            }
        }
        log.info("Runlog records count: {}", runlogRecords.size());
        return runlogRecords;
    }

    @Then("{int} {commandOutputType} {testType} will be emitted")
    public void checkCountAndStoreCommands(final int numberOfExpectedCommands, final String poleType,
                                           final String type) {
        log.info("Then: Executing step [{} {} {} will be emitted]", numberOfExpectedCommands, poleType, type);

        String pollType;
        if (type.equalsIgnoreCase("Command") || type.equalsIgnoreCase("Commands")) {
            pollType = CMD_TOPIC_TEST;
        } else {
            pollType = SNAPSHOT_TOPIC_TEST;
        }

        Set<? extends SpecificRecordBase> records = switch (poleType) {
            case PARTY ->
                    (Set<PartyRecord>) pollRecords(numberOfExpectedCommands, pollType, PARTY_RECORD, kafkaConsumerPartyCmd, kafkaConsumerPartySnapshot);
            case OBJECT ->
                    (Set<ObjectRecord>) pollRecords(numberOfExpectedCommands, pollType, OBJECT_RECORD, kafkaConsumerObjectCmd, kafkaConsumerObjectSnapshot);
            case LOCATION ->
                    (Set<LocationRecord>) pollRecords(numberOfExpectedCommands, pollType, LOCATION_RECORD, kafkaConsumerLocationCmd, kafkaConsumerLocationSnapshot);
            case EVENT ->
                    (Set<EventRecord>) pollRecords(numberOfExpectedCommands, pollType, EVENT_RECORD, kafkaConsumerEventCmd, kafkaConsumerEventSnapshot);
            case SERVICE ->
                    (Set<ServiceRecord>) pollRecords(numberOfExpectedCommands, pollType, SERVICE_RECORD, kafkaConsumerServiceCmd, kafkaConsumerServiceSnapshot);
            case RUNLOG -> pollForRunlogRecords(numberOfExpectedCommands);
            default -> throw new RuntimeException("Only Party, Object, Location, Event, Service and RunLog allowed");
        };

        log.info("Records count: {}", records.size());
        assertEquals(numberOfExpectedCommands, records.size());
        scenarioCache.put(testId, records);
    }

    @Then("{int} runlog messages will be emitted")
    public void runlogMessagesEmitted(int numberOfExpectedCommands) {

        Set<?> records = pollForRunlogRecords(numberOfExpectedCommands);
        kafkaConsumerRunlogCmd.commitSync();
        log.info("Runlog records count: {}", records.size());
        assertEquals(numberOfExpectedCommands, records.size());
        scenarioCache.put(testId, (Set<SpecificRecordBase>) records);
    }

    @And("runlog contains {int} {commandOutputType}")
    public void runlogContainsParties(int numberOfExpectedCommands, String poleType) throws IOException, RestClientException {
        Set<EntryRecord> records = (Set<EntryRecord>) scenarioCache.get(testId);
        EntryRecord rec = records.iterator().next();
        EventPOLEContextRecord actualContext = EventPOLEContextRecordDecoder.decodeMessage(getSchemaRegistryUrl(),rec.getAvroPayload());
        int numEntities = switch (poleType) {
            case PARTY -> actualContext.getPartyList() != null ?
                    actualContext.getPartyList().getParties().size() : 0;
            case OBJECT -> actualContext.getObjectList() != null ?
                    actualContext.getObjectList().getObjects().size() : 0;
            case LOCATION -> actualContext.getLocationList() != null ?
                    actualContext.getLocationList().getLocations().size() : 0;
            case EVENT -> actualContext.getEventList() != null ? actualContext.getEventList().getEvents().size()
                    : 0;
            case SERVICE -> actualContext.getServiceList() != null ?
                    actualContext.getServiceList().getServices().size() : 0;
            default -> throw new RuntimeException("Only Party, Object, Location, Event, Service allowed");
        };
        assertEquals(numberOfExpectedCommands, numEntities);
    }

    @And("one {commandOutputType} record for {string} with following attributes")
    public void oneRecordWithFollowingAttributes(String poleType, String mappingName,
                                                 final Map<String, String> targetDataTableMap) {
        log.info("And executing step [one {} record for {} with {} following attributes]", poleType, mappingName,
                targetDataTableMap);
        final AtomicBoolean processed = new AtomicBoolean();

        switch (poleType) {
            case PARTY:
                final Set<PartyRecord> partyRecords = (Set<PartyRecord>) scenarioCache.get(testId);
                log.debug("partyRecords: {}", partyRecords);
                partyRecords.stream()
                        .filter(rec -> matchExpectedPoleV2Id(targetDataTableMap, rec.getMetadata()))
                        .forEach(partyRecord -> {
                            assertPartyRecord(targetDataTableMap, partyRecord, testId);
                            processed.getAndSet(true);
                        });
                break;
            case OBJECT:
                final Set<ObjectRecord> objectRecords = (Set<ObjectRecord>) scenarioCache.get(testId);
                log.debug("objectRecords: {}", objectRecords);
                objectRecords.stream()
                        .filter(rec -> matchExpectedPoleV2Id(targetDataTableMap, rec.getMetadata()))
                        .forEach(objectRecord -> {
                            assertObjectRecord(targetDataTableMap, objectRecord, testId, true);
                            processed.getAndSet(true);
                        });
                break;
            case LOCATION:
                final Set<LocationRecord> locationRecords = (Set<LocationRecord>) scenarioCache.get(testId);
                log.debug("eventRecords: {}", locationRecords);
                locationRecords.stream()
                        .filter(rec -> matchExpectedPoleV2Id(targetDataTableMap, rec.getMetadata()))
                        .forEach(locationRecord -> {
                            assertLocationRecord(targetDataTableMap, locationRecord, testId, true);
                            processed.getAndSet(true);
                        });
                break;
            case EVENT:
                final Set<EventRecord> eventRecords = (Set<EventRecord>) scenarioCache.get(testId);
                log.debug("eventRecords: {}", eventRecords);
                eventRecords.stream()
                        .filter(rec -> matchExpectedPoleV2Id(targetDataTableMap, rec.getMetadata()))
                        .forEach(eventRecord -> {
                            assertEventRecord(targetDataTableMap, eventRecord, testId, true);
                            processed.getAndSet(true);
                        });
                break;
            case SERVICE:
                final Set<ServiceRecord> serviceRecords = (Set<ServiceRecord>) scenarioCache.get(testId);
                log.debug("serviceRecords: {}", serviceRecords);
                serviceRecords.stream()
                        .filter(rec -> matchExpectedPoleV2Id(targetDataTableMap, rec.getMetadata()))
                        .forEach(serviceRecord -> {
                            assertServiceRecord(targetDataTableMap, serviceRecord, testId);
                            processed.getAndSet(true);
                        });
                break;
            default:
                throw new RuntimeException(String.format("%s not implemented", poleType));
        }
        assertTrue(String.format("Test for %s did not process", mappingName), processed.get());
    }

    @DataTableType(replaceWithEmptyString = "[blank]")
    public String stringType(String cell) {
        if (StringUtils.isNotBlank(cell)) {
            cell = cell.replace("mappingVersion", MAPPING_VERSION);
            try {
                return HashGenerator.createHash(cell, testId, false);
            } catch (Exception e) {
                return cell;
            }
        }
        return cell;
    }
}
