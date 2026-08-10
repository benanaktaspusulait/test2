package uk.gov.ho.dacc.fdp.config;

import org.apache.kafka.common.serialization.Serde;
import uk.gov.ho.dsa.cdl.hmrc.snsens.StreamIngestRecord;

public interface LocalKafkaSerdeConfig {
    Serde<String> getStringSerde();
    Serde<StreamIngestRecord> getCdlzRecordSerde();
}
