package uk.gov.ho.dacc.fdp.lookups;

import org.springframework.stereotype.Component;
import uk.gov.ho.dacc.fdp.config.LookupKafkaSerdeConfig;
import uk.gov.ho.dacc.fdp.fdp_commons.config.KafkaStreamConfig;

@Component("eoriNullLookup")
public class EoriNullLookup extends BaseEoriLookup {

    protected EoriNullLookup(LookupKafkaSerdeConfig lookupConfig,
                             KafkaStreamConfig kafkaStreamConfig) {
        super(lookupConfig, kafkaStreamConfig);
    }

    @Override
    public CharSequence lookup(CharSequence key) {
        return initialLookup(key) == null ? null : "true";
    }
}