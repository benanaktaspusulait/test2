package uk.gov.ho.dacc.fdp.testcontainers;

import org.apache.kafka.clients.admin.AdminClient;
import org.apache.kafka.clients.admin.NewTopic;
import org.apache.kafka.clients.consumer.ConsumerConfig;
import org.apache.kafka.clients.consumer.ConsumerRecord;
import org.apache.kafka.clients.consumer.ConsumerRecords;
import org.apache.kafka.clients.consumer.KafkaConsumer;
import org.apache.kafka.clients.producer.KafkaProducer;
import org.apache.kafka.clients.producer.ProducerRecord;
import org.apache.kafka.common.serialization.StringDeserializer;
import org.apache.kafka.common.serialization.StringSerializer;
import org.junit.jupiter.api.BeforeAll;
import org.junit.jupiter.api.Tag;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.testcontainers.junit.jupiter.Testcontainers;

import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.time.Duration;
import java.util.Collections;
import java.util.Map;
import java.util.Properties;
import java.util.UUID;
import java.util.concurrent.TimeUnit;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertTrue;

@Tag("testcontainers")
@Testcontainers(disabledWithoutDocker = true)
@ExtendWith(TestcontainersFailureDiagnostics.class)
class KafkaSchemaRegistrySmokeTest {

    @BeforeAll
    static void startInfrastructure() {
        SnsTestcontainersEnvironment.startInfrastructure();
    }

    @Test
    void kafkaProduceConsumeRoundTrip() throws Exception {
        String topic = "tc-kafka-smoke-" + UUID.randomUUID().toString().replace("-", "").substring(0, 8);
        Map<String, Object> adminConfig = Map.of(
                "bootstrap.servers", SnsTestcontainersEnvironment.getKafkaBootstrapServers()
        );

        try (AdminClient adminClient = AdminClient.create(adminConfig)) {
            adminClient.createTopics(Collections.singletonList(new NewTopic(topic, 1, (short) 1)))
                    .all()
                    .get(30, TimeUnit.SECONDS);
        }

        Properties producerProps = new Properties();
        producerProps.put("bootstrap.servers", SnsTestcontainersEnvironment.getKafkaBootstrapServers());
        producerProps.put("key.serializer", StringSerializer.class.getName());
        producerProps.put("value.serializer", StringSerializer.class.getName());

        Properties consumerProps = new Properties();
        consumerProps.put(ConsumerConfig.BOOTSTRAP_SERVERS_CONFIG, SnsTestcontainersEnvironment.getKafkaBootstrapServers());
        consumerProps.put(ConsumerConfig.GROUP_ID_CONFIG, "tc-smoke-" + UUID.randomUUID());
        consumerProps.put(ConsumerConfig.AUTO_OFFSET_RESET_CONFIG, "earliest");
        consumerProps.put(ConsumerConfig.KEY_DESERIALIZER_CLASS_CONFIG, StringDeserializer.class.getName());
        consumerProps.put(ConsumerConfig.VALUE_DESERIALIZER_CLASS_CONFIG, StringDeserializer.class.getName());

        String payload = "smoke-payload-" + UUID.randomUUID();
        try (KafkaProducer<String, String> producer = new KafkaProducer<>(producerProps);
             KafkaConsumer<String, String> consumer = new KafkaConsumer<>(consumerProps)) {
            consumer.subscribe(Collections.singletonList(topic));
            producer.send(new ProducerRecord<>(topic, "key", payload)).get(15, TimeUnit.SECONDS);

            boolean received = false;
            String consumedValue = null;
            for (int i = 0; i < 20 && !received; i++) {
                ConsumerRecords<String, String> records = consumer.poll(Duration.ofMillis(500));
                for (ConsumerRecord<String, String> record : records) {
                    consumedValue = record.value();
                    received = true;
                    break;
                }
            }

            assertTrue(received, "Expected Kafka consumer to receive produced record");
            assertEquals(payload, consumedValue, "Consumed payload should match produced payload");
        }
    }

    @Test
    void schemaRegistryRegisterAndReadBackSchema() throws Exception {
        HttpClient client = HttpClient.newHttpClient();
        String subject = "tc-smoke-schema-" + UUID.randomUUID() + "-value";
        String payload = "{\"schema\":\"{\\\"type\\\":\\\"record\\\",\\\"name\\\":\\\"SmokeSchema\\\",\\\"fields\\\":[{\\\"name\\\":\\\"message\\\",\\\"type\\\":\\\"string\\\"}]}\"}";

        HttpRequest registerRequest = HttpRequest.newBuilder()
                .uri(URI.create(SnsTestcontainersEnvironment.getSchemaRegistryUrl() + "/subjects/" + subject + "/versions"))
                .header("Content-Type", "application/vnd.schemaregistry.v1+json")
                .POST(HttpRequest.BodyPublishers.ofString(payload))
                .build();
        HttpResponse<String> registerResponse = client.send(registerRequest, HttpResponse.BodyHandlers.ofString());

        HttpRequest readRequest = HttpRequest.newBuilder()
                .uri(URI.create(SnsTestcontainersEnvironment.getSchemaRegistryUrl() + "/subjects/" + subject + "/versions/latest"))
                .GET()
                .build();
        HttpResponse<String> readResponse = client.send(readRequest, HttpResponse.BodyHandlers.ofString());

        assertEquals(200, registerResponse.statusCode(), "Schema registration should succeed");
        assertEquals(200, readResponse.statusCode(), "Schema retrieval should succeed");
        assertTrue(readResponse.body().contains("SmokeSchema"),
                "Registered schema should be retrievable from Schema Registry");
    }
}

