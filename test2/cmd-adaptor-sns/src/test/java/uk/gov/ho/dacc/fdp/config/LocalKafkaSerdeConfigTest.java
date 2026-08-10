package uk.gov.ho.dacc.fdp.config;

import io.confluent.kafka.schemaregistry.client.MockSchemaRegistryClient;
import io.confluent.kafka.serializers.AbstractKafkaSchemaSerDeConfig;
import io.confluent.kafka.streams.serdes.avro.SpecificAvroSerde;
import jakarta.annotation.PostConstruct;
import lombok.Getter;
import lookup.LookupEoriValue;
import org.apache.kafka.common.serialization.Serde;
import org.apache.kafka.common.serialization.Serdes;
import org.springframework.context.annotation.Profile;
import org.springframework.stereotype.Component;
import uk.gov.ho.dacc.pole.identity.PoleV2IdRecord;
import uk.gov.ho.dsa.cdl.hmrc.eori.CdlzLandingRecord;
import uk.gov.ho.dsa.cdl.hmrc.snsens.StreamIngestRecord;

import java.util.Collections;
import java.util.Map;

@SuppressWarnings("squid:S2187")
@Getter
@Component("LocalKafkaSerdeConfigImpl")
@Profile("test")
public class LocalKafkaSerdeConfigTest implements LocalKafkaSerdeConfig {

    private Serde<PoleV2IdRecord> poleV2IdRecord;

    private Serde<String> stringSerde;
    private Serde<StreamIngestRecord> cdlzRecordSerde;
    private Serde<CdlzLandingRecord> eoriCdlzRecordSerde;
    private Serde<LookupEoriValue> lookupEoriValueSerde;

    @PostConstruct
    public void init() {
        Map<String, String> serdeConfig = Collections.singletonMap(AbstractKafkaSchemaSerDeConfig.SCHEMA_REGISTRY_URL_CONFIG, "http://dummy");
        MockSchemaRegistryClient client = new MockSchemaRegistryClient();

        poleV2IdRecord = new SpecificAvroSerde<>(client);
        poleV2IdRecord.configure(serdeConfig, true); // `true` for record keys

        // TODO TESTS HERE

        stringSerde = new Serdes.StringSerde();
        stringSerde.configure(serdeConfig, true); // `false` for record values

        cdlzRecordSerde = new SpecificAvroSerde<>(client);
        cdlzRecordSerde.configure(serdeConfig, false); // `false` for record values

        eoriCdlzRecordSerde = new SpecificAvroSerde<>(client);
        eoriCdlzRecordSerde.configure(serdeConfig, false);

        lookupEoriValueSerde = new SpecificAvroSerde<>(client);
        lookupEoriValueSerde.configure(serdeConfig, false);
    }
}
