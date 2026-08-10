package uk.gov.ho.dacc.fdp.lookups;

import lookup.LookupEoriValue;
import org.springframework.stereotype.Component;
import uk.gov.ho.dacc.fdp.config.LookupKafkaSerdeConfig;
import uk.gov.ho.dacc.fdp.fdp_commons.config.KafkaStreamConfig;

import java.util.Objects;
import java.util.stream.Collectors;
import java.util.stream.Stream;

@Component("eoriLookup")
public class EoriLookup extends BaseEoriLookup {

    protected EoriLookup(LookupKafkaSerdeConfig lookupConfig,
                         KafkaStreamConfig kafkaStreamConfig) {
        super(lookupConfig, kafkaStreamConfig);
    }

    @Override
    public CharSequence lookup(CharSequence key) {
        LookupEoriValue lookupEoriValue = initialLookup(key);
        return lookupEoriValue == null ? key :
                Stream.of(lookupEoriValue.getTraderName(),
                                lookupEoriValue.getStreetAndNumber(),
                                lookupEoriValue.getPostcode(),
                                lookupEoriValue.getCity())
                        .filter(Objects::nonNull)
                        .collect(Collectors.joining(","));
    }
}