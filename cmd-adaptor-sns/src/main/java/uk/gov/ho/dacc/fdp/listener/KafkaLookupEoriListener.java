package uk.gov.ho.dacc.fdp.listener;

import lombok.extern.slf4j.Slf4j;
import lookup.LookupEoriValue;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.kafka.annotation.KafkaListener;
import org.springframework.kafka.core.KafkaTemplate;
import org.springframework.stereotype.Service;
import uk.gov.ho.dsa.cdl.hmrc.eori.CdlzLandingRecord;

@Slf4j
@Service
public class KafkaLookupEoriListener {

    @Autowired
    private KafkaTemplate<String, LookupEoriValue> kafkaTemplate;

    @Value("${app.lookup.eori.lookup-topic}")
    private String lookupTopic;

    @KafkaListener(topics = "${app.lookup.eori.cdlz-incoming}", groupId = "${app.lookup.eori.cdlz-application-id}")
    public void listen(CdlzLandingRecord cdlzLandingRecord) {
        try {
            cdlzLandingRecord.getBody().getEoriData().getEoris().getEori().stream()
                    .filter(eoriRecord -> !StringUtils.isEmpty(eoriRecord.getEoriNumber()))
                    .forEach( eoriRecord ->
                            kafkaTemplate.send(lookupTopic,
                                    // EORI number key
                                    String.valueOf(eoriRecord.getEoriNumber()),
                                    // Multiple EORI fields in AVRO object
                                    LookupEoriValue.newBuilder()
                                            .setSendingDateTime(cdlzLandingRecord.getBody().getEoriData().getSendingDateTime())
                                            .setExtractionType(cdlzLandingRecord.getBody().getEoriData().getExtractionType())
                                            .setTraderName(eoriRecord.getTraderName())
                                            .setStreetAndNumber(eoriRecord.getAddress().getStreetAndNumber())
                                            .setCity(eoriRecord.getAddress().getCity())
                                            .setPostcode(eoriRecord.getAddress().getPostcode())
                                            .setDateOfRegistration(eoriRecord.getDateOfRegistration())
                                            .setVatRegistrationNumber(String.join(",", eoriRecord.getVatRegistrationNumbers().getVatRegistrationNumber()))
                                            .setPrincipleEconomicActivity(eoriRecord.getPrincipalEconomicActivity())
                                            .build()
                            )
                    );
        } catch (Exception e) {
            log.error("Error processing message", e);
        }
    }
}
