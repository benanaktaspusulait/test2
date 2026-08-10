package uk.gov.ho.dacc.fdp.lookups;

import io.micrometer.core.instrument.Metrics;
import jakarta.annotation.PostConstruct;
import lombok.extern.slf4j.Slf4j;
import lookup.LookupEoriValue;
import org.apache.commons.lang3.StringUtils;
import org.apache.kafka.streams.KafkaStreams;
import org.apache.kafka.streams.StoreQueryParameters;
import org.apache.kafka.streams.StreamsBuilder;
import org.apache.kafka.streams.kstream.Consumed;
import org.apache.kafka.streams.kstream.GlobalKTable;
import org.apache.kafka.streams.kstream.Materialized;
import org.apache.kafka.streams.state.QueryableStoreTypes;
import org.apache.kafka.streams.state.ReadOnlyKeyValueStore;
import org.apache.kafka.streams.state.Stores;
import org.springframework.beans.factory.annotation.Value;
import uk.gov.ho.dacc.fdp.CmdAdaptorConstants;
import uk.gov.ho.dacc.fdp.config.LookupKafkaSerdeConfig;
import uk.gov.ho.dacc.fdp.fdp_commons.config.KafkaStreamConfig;
import uk.gov.ho.dacc.fdp.lookup.ILookup;
import uk.gov.ho.dacc.fdp.service.CmdAdaptorService;

@Slf4j
public abstract class BaseEoriLookup implements ILookup {

    @Value("${app.lookup.eori.lookup-topic}")
    private String lookupTopic;

    private final LookupKafkaSerdeConfig lookupConfig;

    private final KafkaStreamConfig kafkaStreamConfig;

    private static GlobalKTable<String, LookupEoriValue> globalKTable;

    private static ReadOnlyKeyValueStore<String, LookupEoriValue> keyValueStore;

    public static final String EORI_LOOKUP_NOT_FOUND = "eori_not_found";

    protected BaseEoriLookup(LookupKafkaSerdeConfig lookupConfig, KafkaStreamConfig kafkaStreamConfig) {
        this.lookupConfig = lookupConfig;
        this.kafkaStreamConfig = kafkaStreamConfig;
    }

    @PostConstruct
    private void init() {
        if (globalKTable == null) {
            StreamsBuilder streamsBuilder = CmdAdaptorService.streamsBuilderThreadLocal.get();
            globalKTable = streamsBuilder
                    .globalTable(lookupTopic,
                            Consumed.with(lookupConfig.getStringSerde(), lookupConfig.getLookupEoriValueSerde()),
                            Materialized.as(Stores.inMemoryKeyValueStore("eori")
                            )
                    );
        }
    }

    private boolean initialise() {
        if (keyValueStore == null) {
            KafkaStreams kafkaStreams = kafkaStreamConfig.getKafkaStream(CmdAdaptorService.class.getName());
            keyValueStore = kafkaStreams.store(
                    StoreQueryParameters.fromNameAndType(globalKTable.queryableStoreName(),
                            QueryableStoreTypes.keyValueStore())
            );
        }
        return true;
    }

    public LookupEoriValue initialLookup(CharSequence key) {
        if (initialise() && StringUtils.isNotBlank(key)) {
            LookupEoriValue lookupEoriValue = keyValueStore.get(key.toString());
            if (lookupEoriValue == null) {
                Metrics.counter(CmdAdaptorConstants.METRICS_PREFIX + EORI_LOOKUP_NOT_FOUND).increment();
                log.error("No EORI lookup value found in store '{}' for key '{}'", globalKTable.queryableStoreName(), key);
            }
            return lookupEoriValue;
        }
        return null;
    }

    @Override
    public abstract CharSequence lookup(CharSequence key);

}