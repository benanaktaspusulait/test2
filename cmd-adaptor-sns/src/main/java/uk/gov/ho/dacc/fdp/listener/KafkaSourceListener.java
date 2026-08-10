package uk.gov.ho.dacc.fdp.listener;

import lombok.extern.slf4j.Slf4j;
import org.apache.avro.generic.GenericRecord;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.kafka.annotation.KafkaListener;
import org.springframework.kafka.core.KafkaTemplate;
import org.springframework.stereotype.Service;
import uk.gov.ho.dacc.fdp.fdp_commons.config.KafkaTopics;

@Slf4j
@Service
public class KafkaSourceListener {

private final KafkaTemplate<String, GenericRecord> kafkaTemplate;
    private final KafkaTopics kafkaTopics;

    @Autowired
    public KafkaSourceListener(KafkaTemplate<String, GenericRecord> kafkaTemplate, KafkaTopics kafkaTopics) {
        this.kafkaTemplate = kafkaTemplate;
        this.kafkaTopics = kafkaTopics;
    }

    @KafkaListener(topics = "${app.topic.cdlz-incoming}")
    public void listen(GenericRecord message) {
        try {
            kafkaTemplate.send(kafkaTopics.getAdaptorInputTopic(), message);
        } catch (Exception e) {
            log.error("Error processing message", e);
        }
    }
}
