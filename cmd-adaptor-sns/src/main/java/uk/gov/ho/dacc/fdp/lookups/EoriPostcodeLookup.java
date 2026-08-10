package uk.gov.ho.dacc.fdp.lookups;

import lookup.LookupEoriValue;
import org.springframework.stereotype.Component;
import uk.gov.ho.dacc.fdp.config.LookupKafkaSerdeConfig;
import uk.gov.ho.dacc.fdp.fdp_commons.config.KafkaStreamConfig;

@Component("eoriPostcodeLookup")
public class EoriPostcodeLookup extends BaseEoriLookup {

    protected EoriPostcodeLookup(LookupKafkaSerdeConfig lookupConfig,
                                 KafkaStreamConfig kafkaStreamConfig) {
        super(lookupConfig, kafkaStreamConfig);
    }

    @Override
    public CharSequence lookup(CharSequence key) {
        LookupEoriValue lookupEoriValue = initialLookup(key);
        return lookupEoriValue == null ? null : lookupEoriValue.getPostcode();
    }
}