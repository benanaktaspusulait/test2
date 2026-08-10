package uk.gov.ho.dacc.fdp.config;

import lookup.LookupEoriValue;
import org.apache.kafka.clients.producer.ProducerConfig;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.kafka.core.DefaultKafkaProducerFactory;
import org.springframework.kafka.core.KafkaTemplate;
import org.springframework.kafka.core.ProducerFactory;

import java.util.Map;
import java.util.Properties;

@SuppressWarnings("unchecked")
@Configuration
public class LookupKafkaTemplate {

    private final Map<String, Object> eoriProps;

    @Autowired
    public LookupKafkaTemplate(@Qualifier("kafkaProperties") Properties kafkaProperties,
                               LookupKafkaSerdeConfig lookupConfig) {
        Map<String, Object> map = (Map<String, Object>) kafkaProperties.clone();
        map.put(ProducerConfig.KEY_SERIALIZER_CLASS_CONFIG,
                lookupConfig.getStringSerde().serializer().getClass());
        map.put(ProducerConfig.VALUE_SERIALIZER_CLASS_CONFIG,
                lookupConfig.getLookupEoriValueSerde().serializer().getClass());
        this.eoriProps = map;
    }

    @Bean
    public ProducerFactory<String, LookupEoriValue> producerLookupFactory() {
        return new DefaultKafkaProducerFactory<>(eoriProps);
    }

    @Bean
    public KafkaTemplate<String, LookupEoriValue> kafkaLookupTemplate() {
        return new KafkaTemplate<>(producerLookupFactory());
    }
}
