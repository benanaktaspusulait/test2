package uk.gov.ho.dacc.fdp.listener;

import org.apache.avro.generic.GenericRecord;
import org.junit.Test;
import org.springframework.kafka.core.KafkaTemplate;
import uk.gov.ho.dacc.fdp.fdp_commons.config.KafkaTopics;

import static org.mockito.Mockito.doThrow;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

public class KafkaSourceListenerTest {

    @Test
    public void listen_shouldSendMessageToAdaptorInputTopic() {
        KafkaTemplate<String, GenericRecord> kafkaTemplate = mock(KafkaTemplate.class);
        KafkaTopics kafkaTopics = mock(KafkaTopics.class);
        GenericRecord message = mock(GenericRecord.class);

        when(kafkaTopics.getAdaptorInputTopic()).thenReturn("adaptor-input-topic");

        KafkaSourceListener listener = new KafkaSourceListener(kafkaTemplate, kafkaTopics);

        listener.listen(message);

        verify(kafkaTemplate).send("adaptor-input-topic", message);
    }

    @Test
    public void listen_shouldNotThrowWhenKafkaTemplateSendFails() {
        KafkaTemplate<String, GenericRecord> kafkaTemplate = mock(KafkaTemplate.class);
        KafkaTopics kafkaTopics = mock(KafkaTopics.class);
        GenericRecord message = mock(GenericRecord.class);

        when(kafkaTopics.getAdaptorInputTopic()).thenReturn("adaptor-input-topic");
        doThrow(new RuntimeException("Kafka unavailable"))
                .when(kafkaTemplate).send("adaptor-input-topic", message);

        KafkaSourceListener listener = new KafkaSourceListener(kafkaTemplate, kafkaTopics);

        listener.listen(message);

        verify(kafkaTemplate).send("adaptor-input-topic", message);
    }
}

