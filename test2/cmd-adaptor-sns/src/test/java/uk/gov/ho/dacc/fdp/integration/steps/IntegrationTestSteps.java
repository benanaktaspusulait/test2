package uk.gov.ho.dacc.fdp.integration.steps;

import io.confluent.kafka.serializers.AbstractKafkaSchemaSerDeConfig;
import io.confluent.kafka.streams.serdes.avro.SpecificAvroSerde;
import io.cucumber.datatable.DataTable;
import io.cucumber.java.After;
import io.cucumber.java.Before;
import io.cucumber.java.DataTableType;
import io.cucumber.java.ParameterType;
import io.cucumber.java.en.And;
import io.cucumber.java.en.Given;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import io.cucumber.plugin.EventListener;
import io.cucumber.plugin.event.EventPublisher;
import io.cucumber.spring.CucumberContextConfiguration;
import lombok.SneakyThrows;
import lombok.extern.slf4j.Slf4j;
import org.apache.avro.specific.SpecificRecordBase;
import org.apache.commons.lang3.RandomStringUtils;
import org.apache.commons.lang3.StringUtils;
import org.apache.kafka.common.serialization.Serdes;
import org.apache.kafka.streams.*;
import org.junit.Assert;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.context.junit4.SpringRunner;
import uk.gov.ho.dacc.fdp.cmd.event.CmdEventPoleRecord;
import uk.gov.ho.dacc.fdp.cmd.location.CmdLocationPoleRecord;
import uk.gov.ho.dacc.fdp.cmd.object.CmdObjectPoleRecord;
import uk.gov.ho.dacc.fdp.cmd.party.CmdPartyPoleRecord;
import uk.gov.ho.dacc.fdp.cmd.service.CmdServicePoleRecord;
import uk.gov.ho.dacc.fdp.config.KafkaSerdeConfigTest;
import uk.gov.ho.dacc.fdp.config.LocalKafkaSerdeConfigTest;
import uk.gov.ho.dacc.fdp.factory.AvroObjectBuilder;
import uk.gov.ho.dacc.fdp.fdp_commons.config.KafkaTopics;
import uk.gov.ho.dacc.fdp.service.CmdAdaptorService;
import uk.gov.ho.dacc.fdp.util.HashGenerator;
import uk.gov.ho.dacc.pole.event.EventRecord;
import uk.gov.ho.dacc.pole.identity.PoleV2IdRecord;
import uk.gov.ho.dacc.pole.location.LocationRecord;
import uk.gov.ho.dacc.pole.metadata.MetadataRecord;
import uk.gov.ho.dacc.pole.object.ObjectRecord;
import uk.gov.ho.dacc.pole.party.PartyRecord;
import uk.gov.ho.dacc.pole.service.ServiceRecord;
import uk.gov.ho.dsa.cdl.hmrc.snsens.StreamIngestRecord;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.util.*;
import java.util.concurrent.atomic.AtomicBoolean;
import java.util.stream.Collectors;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.fail;
import static uk.gov.ho.dacc.fdp.assertions.BaseAssertions.TEST_ID_TOKEN;
import static uk.gov.ho.dacc.fdp.assertions.EventAssertions.assertEventRecord;
import static uk.gov.ho.dacc.fdp.assertions.LocationAssertions.assertLocationRecord;
import static uk.gov.ho.dacc.fdp.assertions.ObjectAssertions.assertObjectRecord;
import static uk.gov.ho.dacc.fdp.assertions.PartyAssertions.assertPartyRecord;
import static uk.gov.ho.dacc.fdp.assertions.RelationshipAssertions.checkPoleV2Id;
import static uk.gov.ho.dacc.fdp.assertions.ServiceAssertions.assertServiceRecord;
import static uk.gov.ho.dacc.fdp.util.TestUtils.matchExpectedPoleV2Id;


@Slf4j
@AutoConfigureMockMvc
@ActiveProfiles("test")
@SpringBootTest
@CucumberContextConfiguration
@RunWith(SpringRunner.class)
public class IntegrationTestSteps implements EventListener {

    static final String MOCK_REGISTRY_URLL = "mock://dummy/schema";

    static Properties properties = new Properties();
    protected static StreamIngestRecord streamIngestRecord;
    protected static String testId;
    protected static String mappingVersion;
    Map<String, String> backgroundDataTemplate;


    @Autowired
    CmdAdaptorService service;

    private TopologyTestDriver testDriver;

    private TestInputTopic<String, StreamIngestRecord> testInputTopic;
    private static TestOutputTopic<PoleV2IdRecord, CmdPartyPoleRecord> partyOutputTopic;
    private static TestOutputTopic<PoleV2IdRecord, CmdObjectPoleRecord> objectOutputTopic;
    private static TestOutputTopic<PoleV2IdRecord, CmdEventPoleRecord> eventOutputTopic;
    private static TestOutputTopic<PoleV2IdRecord, CmdServicePoleRecord> serviceOutputTopic;
    private static TestOutputTopic<PoleV2IdRecord, CmdLocationPoleRecord> locationOutputTopic;

    @Autowired
    LocalKafkaSerdeConfigTest config;

    @Autowired
    KafkaSerdeConfigTest configTest;

    @Autowired
    KafkaTopics kafkaTopics;

    public static final String PARTY = "Party";
    public static final String OBJECT = "Object";
    public static final String LOCATION = "Location";
    public static final String EVENT = "Event";
    public static final String SERVICE = "Service";
    public static final String EMPTY = "Empty";

    static Map<String, ? super Set<? extends SpecificRecordBase>> scenarioCache = new HashMap<>();


    @Before
    public void beforeScenario() {
        backgroundDataTemplate = null;
        CmdAdaptorService.streamsBuilderThreadLocal.set(new StreamsBuilder());
        testId = RandomStringUtils.randomAlphabetic(12);

        config.init();
        Properties props = new Properties();
        props.put(StreamsConfig.APPLICATION_ID_CONFIG, "topologyTest");
        props.put(StreamsConfig.BOOTSTRAP_SERVERS_CONFIG, "localhost:1234");
        props.put(StreamsConfig.DEFAULT_KEY_SERDE_CLASS_CONFIG, Serdes.StringSerde.class);
        props.put(StreamsConfig.DEFAULT_VALUE_SERDE_CLASS_CONFIG, SpecificAvroSerde.class);
        props.put(AbstractKafkaSchemaSerDeConfig.SCHEMA_REGISTRY_URL_CONFIG, MOCK_REGISTRY_URLL);
        Topology topology = service.buildTopology();

        testDriver = new TopologyTestDriver(topology, props);

        partyOutputTopic = testDriver.createOutputTopic(
                kafkaTopics.FDP_PARTY_CMD,
                configTest.getPoleV2IdRecordSerdeKey().deserializer(),
                configTest.getCmdPartyPoleRecordSerde().deserializer()
        );
        objectOutputTopic = testDriver.createOutputTopic(
                kafkaTopics.FDP_OBJECT_CMD,
                configTest.getPoleV2IdRecordSerdeKey().deserializer(),
                configTest.getCmdObjectPoleRecordSerde().deserializer()
        );
        locationOutputTopic = testDriver.createOutputTopic(
                kafkaTopics.FDP_LOCATION_CMD,
                configTest.getPoleV2IdRecordSerdeKey().deserializer(),
                configTest.getCmdLocationPoleRecordSerde().deserializer()
        );
        eventOutputTopic = testDriver.createOutputTopic(
                kafkaTopics.FDP_EVENT_CMD,
                configTest.getPoleV2IdRecordSerdeKey().deserializer(),
                configTest.getCmdEventPoleRecordSerde().deserializer()
        );
        serviceOutputTopic = testDriver.createOutputTopic(
                kafkaTopics.FDP_SERVICE_CMD,
                configTest.getPoleV2IdRecordSerdeKey().deserializer(),
                configTest.getCmdServicePoleRecordSerde().deserializer()
        );

        try (
                InputStream inputStream = getClass().getClassLoader().getResourceAsStream("application.yml")) {
            if (inputStream != null) {
                props.load(inputStream);
                mappingVersion = props.getProperty("mapping").replaceAll("(?i)-SNAPSHOT", "");
            } else {
                System.out.println("application.yml not found!");
                mappingVersion = null;
            }
        } catch (IOException e) {
            mappingVersion = null;
            log.error(e.getMessage());
        }
    }

    @ParameterType("COMMANDS|SNAPSHOTS|COMMAND|SNAPSHOT")
    public String testType(String testType) {
        return testType;
    }

    @ParameterType("Party|Object|Location|Event|Service|RunLog")
    public String commandOutputType(String commandOutputType) {
        return commandOutputType;
    }

    @Given("template StreamIngestRecord with the base file {string}")
    @SneakyThrows
    public void inputCdlzSourceDataFromFile(final String inputFileStr) {
        var scenarioBase = getAttributesFromFile(inputFileStr);
        inputCdlzSourceData(scenarioBase);
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

    @Given("template StreamIngestRecord source data with the following attributes")
    public void inputCdlzSourceData(final Map<String, String> sourceDataTableMap) {
        backgroundDataTemplate = sourceDataTableMap;
        log.info("Executing step [Given: the following template of SNS data]");
        final Map<String, String> dynamicMap = new HashMap<>(sourceDataTableMap);
        streamIngestRecord = buildStreamIngestRecord(dynamicMap);
    }

    protected static StreamIngestRecord buildStreamIngestRecord(final Map<String, String> sourceDataTableMap) {
        AvroObjectBuilder avroObjectBuilder = new AvroObjectBuilder();
        StreamIngestRecord.Builder landingRecordBuilder = StreamIngestRecord.newBuilder();
        avroObjectBuilder.buildItem(landingRecordBuilder, sourceDataTableMap);
        StreamIngestRecord landingRecord = landingRecordBuilder.build();
        log.info(landingRecord.toString());
        return landingRecord;
    }

    @When("the template of Sns data with the base file {string} is changed to")
    @SneakyThrows
    public void sourceDataIsPresentedWithChangedAttributes(final String inputFileStr, DataTable dataTable) {
        Map<String, String> scenarioBase = getAttributesFromFile(inputFileStr);
        log.info("Executing step [When: the following template of Cop data is changed to {}", dataTable);

        final Map<String, String> dynamicMap = new HashMap<>(scenarioBase);
        dynamicMap.replaceAll((key, value) -> value != null ? value.replaceAll(TEST_ID_TOKEN, testId) : value);

        List<Map<String, String>> fields = dataTable.asMaps();
        List<String> keys = new ArrayList<>(fields.get(0).keySet());
        for (Map<String, String> field : fields) {
            var fieldValue = field.get(keys.get(1)).equals("null") ? null : field.get(keys.get(1));
            dynamicMap.replace(field.get(keys.get(0)), fieldValue);
        }
        streamIngestRecord = buildStreamIngestRecord(dynamicMap);
    }

    @When("StreamIngestRecord source data is presented with attributes as per the template to the {word} input topic")
    public void sourceDataIsPresented(final String inputTopicName) {
        log.info("When: Executing step [SNS templated source data is presented], testId = {}, inputTopicName = {}",
                testId, inputTopicName);
        testInputTopic = testDriver.createInputTopic(
                inputTopicName,
                config.getStringSerde().serializer(),
                config.getCdlzRecordSerde().serializer()
        );

        testInputTopic.pipeInput("key", streamIngestRecord);
    }


    @When("the background template of Sns data is changed to")
    @SneakyThrows
    public void overriddenSourceDataIsPresented(DataTable dataTable) {

        final Map<String, String> dynamicMap = new HashMap<>(backgroundDataTemplate);

        List<Map<String, String>> fields = dataTable.asMaps();
        List<String> keys = new ArrayList<>(fields.get(0).keySet());
        for (Map<String, String> field : fields) {
            var fieldValue = field.get(keys.get(1)).equals("null") ? null : field.get(keys.get(1));
            dynamicMap.replace(field.get(keys.get(0)), fieldValue);
        }
        streamIngestRecord = buildStreamIngestRecord(dynamicMap);
    }

    @And("one {commandOutputType} record for {string} with following poleV2Id")
    public void oneObjectRecordForWithFollowingPoleVId(String poleType, String dataType,
                                                       final Map<String, String> targetDataTableMap) {
        checkRecordData(poleType, dataType, targetDataTableMap, true);
    }

    @And("one {commandOutputType} record for {string} with following attributes")
    public void oneRecordWithFollowingAttributes(String poleType, String dataType,
                                                 final Map<String, String> targetDataTableMap) {
        checkRecordData(poleType, dataType, targetDataTableMap, false);
    }

    @SuppressWarnings("unchecked")
    public void checkRecordData(String poleType, String dataType, final Map<String, String> targetDataTableMap, boolean isPoleV2Id) {
        log.info("And executing step [one {} record for {} with {} following attributes]", poleType,
                dataType, targetDataTableMap);
        final AtomicBoolean processed = new AtomicBoolean();

        switch (poleType) {
            case PARTY:
                final Set<PartyRecord> partyRecords = (Set<PartyRecord>) scenarioCache.get(testId);
                partyRecords.stream()
                        .filter(a -> matchExpectedPoleV2Id(targetDataTableMap, a.getMetadata()))
                        .forEach(testPartyRecord -> {
                            log.info("Value: {}", testPartyRecord);
                            if (isPoleV2Id) {
                                checkPoleV2Id(testPartyRecord, targetDataTableMap);
                            } else {
                                assertPartyRecord(targetDataTableMap, testPartyRecord, testId);
                            }
                            processed.getAndSet(true);
                        });
                break;
            case OBJECT:
                final Set<ObjectRecord> objectRecords = (Set<ObjectRecord>) scenarioCache.get(testId);
                objectRecords.stream()
                        .filter(a -> matchExpectedPoleV2Id(targetDataTableMap, a.getMetadata()))
                        .forEach(testObjectRecord -> {
                            log.info("Value: {}", testObjectRecord);
                            if (isPoleV2Id) {
                                checkPoleV2Id(testObjectRecord, targetDataTableMap);
                            } else {
                                assertObjectRecord(targetDataTableMap, testObjectRecord, testId, false);
                            }
                            processed.getAndSet(true);
                        });
                break;
            case LOCATION:
                final Set<LocationRecord> locationRecords = (Set<LocationRecord>) scenarioCache.get(testId);
                locationRecords.stream()
                        .filter(a -> matchExpectedPoleV2Id(targetDataTableMap, a.getMetadata()))
                        .forEach(testLocationRecord -> {
                            log.info("Value: {}", testLocationRecord);
                                    if (isPoleV2Id) {
                                        checkPoleV2Id(testLocationRecord, targetDataTableMap);
                                    } else {
                            assertLocationRecord(targetDataTableMap, testLocationRecord, testId, false);
                                    }
                            processed.getAndSet(true);
                        });
                break;
            case EVENT:
                final Set<EventRecord> eventRecords = (Set<EventRecord>) scenarioCache.get(testId);
                eventRecords.stream()
                        .filter(a -> matchExpectedPoleV2Id(targetDataTableMap, a.getMetadata()))
                        .forEach(testEventRecord -> {
                            log.info("Value: {}", testEventRecord);
                            if (isPoleV2Id) {
                                checkPoleV2Id(testEventRecord, targetDataTableMap);
                            } else {
                                assertEventRecord(targetDataTableMap, testEventRecord, testId, false);
                            }
                            processed.getAndSet(true);
                        });
                break;
            case SERVICE:
                final Set<ServiceRecord> serviceRecords = (Set<ServiceRecord>) scenarioCache.get(testId);
                serviceRecords.stream()
                        .filter(a -> matchExpectedPoleV2Id(targetDataTableMap, a.getMetadata()))
                        .forEach(testServiceRecord -> {
                            log.info("Value: {}", testServiceRecord);
                            if (isPoleV2Id) {
                                checkPoleV2Id(testServiceRecord, targetDataTableMap);
                            } else {
                                assertServiceRecord(targetDataTableMap, testServiceRecord, testId);
                            }
                            processed.getAndSet(true);
                        });
                break;
        }
        // check v2.id if you get an exception here
        Assert.assertTrue(processed.get());
    }

    @Then("{int} {commandOutputType} Commands for {} will be emitted")
    public void checkCountAndStoreCommands(final int numberOfExpectedCommands, final String poleType,
                                           final String mappingName) {
        log.info("Then: Executing step [{} {} for {} will be emitted]", numberOfExpectedCommands, poleType, mappingName);

        Set<? extends SpecificRecordBase> testTopicRecords = switch (poleType) {
            case PARTY -> checkPartyRecordsFromTestTopic();
            case OBJECT -> checkObjectRecordsFromTestTopic();
            case LOCATION -> checkLocationRecordsFromTestTopic();
            case EVENT -> checkEventRecordsFromTestTopic();
            case SERVICE -> checkServiceRecordsFromTestTopic();
            default -> throw new RuntimeException(poleType + " is not a POLES type");
        };

        Set<? extends SpecificRecordBase> records = testTopicRecords.stream()
                .filter(record -> ((MetadataRecord) record.get("metadata")).getMappingRecord().getName().toString().startsWith(mappingName))
                .collect(Collectors.toSet());

        int size = records.size();
        log.info("Records count: {}", size);
        assertEquals(numberOfExpectedCommands, size);
        scenarioCache.put(testId, records);
    }
    @Then("{int} {commandOutputType} Commands will be emitted")
    public void checkCountAndStoreCommands(final int numberOfExpectedCommands, final String poleType) {
        log.info("Then: Executing step [{} {} will be emitted]", numberOfExpectedCommands, poleType);

        Set<? extends SpecificRecordBase> records = switch (poleType) {
            case PARTY -> checkPartyRecordsFromTestTopic();
            case OBJECT -> checkObjectRecordsFromTestTopic();
            case LOCATION -> checkLocationRecordsFromTestTopic();
            case EVENT -> checkEventRecordsFromTestTopic();
            case SERVICE -> checkServiceRecordsFromTestTopic();
            default -> new HashSet<>();
        };

        log.info("Records count: {}", records.size());
        assertEquals(numberOfExpectedCommands, records.size());
        scenarioCache.put(testId, records);
    }

    protected static Set<PartyRecord> checkPartyRecordsFromTestTopic() {
        Set<PartyRecord> partyRecords = new LinkedHashSet<>();

        List<KeyValue<PoleV2IdRecord, CmdPartyPoleRecord>> keyValueList = partyOutputTopic.readKeyValuesToList();
        keyValueList.forEach(a -> partyRecords.add(a.value.getPartyRecord()));
        log.info("Records count: {}", partyRecords.size());
        return partyRecords;
    }

    protected static Set<ObjectRecord> checkObjectRecordsFromTestTopic() {
        Set<ObjectRecord> objectRecords = new LinkedHashSet<>();

        List<KeyValue<PoleV2IdRecord, CmdObjectPoleRecord>> keyValueList = objectOutputTopic.readKeyValuesToList();
        keyValueList.forEach(a -> objectRecords.add(a.value.getObjectRecord()));
        log.info("Records count: {}", objectRecords.size());
        return objectRecords;
    }

    protected static Set<LocationRecord> checkLocationRecordsFromTestTopic() {
        Set<LocationRecord> locationRecords = new LinkedHashSet<>();

        List<KeyValue<PoleV2IdRecord, CmdLocationPoleRecord>> keyValueList = locationOutputTopic.readKeyValuesToList();
        keyValueList.forEach(a -> locationRecords.add(a.value.getLocationRecord()));
        log.info("Records count: {}", locationRecords.size());
        return locationRecords;
    }

    protected static Set<EventRecord> checkEventRecordsFromTestTopic() {
        Set<EventRecord> eventRecords = new LinkedHashSet<>();

        List<KeyValue<PoleV2IdRecord, CmdEventPoleRecord>> keyValueList = eventOutputTopic.readKeyValuesToList();
        keyValueList.forEach(a -> eventRecords.add(a.value.getEventRecord()));
        log.info("Records count: {}", eventRecords.size());
        return eventRecords;
    }

    protected static Set<ServiceRecord> checkServiceRecordsFromTestTopic() {
        Set<ServiceRecord> serviceRecords = new LinkedHashSet<>();

        List<KeyValue<PoleV2IdRecord, CmdServicePoleRecord>> keyValueList = serviceOutputTopic.readKeyValuesToList();
        keyValueList.forEach(a -> serviceRecords.add(a.value.getServiceRecord()));
        log.info("Records count: {}", serviceRecords.size());
        return serviceRecords;
    }

    //@Override
    public void setEventPublisher(EventPublisher publisher) {
        log.info("Initializing the Test Suite");
    }

    @DataTableType(replaceWithEmptyString = "[blank]")
    public String stringType(String cell) {
        if (StringUtils.isNotBlank(cell)) {
            if (mappingVersion != null) {
                cell = cell.replace("mappingVersion", mappingVersion);
            }
            try {
                return HashGenerator.createHash(cell, testId, false);
            } catch (Exception e) {
                return cell;
            }
        }
        return cell;
    }

    @After
    public void afterScenario() {
        testDriver.close();
    }
}
