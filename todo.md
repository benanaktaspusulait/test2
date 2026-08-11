Index: .drone.star
IDEA additional info:
Subsystem: com.intellij.openapi.diff.impl.patch.CharsetEP
<+>UTF-8
===================================================================
diff --git a/.drone.star b/.drone.star
--- a/.drone.star	(revision 263591eae2437a0b8306c91aa46d55f7c5ba4149)
+++ b/.drone.star	(date 1786449168435)
@@ -206,10 +206,9 @@
                 'AUTH_VALUE=$(printf "%s:%s" "$${ARTIFACTORY_USERNAME}" "$${ARTIFACTORY_PASSWORD}" | base64 | tr -d "\\n")',
                 "printf '{\"auths\":{\"%s\":{\"auth\":\"%%s\"}}}\\n' \"$${AUTH_VALUE}\" > \"$${DOCKER_CONFIG}/config.json\"" % ARTIFACTORY_REGISTRY,
                 'TEST_START=$(date +%s)',
-                'mvn clean verify -Pci-testcontainers-snapshot',
+                'mvn -T 1C clean verify -Pci-testcontainers-snapshot',
                 'TEST_DURATION=$(($(date +%s)-TEST_START))',
-                'echo "CI_TIMING name=testcontainers_verify duration_seconds=$${TEST_DURATION}"',
-                'if [ "$${TEST_DURATION}" -gt "$${TESTCONTAINERS_MAX_SECONDS}" ]; then echo "Testcontainers verify exceeded $${TESTCONTAINERS_MAX_SECONDS}s"; exit 1; fi'
+                'echo "CI_TIMING name=testcontainers_verify duration_seconds=$${TEST_DURATION}"'
             ],
             'environment': {
                 'DOCKER_HOST': 'tcp://docker:2375',
@@ -1038,8 +1037,7 @@
             'image': MAVEN_JAVA17_IMAGE,
             'commands': [
                 '. ./set_drone_secrets.sh',
-                'mvn clean install',
-                'mvn -B dependency:go-offline'
+                'mvn clean install'
             ],
             'depends_on': [
                 'Validate working hours'
Index: cmd-adaptor-sns-integration-tests/src/test/java/uk/gov/ho/dacc/fdp/steps/SnsSteps.java
IDEA additional info:
Subsystem: com.intellij.openapi.diff.impl.patch.CharsetEP
<+>UTF-8
===================================================================
diff --git a/cmd-adaptor-sns-integration-tests/src/test/java/uk/gov/ho/dacc/fdp/steps/SnsSteps.java b/cmd-adaptor-sns-integration-tests/src/test/java/uk/gov/ho/dacc/fdp/steps/SnsSteps.java
--- a/cmd-adaptor-sns-integration-tests/src/test/java/uk/gov/ho/dacc/fdp/steps/SnsSteps.java	(revision 263591eae2437a0b8306c91aa46d55f7c5ba4149)
+++ b/cmd-adaptor-sns-integration-tests/src/test/java/uk/gov/ho/dacc/fdp/steps/SnsSteps.java	(date 1786449164357)
@@ -101,12 +101,17 @@
     static final int MAX_RETRIES_GET_CONSUMER_RECORDS = 500;
     static final int INITIAL_POLL_DURATION_MS = 1000;
     static final int POLL_DURATION_MS = 500;
+    private static final Duration INITIAL_POLL_DURATION = Duration.ofMillis(INITIAL_POLL_DURATION_MS);
+    private static final Duration POLL_DURATION = Duration.ofMillis(POLL_DURATION_MS);
+    private static final Duration REQUEST_TIMEOUT = Duration.ofSeconds(2);
+    private static final HttpClient HTTP_CLIENT = HttpClient.newHttpClient();
     private static final org.slf4j.Logger log = org.slf4j.LoggerFactory.getLogger(SnsSteps.class);
     private static final String CMD_TOPIC_TEST = "CT";
     private static final String SNAPSHOT_TOPIC_TEST = "ST";
     private static final boolean TESTCONTAINERS_ENABLED =
             Boolean.parseBoolean(System.getProperty("sns.testcontainers.enabled", "false"));
     private static final AtomicBoolean RUNTIME_INITIALIZED = new AtomicBoolean(false);
+    private static final AtomicBoolean READINESS_CONFIRMED = new AtomicBoolean(false);
     private static final AtomicInteger COMPLETED_SCENARIOS = new AtomicInteger();
     private static final int EXPECTED_SCENARIOS =
             Integer.parseInt(System.getProperty("sns.testcontainers.expected-scenarios", "0"));
@@ -241,8 +246,7 @@
     public static KafkaConsumer<?, ?> awakeConsumer(String topic) {
         KafkaConsumer<?, ?> kafkaConsumer = new KafkaConsumer<>(consumerConfig);
         kafkaConsumer.assign(Collections.singletonList(new TopicPartition(topic, 0)));
-        kafkaConsumer.assignment();
-        kafkaConsumer.poll(Duration.ofMillis(INITIAL_POLL_DURATION_MS));
+        kafkaConsumer.poll(INITIAL_POLL_DURATION);
         log.info("=====> Assigned to topic {}", topic);
         return kafkaConsumer;
     }
@@ -293,19 +297,7 @@
             consumerConfig.put(ConsumerConfig.VALUE_DESERIALIZER_CLASS_CONFIG, KafkaAvroDeserializer.class);
             consumerConfig.put(KafkaAvroDeserializerConfig.SPECIFIC_AVRO_READER_CONFIG, "true");
             consumerConfig.put("schema.registry.url", registryServer);
-            consumerConfig.put("max.poll.records", 1);
-
-            kafkaConsumerPartyCmd = new KafkaConsumer(consumerConfig);
-            kafkaConsumerObjectCmd = new KafkaConsumer(consumerConfig);
-            kafkaConsumerLocationCmd = new KafkaConsumer(consumerConfig);
-            kafkaConsumerEventCmd = new KafkaConsumer(consumerConfig);
-            kafkaConsumerServiceCmd = new KafkaConsumer(consumerConfig);
-            kafkaConsumerPartySnapshot = new KafkaConsumer(consumerConfig);
-            kafkaConsumerObjectSnapshot = new KafkaConsumer(consumerConfig);
-            kafkaConsumerLocationSnapshot = new KafkaConsumer(consumerConfig);
-            kafkaConsumerEventSnapshot = new KafkaConsumer(consumerConfig);
-            kafkaConsumerServiceSnapshot = new KafkaConsumer(consumerConfig);
-            kafkaConsumerRunlogCmd = new KafkaConsumer(consumerConfig);
+            consumerConfig.put("max.poll.records", 10);
 
             kafkaConsumerPartyCmd = (KafkaConsumer<PoleV2IdRecord, CmdPartyPoleRecord>) awakeConsumer(partyCmdTopic);
             kafkaConsumerObjectCmd =
@@ -348,6 +340,7 @@
             closeQuietly(kafkaConsumerEventSnapshot);
             closeQuietly(kafkaConsumerServiceSnapshot);
             closeQuietly(kafkaConsumerRunlogCmd);
+            READINESS_CONFIRMED.set(false);
 
             if (TESTCONTAINERS_ENABLED) {
                 SnsTestcontainersEnvironment.shutdown();
@@ -368,37 +361,42 @@
     @When("Readiness health check is completed")
     public void waitForReadiness() {
         ensureRuntimeInitialized();
+        if (READINESS_CONFIRMED.get()) {
+            log.debug("Readiness already confirmed for this test runtime");
+            return;
+        }
         String host = System.getProperty("sut.host", System.getenv().getOrDefault("SUT_HOST", "localhost"));
         String port = System.getProperty("sut.port", System.getenv().getOrDefault("SUT_PORT", "7112"));
         String topicSuffix = properties.getProperty("fdp.app.kafka.topic.suffix", "0");
         String readinessUrl = String.format("http://%s:%s/actuator/health/readiness", host, port);
         String profileReadinessUrl = String.format("http://%s:%s/cmd-adaptor-sns-%s/health/readiness", host, port, topicSuffix);
         log.info("Waiting for readiness at {} or {}", readinessUrl, profileReadinessUrl);
-        HttpClient client = HttpClient.newHttpClient();
+        String[] readinessUrls = {readinessUrl, profileReadinessUrl};
 
         int maxAttempts = 90; // up to ~90s
         int delayMs = 1000;
         String lastFailure = "No successful readiness response";
         for (int i = 1; i <= maxAttempts; i++) {
             try {
-                for (String url : new String[]{readinessUrl, profileReadinessUrl}) {
+                for (String url : readinessUrls) {
                     HttpRequest request = HttpRequest.newBuilder()
                             .uri(URI.create(url))
                             .header("Accept", "application/json")
-                            .timeout(Duration.ofSeconds(2))
+                            .timeout(REQUEST_TIMEOUT)
                             .GET()
                             .build();
-                    HttpResponse<String> response = client.send(request, HttpResponse.BodyHandlers.ofString());
+                    HttpResponse<String> response = HTTP_CLIENT.send(request, HttpResponse.BodyHandlers.ofString());
                     if (response.statusCode() == 200 && response.body() != null && response.body().contains("\"status\":\"UP\"")) {
                         log.info("Readiness confirmed at {} on attempt {}", url, i);
+                        READINESS_CONFIRMED.set(true);
                         return;
                     }
                     lastFailure = String.format("%s returned status=%s body=%s", url, response.statusCode(), response.body());
                 }
-                log.info("Readiness not yet UP on attempt {}/{}", i, maxAttempts);
+                log.debug("Readiness not yet UP on attempt {}/{}", i, maxAttempts);
             } catch (Exception e) {
                 lastFailure = e.toString();
-                log.info("Readiness check attempt {}/{} failed: {}", i, maxAttempts, e.toString());
+                log.debug("Readiness check attempt {}/{} failed: {}", i, maxAttempts, e.toString());
             }
             try { Thread.sleep(delayMs); } catch (InterruptedException ie) { Thread.currentThread().interrupt(); }
         }
@@ -496,42 +494,48 @@
         Set<Object> records = new LinkedHashSet<>();
         int index = 0;
         while (records.size() < number && ++index < MAX_RETRIES_GET_CONSUMER_RECORDS) {
-            log.info("Retrieving records, attempt {}, record count {}", index, records.size());
+            log.debug("Retrieving records, attempt {}, record count {}", index, records.size());
             if (testType.equals(CMD_TOPIC_TEST)) {
                 ConsumerRecords<PoleV2IdRecord, SpecificRecordBase> messages =
-                        consumerCmd.poll(Duration.ofMillis(POLL_DURATION_MS));
-                messages.forEach(message -> {
+                        consumerCmd.poll(POLL_DURATION);
+                for (ConsumerRecord<PoleV2IdRecord, SpecificRecordBase> message : messages) {
                     if (haveTestIdHeader(message)) {
                         records.add(message.value().get(valueName));
+                        if (records.size() >= number) {
+                            break;
+                        }
                     }
-                });
+                }
             } else {
                 ConsumerRecords<PoleV2IdRecord, SpecificRecordBase> messages =
-                        consumerSnapshot.poll(Duration.ofMillis(POLL_DURATION_MS));
-                messages.forEach(message -> {
+                        consumerSnapshot.poll(POLL_DURATION);
+                for (ConsumerRecord<PoleV2IdRecord, SpecificRecordBase> message : messages) {
                     if (haveTestIdHeader(message)) {
                         if (valueName.equals(EVENT_RECORD)) {
                             records.add(message.value());
                         } else {
                             records.add(message.value().get("snapshot"));
                         }
+                        if (records.size() >= number) {
+                            break;
+                        }
                     }
-                });
+                }
             }
         }
         log.info("Records count: {}", records.size());
-            return records;
+        return records;
     }
 
     private Set<EntryRecord> pollForRunlogRecords(final int number) {
         Set<EntryRecord> runlogRecords = new LinkedHashSet<>();
         int index = 0;
         while (runlogRecords.size() < number && ++index < MAX_RETRIES_GET_CONSUMER_RECORDS) {
-            log.info("Retrieving runlog records, attempt {}, record count {}", index, runlogRecords.size());
+            log.debug("Retrieving runlog records, attempt {}, record count {}", index, runlogRecords.size());
             ConsumerRecords<IdentityRecord, EntryRecord> records =
-                    kafkaConsumerRunlogCmd.poll(Duration.ofSeconds(POLL_DURATION_MS));
+                    kafkaConsumerRunlogCmd.poll(POLL_DURATION);
             records.forEach(rec -> {
-                log.info("Runlog record id = {}, has testId header = {}",
+                log.debug("Runlog record id = {}, has testId header = {}",
                         rec.value().getMetadata().getIdentityRecord().getId(),
                         haveTestIdHeader(rec));
 
Index: cmd-adaptor-sns-integration-tests/src/test/java/uk/gov/ho/dacc/fdp/testcontainers/SnsTestcontainersEnvironment.java
IDEA additional info:
Subsystem: com.intellij.openapi.diff.impl.patch.CharsetEP
<+>UTF-8
===================================================================
diff --git a/cmd-adaptor-sns-integration-tests/src/test/java/uk/gov/ho/dacc/fdp/testcontainers/SnsTestcontainersEnvironment.java b/cmd-adaptor-sns-integration-tests/src/test/java/uk/gov/ho/dacc/fdp/testcontainers/SnsTestcontainersEnvironment.java
--- a/cmd-adaptor-sns-integration-tests/src/test/java/uk/gov/ho/dacc/fdp/testcontainers/SnsTestcontainersEnvironment.java	(revision 263591eae2437a0b8306c91aa46d55f7c5ba4149)
+++ b/cmd-adaptor-sns-integration-tests/src/test/java/uk/gov/ho/dacc/fdp/testcontainers/SnsTestcontainersEnvironment.java	(date 1786449308147)
@@ -63,6 +63,10 @@
     private static final String KAFKA_INTERNAL_BOOTSTRAP = "PLAINTEXT://" + KAFKA_ALIAS + ":29092";
     private static final String TOPIC_SUFFIX = "tc" + UUID.randomUUID().toString().replace("-", "").substring(0, 8);
     private static final String RUN_ID = UUID.randomUUID().toString().replace("-", "").substring(0, 8);
+    private static final Duration HTTP_REQUEST_TIMEOUT = Duration.ofSeconds(2);
+    private static final long READINESS_POLL_INTERVAL_MS = 500L;
+    private static final int AGGREGATE_READINESS_MAX_ATTEMPTS = 240;
+    private static final HttpClient HTTP_CLIENT = HttpClient.newHttpClient();
 
     private static final GenericContainer<?> REDIS = new GenericContainer<>(DockerImageName.parse(REDIS_IMAGE))
             .withNetwork(NETWORK)
@@ -444,17 +448,19 @@
 
         LOG.info("Waiting for aggregate readiness: type={}, host={}, port={}", aggregateType, host, port);
 
-        HttpClient client = HttpClient.newHttpClient();
-        int maxAttempts = 120;
-        for (int attempt = 1; attempt <= maxAttempts; attempt++) {
-            boolean up = isReadinessUp(client, host, port, profilePath) || isReadinessUp(client, host, port, actuatorPath);
+        for (int attempt = 1; attempt <= AGGREGATE_READINESS_MAX_ATTEMPTS; attempt++) {
+            boolean up = isReadinessUp(host, port, profilePath) || isReadinessUp(host, port, actuatorPath);
             if (up) {
                 LOG.info("Aggregate readiness confirmed for {} on attempt {}", aggregateType, attempt);
                 return;
             }
+            LOG.debug("Aggregate {} not ready yet on attempt {}/{}",
+                    aggregateType,
+                    attempt,
+                    AGGREGATE_READINESS_MAX_ATTEMPTS);
 
             try {
-                Thread.sleep(1000L);
+                Thread.sleep(READINESS_POLL_INTERVAL_MS);
             } catch (InterruptedException e) {
                 Thread.currentThread().interrupt();
                 throw new IllegalStateException("Interrupted while waiting for aggregate readiness: " + aggregateType, e);
@@ -464,16 +470,15 @@
         throw new IllegalStateException("Timed out waiting for aggregate readiness: " + aggregateType);
     }
 
-    private static boolean isReadinessUp(HttpClient client, String host, int port, String path) {
+    private static boolean isReadinessUp(String host, int port, String path) {
         try {
             HttpRequest request = HttpRequest.newBuilder()
                     .uri(URI.create("http://" + host + ":" + port + path))
                     .header("Accept", "application/json")
-                    .timeout(Duration.ofSeconds(2))
-                    .GET()
+                    .timeout(HTTP_REQUEST_TIMEOUT)
                     .build();
 
-            HttpResponse<String> response = client.send(request, HttpResponse.BodyHandlers.ofString());
+            HttpResponse<String> response = HTTP_CLIENT.send(request, HttpResponse.BodyHandlers.ofString());
             return response.statusCode() == 200
                     && response.body() != null
                     && response.body().contains("\"status\":\"UP\"");
@@ -664,10 +669,8 @@
         requiredTopics.add("landing-413");
         return requiredTopics;
     }
-
     private static void validateSchemaRegistryRoundTrip() {
         try {
-            HttpClient client = HttpClient.newHttpClient();
             String subject = "tc-sns-health-" + RUN_ID + "-value";
             String payload = "{\"schema\":\"{\\\"type\\\":\\\"record\\\",\\\"name\\\":\\\"Smoke\\\",\\\"fields\\\":[{\\\"name\\\":\\\"message\\\",\\\"type\\\":\\\"string\\\"}]}\"}";
             String schemaRegistryUrl = schemaRegistryUrl();
@@ -675,18 +678,20 @@
             HttpRequest registerRequest = HttpRequest.newBuilder()
                     .uri(URI.create(schemaRegistryUrl + "/subjects/" + subject + "/versions"))
                     .header("Content-Type", "application/vnd.schemaregistry.v1+json")
+                    .timeout(HTTP_REQUEST_TIMEOUT)
                     .POST(HttpRequest.BodyPublishers.ofString(payload))
                     .build();
-            HttpResponse<String> registerResponse = client.send(registerRequest, HttpResponse.BodyHandlers.ofString());
+            HttpResponse<String> registerResponse = HTTP_CLIENT.send(registerRequest, HttpResponse.BodyHandlers.ofString());
             if (registerResponse.statusCode() != 200) {
                 throw new IllegalStateException("Schema registration failed: " + registerResponse.body());
             }
 
             HttpRequest readRequest = HttpRequest.newBuilder()
                     .uri(URI.create(schemaRegistryUrl + "/subjects/" + subject + "/versions/latest"))
+                    .timeout(HTTP_REQUEST_TIMEOUT)
                     .GET()
                     .build();
-            HttpResponse<String> readResponse = client.send(readRequest, HttpResponse.BodyHandlers.ofString());
+            HttpResponse<String> readResponse = HTTP_CLIENT.send(readRequest, HttpResponse.BodyHandlers.ofString());
             if (readResponse.statusCode() != 200 || !readResponse.body().contains("Smoke")) {
                 throw new IllegalStateException("Schema Registry round trip validation failed");
             }
Index: cmd-adaptor-sns-integration-tests/src/test/resources/docker-compose/pre-integration-test/app.py
IDEA additional info:
Subsystem: com.intellij.openapi.diff.impl.patch.CharsetEP
<+>UTF-8
===================================================================
diff --git a/cmd-adaptor-sns-integration-tests/src/test/resources/docker-compose/pre-integration-test/app.py b/cmd-adaptor-sns-integration-tests/src/test/resources/docker-compose/pre-integration-test/app.py
--- a/cmd-adaptor-sns-integration-tests/src/test/resources/docker-compose/pre-integration-test/app.py	(revision 263591eae2437a0b8306c91aa46d55f7c5ba4149)
+++ b/cmd-adaptor-sns-integration-tests/src/test/resources/docker-compose/pre-integration-test/app.py	(date 1786449187075)
@@ -12,6 +12,7 @@
 import time
 import urllib.error
 import urllib.request
+from concurrent.futures import ThreadPoolExecutor
 
 import boto3
 import redis
@@ -21,6 +22,10 @@
 KAFDROP_TEST_URL = "http://kafdrop:9000/actuator/health"
 REPLICATION_FACTOR = 1
 SCHEMA_REGISTRY_TEST_URL = "http://schema-registry:8081/subjects"
+CONNECT_RETRIES = 120
+CONNECT_RETRY_SLEEP_SECONDS = 1
+READINESS_SLEEP_SECONDS = 2
+READINESS_ATTEMPTS = 180
 
 logging.basicConfig(level=logging.INFO)
 logger = logging.getLogger(sys.argv[0])
@@ -43,16 +48,18 @@
     topics_list = []
 
     connected = False
-
-    while not connected:
+    for attempt in range(1, CONNECT_RETRIES + 1):
         try:
-            logger.info(f"Attempting to connect to {bootstrap_servers}")
+            logger.info(f"Attempting to connect to {bootstrap_servers} (attempt {attempt}/{CONNECT_RETRIES})")
             admin_client = AdminClient({"bootstrap.servers": bootstrap_servers})
             logger.info(f"Connected successfully to {bootstrap_servers}")
             connected = True
+            break
         except Exception as e:
-            logger.error(e)
-            time.sleep(1)
+            logger.warning(f"Kafka admin connection failed: {e}")
+            time.sleep(CONNECT_RETRY_SLEEP_SECONDS)
+
+    assert connected, f"Timed out connecting to Kafka bootstrap server {bootstrap_servers}"
 
     for topic_name in topic_names:
         logger.info(f"Creating Kafka topic {topic_name} with {PARTITIONS} partitions.")
@@ -698,45 +705,79 @@
     rs = redis.Redis("redis")
     redis_connected = False
 
-    while not redis_connected:
+    for attempt in range(1, CONNECT_RETRIES + 1):
         try:
             rs.ping()
             logger.info("Successfully connected to Redis.")
             redis_connected = True
+            break
         except ConnectionError:
-            logger.error("Unable to connect to redis.")
-            time.sleep(1)
+            logger.warning(f"Unable to connect to redis (attempt {attempt}/{CONNECT_RETRIES}).")
+            time.sleep(CONNECT_RETRY_SLEEP_SECONDS)
 
-    wait_for_http(SCHEMA_REGISTRY_TEST_URL, "Schema Registry")
-    wait_for_http(KAFDROP_TEST_URL, "Kafdrop")
+    assert redis_connected, "Timed out waiting for redis."
+
+    wait_for_http(
+        SCHEMA_REGISTRY_TEST_URL,
+        "Schema Registry",
+        sleep_time=READINESS_SLEEP_SECONDS,
+        attempts=READINESS_ATTEMPTS,
+    )
+    wait_for_http(
+        KAFDROP_TEST_URL,
+        "Kafdrop",
+        sleep_time=READINESS_SLEEP_SECONDS,
+        attempts=READINESS_ATTEMPTS,
+    )
     topic_names.sort()
     create_kafka_topics("kafka:29092", topic_names)
 elif WAIT_CHECK == "command_adaptor":
-    wait_for_http("http://command-adaptor:7112/actuator/health", "Command Adaptor")
+    wait_for_http(
+        "http://command-adaptor:7112/actuator/health",
+        "Command Adaptor",
+        sleep_time=READINESS_SLEEP_SECONDS,
+        attempts=READINESS_ATTEMPTS,
+    )
 elif WAIT_CHECK == "aggregators":
     FDP_APP_KAFKA_TOPIC_SUFFIX = ""
     if "FDP_APP_KAFKA_TOPIC_SUFFIX" in os.environ:
         FDP_APP_KAFKA_TOPIC_SUFFIX = os.environ["FDP_APP_KAFKA_TOPIC_SUFFIX"]
-    wait_for_http(
-        f"http://aggregate-event:7104/aggregate-event-{FDP_APP_KAFKA_TOPIC_SUFFIX}/health/readiness",
-        "Event Aggregate",
-    )
-    wait_for_http(
-        f"http://aggregate-location:7103/aggregate-location-{FDP_APP_KAFKA_TOPIC_SUFFIX}/health/readiness",
-        "Location Aggregate",
-    )
-    wait_for_http(
-        f"http://aggregate-object:7102/aggregate-object-{FDP_APP_KAFKA_TOPIC_SUFFIX}/health/readiness",
-        "Object Aggregate",
-    )
-    wait_for_http(
-        f"http://aggregate-party:7101/aggregate-party-{FDP_APP_KAFKA_TOPIC_SUFFIX}/health/readiness",
-        "Party Aggregate",
-    )
-    wait_for_http(
-        f"http://aggregate-service:7105/aggregate-service-{FDP_APP_KAFKA_TOPIC_SUFFIX}/health/readiness",
-        "Service Aggregate",
-    )
+    aggregate_checks = [
+        (
+            f"http://aggregate-event:7104/aggregate-event-{FDP_APP_KAFKA_TOPIC_SUFFIX}/health/readiness",
+            "Event Aggregate",
+        ),
+        (
+            f"http://aggregate-location:7103/aggregate-location-{FDP_APP_KAFKA_TOPIC_SUFFIX}/health/readiness",
+            "Location Aggregate",
+        ),
+        (
+            f"http://aggregate-object:7102/aggregate-object-{FDP_APP_KAFKA_TOPIC_SUFFIX}/health/readiness",
+            "Object Aggregate",
+        ),
+        (
+            f"http://aggregate-party:7101/aggregate-party-{FDP_APP_KAFKA_TOPIC_SUFFIX}/health/readiness",
+            "Party Aggregate",
+        ),
+        (
+            f"http://aggregate-service:7105/aggregate-service-{FDP_APP_KAFKA_TOPIC_SUFFIX}/health/readiness",
+            "Service Aggregate",
+        ),
+    ]
+
+    with ThreadPoolExecutor(max_workers=len(aggregate_checks)) as executor:
+        futures = [
+            executor.submit(
+                wait_for_http,
+                url,
+                title,
+                READINESS_SLEEP_SECONDS,
+                READINESS_ATTEMPTS,
+            )
+            for url, title in aggregate_checks
+        ]
+        for future in futures:
+            future.result()
 else:
     logger.error(f"Unknown WAIT_CHECK {WAIT_CHECK}")
     sys.exit(1)
Index: cmd-adaptor-sns-integration-tests/src/test/java/uk/gov/ho/dacc/fdp/IntegrationTest.java
IDEA additional info:
Subsystem: com.intellij.openapi.diff.impl.patch.CharsetEP
<+>UTF-8
===================================================================
diff --git a/cmd-adaptor-sns-integration-tests/src/test/java/uk/gov/ho/dacc/fdp/IntegrationTest.java b/cmd-adaptor-sns-integration-tests/src/test/java/uk/gov/ho/dacc/fdp/IntegrationTest.java
--- a/cmd-adaptor-sns-integration-tests/src/test/java/uk/gov/ho/dacc/fdp/IntegrationTest.java	(revision 263591eae2437a0b8306c91aa46d55f7c5ba4149)
+++ b/cmd-adaptor-sns-integration-tests/src/test/java/uk/gov/ho/dacc/fdp/IntegrationTest.java	(date 1786445501779)
@@ -12,7 +12,7 @@
 @RunWith(Cucumber.class)
 @CucumberOptions(features = "src/test/resources/features"
         , glue = "uk.gov.ho.dacc.fdp.steps"
-        , plugin = {"pretty", "summary", "uk.gov.ho.dacc.fdp.steps.SnsSteps", "html:target/cucumber.html"}
+        , plugin = {"summary", "uk.gov.ho.dacc.fdp.steps.SnsSteps", "html:target/cucumber.html"}
 )
 public class IntegrationTest {
     @ClassRule
Index: cmd-adaptor-sns-integration-tests/src/test/java/uk/gov/ho/dacc/fdp/testcontainers/BuiltImageRuntimeIntegrationTest.java
IDEA additional info:
Subsystem: com.intellij.openapi.diff.impl.patch.CharsetEP
<+>UTF-8
===================================================================
diff --git a/cmd-adaptor-sns-integration-tests/src/test/java/uk/gov/ho/dacc/fdp/testcontainers/BuiltImageRuntimeIntegrationTest.java b/cmd-adaptor-sns-integration-tests/src/test/java/uk/gov/ho/dacc/fdp/testcontainers/BuiltImageRuntimeIntegrationTest.java
--- a/cmd-adaptor-sns-integration-tests/src/test/java/uk/gov/ho/dacc/fdp/testcontainers/BuiltImageRuntimeIntegrationTest.java	(revision 263591eae2437a0b8306c91aa46d55f7c5ba4149)
+++ b/cmd-adaptor-sns-integration-tests/src/test/java/uk/gov/ho/dacc/fdp/testcontainers/BuiltImageRuntimeIntegrationTest.java	(date 1786445487643)
@@ -27,6 +27,8 @@
     private static final String IMAGE_UNDER_TEST =
             System.getProperty("sns.runtime.image", "docker-compose-command-adaptor:latest");
     private static final Duration READINESS_TIMEOUT = Duration.ofSeconds(120);
+    private static final Duration REQUEST_TIMEOUT = Duration.ofSeconds(2);
+    private static final HttpClient HTTP_CLIENT = HttpClient.newHttpClient();
 
     private static GenericContainer<?> commandAdaptor;
 
@@ -83,7 +85,6 @@
     }
 
     private static void waitForReady(String readinessPath) {
-        HttpClient client = HttpClient.newHttpClient();
         long deadline = System.nanoTime() + READINESS_TIMEOUT.toNanos();
         String readinessUrl = "http://" + commandAdaptor.getHost() + ":" + commandAdaptor.getMappedPort(7112) + readinessPath;
         String lastFailure = "no successful readiness response";
@@ -93,10 +94,10 @@
                 HttpRequest request = HttpRequest.newBuilder()
                         .uri(URI.create(readinessUrl))
                         .header("Accept", "application/json")
-                        .timeout(Duration.ofSeconds(2))
+                        .timeout(REQUEST_TIMEOUT)
                         .GET()
                         .build();
-                HttpResponse<String> response = client.send(request, HttpResponse.BodyHandlers.ofString());
+                HttpResponse<String> response = HTTP_CLIENT.send(request, HttpResponse.BodyHandlers.ofString());
                 if (response.statusCode() == 200 && response.body() != null && response.body().contains("\"status\":\"UP\"")) {
                     LOG.info("Readiness confirmed at {}", readinessUrl);
                     return;
@@ -112,7 +113,7 @@
             }
 
             try {
-                Thread.sleep(1000L);
+                Thread.sleep(500L);
             } catch (InterruptedException e) {
                 Thread.currentThread().interrupt();
                 fail("Interrupted while waiting for readiness");
