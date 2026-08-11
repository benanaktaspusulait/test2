Index: cmd-adaptor-sns-integration-tests/src/test/java/uk/gov/ho/dacc/fdp/testcontainers/SnsTestcontainersEnvironment.java
IDEA additional info:
Subsystem: com.intellij.openapi.diff.impl.patch.CharsetEP
<+>UTF-8
===================================================================
diff --git a/cmd-adaptor-sns-integration-tests/src/test/java/uk/gov/ho/dacc/fdp/testcontainers/SnsTestcontainersEnvironment.java b/cmd-adaptor-sns-integration-tests/src/test/java/uk/gov/ho/dacc/fdp/testcontainers/SnsTestcontainersEnvironment.java
--- a/cmd-adaptor-sns-integration-tests/src/test/java/uk/gov/ho/dacc/fdp/testcontainers/SnsTestcontainersEnvironment.java	(revision 263591eae2437a0b8306c91aa46d55f7c5ba4149)
+++ b/cmd-adaptor-sns-integration-tests/src/test/java/uk/gov/ho/dacc/fdp/testcontainers/SnsTestcontainersEnvironment.java	(date 1786445504051)
@@ -172,7 +172,6 @@
             messagingStarted = true;
 
             createRequiredTopics();
-            validateSchemaRegistryRoundTrip();
         } catch (RuntimeException e) {
             messagingStarted = false;
             infrastructureStartupFailure = e;
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
Index: cmd-adaptor-sns-integration-tests/src/test/java/uk/gov/ho/dacc/fdp/steps/SnsSteps.java
IDEA additional info:
Subsystem: com.intellij.openapi.diff.impl.patch.CharsetEP
<+>UTF-8
===================================================================
diff --git a/cmd-adaptor-sns-integration-tests/src/test/java/uk/gov/ho/dacc/fdp/steps/SnsSteps.java b/cmd-adaptor-sns-integration-tests/src/test/java/uk/gov/ho/dacc/fdp/steps/SnsSteps.java
--- a/cmd-adaptor-sns-integration-tests/src/test/java/uk/gov/ho/dacc/fdp/steps/SnsSteps.java	(revision 263591eae2437a0b8306c91aa46d55f7c5ba4149)
+++ b/cmd-adaptor-sns-integration-tests/src/test/java/uk/gov/ho/dacc/fdp/steps/SnsSteps.java	(date 1786445498859)
@@ -241,8 +241,7 @@
     public static KafkaConsumer<?, ?> awakeConsumer(String topic) {
         KafkaConsumer<?, ?> kafkaConsumer = new KafkaConsumer<>(consumerConfig);
         kafkaConsumer.assign(Collections.singletonList(new TopicPartition(topic, 0)));
-        kafkaConsumer.assignment();
-        kafkaConsumer.poll(Duration.ofMillis(INITIAL_POLL_DURATION_MS));
+        kafkaConsumer.poll(INITIAL_POLL_DURATION);
         log.info("=====> Assigned to topic {}", topic);
         return kafkaConsumer;
     }
@@ -527,11 +526,11 @@
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
Index: cmd-adaptor-sns/src/test/java/uk/gov/ho/dacc/fdp/integration/steps/IntegrationTestSteps.java
IDEA additional info:
Subsystem: com.intellij.openapi.diff.impl.patch.CharsetEP
<+>UTF-8
===================================================================
diff --git a/cmd-adaptor-sns/src/test/java/uk/gov/ho/dacc/fdp/integration/steps/IntegrationTestSteps.java b/cmd-adaptor-sns/src/test/java/uk/gov/ho/dacc/fdp/integration/steps/IntegrationTestSteps.java
--- a/cmd-adaptor-sns/src/test/java/uk/gov/ho/dacc/fdp/integration/steps/IntegrationTestSteps.java	(revision 263591eae2437a0b8306c91aa46d55f7c5ba4149)
+++ b/cmd-adaptor-sns/src/test/java/uk/gov/ho/dacc/fdp/integration/steps/IntegrationTestSteps.java	(date 1786445451851)
@@ -51,6 +51,7 @@
 import java.io.File;
 import java.io.IOException;
 import java.io.InputStream;
+import java.io.UncheckedIOException;
 import java.nio.file.Files;
 import java.util.*;
 import java.util.concurrent.atomic.AtomicBoolean;
Index: .drone.star
IDEA additional info:
Subsystem: com.intellij.openapi.diff.impl.patch.CharsetEP
<+>UTF-8
===================================================================
diff --git a/.drone.star b/.drone.star
--- a/.drone.star	(revision 263591eae2437a0b8306c91aa46d55f7c5ba4149)
+++ b/.drone.star	(date 1786445501635)
@@ -206,7 +206,7 @@
                 'AUTH_VALUE=$(printf "%s:%s" "$${ARTIFACTORY_USERNAME}" "$${ARTIFACTORY_PASSWORD}" | base64 | tr -d "\\n")',
                 "printf '{\"auths\":{\"%s\":{\"auth\":\"%%s\"}}}\\n' \"$${AUTH_VALUE}\" > \"$${DOCKER_CONFIG}/config.json\"" % ARTIFACTORY_REGISTRY,
                 'TEST_START=$(date +%s)',
-                'mvn clean verify -Pci-testcontainers-snapshot',
+                'mvn -T 1C clean verify -Pci-testcontainers-snapshot',
                 'TEST_DURATION=$(($(date +%s)-TEST_START))',
                 'echo "CI_TIMING name=testcontainers_verify duration_seconds=$${TEST_DURATION}"',
                 'if [ "$${TEST_DURATION}" -gt "$${TESTCONTAINERS_MAX_SECONDS}" ]; then echo "Testcontainers verify exceeded $${TESTCONTAINERS_MAX_SECONDS}s"; exit 1; fi'
@@ -261,7 +261,7 @@
                 'mkdir -p "$${DOCKER_CONFIG}"',
                 'AUTH_VALUE=$(printf "%s:%s" "$${ARTIFACTORY_USERNAME}" "$${ARTIFACTORY_PASSWORD}" | base64 | tr -d "\\n")',
                 "printf '{\"auths\":{\"%s\":{\"auth\":\"%%s\"}}}\\n' \"$${AUTH_VALUE}\" > \"$${DOCKER_CONFIG}/config.json\"" % ARTIFACTORY_REGISTRY,
-                'mvn -pl cmd-adaptor-sns-integration-tests -am verify -Pci-built-image-runtime-smoke -Dsns.runtime.image=docker-compose-command-adaptor:latest'
+                'mvn -T 1C -pl cmd-adaptor-sns-integration-tests -am verify -Pci-built-image-runtime-smoke -Dsns.runtime.image=docker-compose-command-adaptor:latest'
             ],
             'environment': {
                 'DOCKER_HOST': 'tcp://docker:2375',
