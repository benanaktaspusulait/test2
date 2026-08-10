package uk.gov.ho.dacc.fdp.config;

import io.confluent.kafka.schemaregistry.client.MockSchemaRegistryClient;
import io.confluent.kafka.serializers.AbstractKafkaSchemaSerDeConfig;
import io.confluent.kafka.streams.serdes.avro.SpecificAvroSerde;
import jakarta.annotation.PostConstruct;
import lombok.Getter;
import org.apache.kafka.common.serialization.Deserializer;
import org.apache.kafka.common.serialization.Serde;
import org.apache.kafka.common.serialization.Serdes;
import org.apache.kafka.common.serialization.Serializer;
import org.springframework.context.annotation.Profile;
import org.springframework.stereotype.Component;
import uk.gov.ho.dacc.bm.unmatched.delta.*;
import uk.gov.ho.dacc.bm.unmatched.wash.*;
import uk.gov.ho.dacc.fdp.cmd.CmdEnrichMatchingRecord;
import uk.gov.ho.dacc.fdp.cmd.event.CmdEventPoleRecord;
import uk.gov.ho.dacc.fdp.cmd.location.CmdLocationPoleRecord;
import uk.gov.ho.dacc.fdp.cmd.object.CmdObjectPoleRecord;
import uk.gov.ho.dacc.fdp.cmd.party.CmdPartyPoleRecord;
import uk.gov.ho.dacc.fdp.cmd.service.CmdServicePoleRecord;
import uk.gov.ho.dacc.fdp.evt.event.EvtEventPoleRecord;
import uk.gov.ho.dacc.fdp.evt.location.EvtLocationPoleRecord;
import uk.gov.ho.dacc.fdp.evt.object.EvtObjectPoleRecord;
import uk.gov.ho.dacc.fdp.evt.party.EvtPartyPoleRecord;
import uk.gov.ho.dacc.fdp.evt.service.EvtServicePoleRecord;
import uk.gov.ho.dacc.fdp.exception.GenericExceptionRecord;
import uk.gov.ho.dacc.fdp.fdp_commons.config.KafkaSerdeConfig;
import uk.gov.ho.dacc.fdp.fdp_commons.serde.JsonPOJODeserializer;
import uk.gov.ho.dacc.fdp.fdp_commons.serde.JsonPOJOSerializer;
import uk.gov.ho.dacc.pole.event.EventRecord;
import uk.gov.ho.dacc.pole.identity.PoleIdRecord;
import uk.gov.ho.dacc.pole.identity.PoleV1IdRecord;
import uk.gov.ho.dacc.pole.identity.PoleV2IdRecord;
import uk.gov.ho.dacc.pole.location.LocationStateRecord;
import uk.gov.ho.dacc.pole.object.ObjectStateRecord;
import uk.gov.ho.dacc.pole.party.PartyStateRecord;
import uk.gov.ho.dacc.pole.service.ServiceStateRecord;
import uk.gov.ho.dacc.rl.entry.EntryRecord;
import uk.gov.ho.dacc.rl.metadata.IdentityRecord;

import java.util.Collections;
import java.util.HashMap;
import java.util.Map;

@SuppressWarnings("squid:S2187")
@Getter
@Component
@Profile("test")
public class KafkaSerdeConfigTest implements KafkaSerdeConfig {

    private static final String MOCK_REGISTRY_URL = "mock://dummy/schema";
    //
    // Id
    //
    private Serde<PoleV2IdRecord> poleV2IdRecordSerdeKey;
    private Serde<PoleV1IdRecord> poleV1IdRecordSerdeKey;
    private Serde<Long> idLongSerdeKey;
    private Serde<PoleIdRecord> idRecordSerdeKey;
    private Serde<String> idStringSerdeKey;
    private Serde<String> stringSerdeRecord;
    private Serde<IdentityRecord> identityRecordSerdeKey;
    //
    //
    private Serde<PoleV2IdRecord> poleV2IdRecordSerdeValue;

    //
    //
    //
    private Serde<CmdEnrichMatchingRecord> cmdEnrichMatchingRecordSerde;

    //
    // Event
    //
    private Serde<CmdEventPoleRecord> cmdEventPoleRecordSerde;
    private Serde<EvtEventPoleRecord> evtEventPoleRecordSerde;
    private Serde<EventRecord> eventRecordSerde;
    //
    // Run Log
    //
    private Serde<EntryRecord> entryRecordSerde;

    //
    // Location
    //
    private Serde<CmdLocationPoleRecord> cmdLocationPoleRecordSerde;
    private Serde<EvtLocationPoleRecord> evtLocationPoleRecordSerde;
    private Serde<LocationStateRecord> locationStateRecordSerde;
    private Serde<AddressMessage> addressMessageSerde;
    private Serde<AddressWashMessage> addressWashMessageSerde;
    private Serde<ContactMessage> contactMessageSerde;
    private Serde<ContactWashMessage> contactWashMessageSerde;
    private Serde<VirtualMessage> virtualMessageSerde;
    private Serde<VirtualWashMessage> virtualWashMessageSerde;

    //
    // Object
    //
    private Serde<CmdObjectPoleRecord> cmdObjectPoleRecordSerde;
    private Serde<EvtObjectPoleRecord> evtObjectPoleRecordSerde;
    private Serde<ObjectStateRecord> objectStateRecordSerde;
    private Serde<ObjectMessage> objectMessageSerde;
    private Serde<ObjectWashMessage> objectWashMessageSerde;
    private Serde<TransportMessage> transportMessageSerde;
    private Serde<TransportWashMessage> transportWashMessageSerde;

    //
    // Party
    //
    private Serde<CmdPartyPoleRecord> cmdPartyPoleRecordSerde;
    private Serde<EvtPartyPoleRecord> evtPartyPoleRecordSerde;
    private Serde<PartyStateRecord> partyStateRecordSerde;

    //
    // Service
    //
    private Serde<CmdServicePoleRecord> cmdServicePoleRecordSerde;
    private Serde<EvtServicePoleRecord> evtServicePoleRecordSerde;
    private Serde<ServiceStateRecord> serviceStateRecordSerde;

    //
    // Misc
    //
    private Serde<GenericExceptionRecord> genericExceptionRecordSerde;

    // TODO
    @PostConstruct
    public void init() {
        Map<String, String> serdeConfig = Collections.singletonMap(AbstractKafkaSchemaSerDeConfig.SCHEMA_REGISTRY_URL_CONFIG,MOCK_REGISTRY_URL);
        MockSchemaRegistryClient client = new MockSchemaRegistryClient();

        poleV2IdRecordSerdeKey = new SpecificAvroSerde<>(client);
        poleV2IdRecordSerdeKey.configure(serdeConfig, true); // `true` for record keys

        identityRecordSerdeKey = new SpecificAvroSerde<>(client);
        identityRecordSerdeKey.configure(serdeConfig, true);

        entryRecordSerde = new SpecificAvroSerde<>(client);
        entryRecordSerde.configure(serdeConfig, true);

        cmdPartyPoleRecordSerde = new SpecificAvroSerde<>(client);
        cmdPartyPoleRecordSerde.configure(serdeConfig, false); // `false` for record values

        cmdObjectPoleRecordSerde = new SpecificAvroSerde<>(client);
        cmdObjectPoleRecordSerde.configure(serdeConfig, false); // `false` for record values

        cmdLocationPoleRecordSerde = new SpecificAvroSerde<>(client);
        cmdLocationPoleRecordSerde.configure(serdeConfig, false); // `false` for record values

        cmdEventPoleRecordSerde = new SpecificAvroSerde<>(client);
        cmdEventPoleRecordSerde.configure(serdeConfig, false); // `false` for record values

        cmdServicePoleRecordSerde = new SpecificAvroSerde<>(client);
        cmdServicePoleRecordSerde.configure(serdeConfig, false); // `false` for record values

        setupGenericExceptionSerde();
    }

    private void setupGenericExceptionSerde() {
        Map<String, Object> serdeProps = new HashMap<>();
        Serializer<GenericExceptionRecord> genericExceptionSerializer = new JsonPOJOSerializer<>();
        serdeProps.put("JsonPOJOClass", GenericExceptionRecord.class);
        genericExceptionSerializer.configure(serdeProps, false);
        Deserializer<GenericExceptionRecord> genericExceptionDeserializer = new JsonPOJODeserializer<>();
        serdeProps.put("JsonPOJOClass", GenericExceptionRecord.class);
        genericExceptionDeserializer.configure(serdeProps, false);
        genericExceptionRecordSerde = Serdes.serdeFrom(genericExceptionSerializer, genericExceptionDeserializer);
    }
}
