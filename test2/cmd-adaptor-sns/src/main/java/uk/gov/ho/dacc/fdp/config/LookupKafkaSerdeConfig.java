package uk.gov.ho.dacc.fdp.config;

import io.confluent.kafka.streams.serdes.avro.SpecificAvroSerde;
import jakarta.annotation.PostConstruct;
import lombok.Getter;
import lookup.LookupEoriValue;
import org.apache.kafka.common.serialization.Serde;
import org.apache.kafka.common.serialization.Serdes;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import java.util.Collections;
import java.util.Map;

import static io.confluent.kafka.serializers.AbstractKafkaSchemaSerDeConfig.SCHEMA_REGISTRY_URL_CONFIG;


@Getter
@Component
public class LookupKafkaSerdeConfig {

    private Serde<String> stringSerde;
    private Serde<LookupEoriValue> lookupEoriValueSerde;

    @Value("${app.kafka.schema-registry-url}")
    private String schemaRegistryURL;

    @PostConstruct
    public void init() {
        Map<String, String> serdeConfig = Collections.singletonMap(SCHEMA_REGISTRY_URL_CONFIG, schemaRegistryURL);

        stringSerde = new Serdes.StringSerde();
        stringSerde.configure(serdeConfig, true);

        lookupEoriValueSerde = new SpecificAvroSerde<>();
        lookupEoriValueSerde.configure(serdeConfig, false);
    }

}
