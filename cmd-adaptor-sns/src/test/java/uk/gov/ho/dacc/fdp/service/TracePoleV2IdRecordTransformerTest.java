package uk.gov.ho.dacc.fdp.service;

import org.apache.kafka.streams.KeyValue;
import org.junit.Test;
import uk.gov.ho.dacc.fdp.cmd.event.CmdEventPoleRecord;
import uk.gov.ho.dacc.fdp.cmd.location.CmdLocationPoleRecord;
import uk.gov.ho.dacc.fdp.cmd.object.CmdObjectPoleRecord;
import uk.gov.ho.dacc.fdp.cmd.party.CmdPartyPoleRecord;
import uk.gov.ho.dacc.fdp.cmd.service.CmdServicePoleRecord;
import uk.gov.ho.dacc.fdp.tracing.TraceSpanCreator;
import uk.gov.ho.dacc.pole.event.EventRecord;
import uk.gov.ho.dacc.pole.identity.IdentityRecord;
import uk.gov.ho.dacc.pole.identity.PoleIdRecord;
import uk.gov.ho.dacc.pole.identity.PoleV2IdRecord;
import uk.gov.ho.dacc.pole.location.LocationRecord;
import uk.gov.ho.dacc.pole.metadata.MappingRecord;
import uk.gov.ho.dacc.pole.metadata.MetadataRecord;
import uk.gov.ho.dacc.pole.metadata.SourceAuditRecord;
import uk.gov.ho.dacc.pole.metadata.SourceRecord;
import uk.gov.ho.dacc.pole.object.ObjectRecord;
import uk.gov.ho.dacc.pole.party.PartyRecord;
import uk.gov.ho.dacc.pole.service.ServiceRecord;

import java.time.Instant;
import java.util.Map;

import static org.junit.Assert.assertNull;
import static org.junit.Assert.assertSame;
import static org.mockito.ArgumentMatchers.anyMap;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.never;
import static org.mockito.Mockito.verify;

public class TracePoleV2IdRecordTransformerTest {

    private static final String TRACE_ID = "trace-123";
    private static final String MAPPING_NAME = "sns-mapping";
    private static final String MAPPING_VERSION = "2.4.1";
    private static final String ADAPTOR_NAME = "cmd-adaptor-sns";
    private static final String ADAPTOR_VERSION = "9.9.9";

    @Test
    public void transform_shouldCreateSpanWithExpectedMetadataForPartyCommand() {
        assertSpanCreated(buildPartyCommand(), "MAP_PARTY_CMD", "SNSENS:P=123");
    }

    @Test
    public void transform_shouldCreateSpanWithExpectedMetadataForObjectCommand() {
        assertSpanCreated(buildObjectCommand(), "MAP_OBJECT_CMD", "SNSENS:P=123,O=123");
    }

    @Test
    public void transform_shouldCreateSpanWithExpectedMetadataForLocationCommand() {
        assertSpanCreated(buildLocationCommand(), "MAP_LOCATION_CMD", "SNSENS:P=123,L=123");
    }

    @Test
    public void transform_shouldCreateSpanWithExpectedMetadataForEventCommand() {
        assertSpanCreated(buildEventCommand(), "MAP_EVENT_CMD", "SNSENS:E=123");
    }

    @Test
    public void transform_shouldCreateSpanWithExpectedMetadataForServiceCommand() {
        assertSpanCreated(buildServiceCommand(), "MAP_SERVICE_CMD", "SNSENS:S=123");
    }

    @Test
    public void transform_shouldReturnNullAndNotCreateSpanWhenKeyIsNull() {
        TraceSpanCreator traceSpanCreator = mock(TraceSpanCreator.class);
        TracePoleV2IdRecordTransformer<Object> transformer = new TracePoleV2IdRecordTransformer<>(traceSpanCreator);

        KeyValue<PoleV2IdRecord, Object> result = transformer.transform(null, buildPartyCommand());

        assertNull(result);
        verify(traceSpanCreator, never()).createSpan(eq(MAPPING_NAME), anyMap());
    }

    private void assertSpanCreated(Object command, String expectedCmdType, String expectedPoleV2Id) {
        TraceSpanCreator traceSpanCreator = mock(TraceSpanCreator.class);
        TracePoleV2IdRecordTransformer<Object> transformer = new TracePoleV2IdRecordTransformer<>(traceSpanCreator);
        PoleV2IdRecord key = PoleV2IdRecord.newBuilder().setId(expectedPoleV2Id).build();

        KeyValue<PoleV2IdRecord, Object> result = transformer.transform(key, command);

        assertSame(key, result.key);
        assertSame(command, result.value);

        Map<String, String> expectedMetadata = Map.of(
                "fdpTraceId", TRACE_ID,
                "adaptorName", ADAPTOR_NAME,
                "adaptorVersion", ADAPTOR_VERSION,
                "cmdType", expectedCmdType,
                "mappingName", MAPPING_NAME,
                "mappingVersion", MAPPING_VERSION,
                "poleV2Id", expectedPoleV2Id);

        verify(traceSpanCreator).createSpan(MAPPING_NAME, expectedMetadata);
    }

    private CmdPartyPoleRecord buildPartyCommand() {
        PoleV2IdRecord poleV2IdRecord = PoleV2IdRecord.newBuilder().setId("SNSENS:P=123").build();

        PartyRecord partyRecord = PartyRecord.newBuilder()
                .setMetadata(createMetadataRecord(poleV2IdRecord))
                .setType("PERSON")
                .build();

        return CmdPartyPoleRecord.newBuilder()
                .setCmdCreationTimestamp(Instant.parse("2026-07-03T10:15:30Z"))
                .setCmdType(uk.gov.ho.dacc.fdp.cmd.party.CmdType.MAP_PARTY_CMD)
                .setAdaptorName(ADAPTOR_NAME)
                .setAdaptorVersion(ADAPTOR_VERSION)
                .setPartyRecord(partyRecord)
                .build();
    }

    private CmdObjectPoleRecord buildObjectCommand() {
        PoleV2IdRecord poleV2IdRecord = PoleV2IdRecord.newBuilder().setId("SNSENS:P=123,O=123").build();

        IdentityRecord identityRecord = IdentityRecord.newBuilder()
                .setPoleId(PoleIdRecord.newBuilder().setV2(poleV2IdRecord).build())
                .build();

        ObjectRecord objectRecord = ObjectRecord.newBuilder()
                .setMetadata(createMetadataRecord(poleV2IdRecord))
                .setParty(identityRecord)
                .build();

        return CmdObjectPoleRecord.newBuilder()
                .setCmdCreationTimestamp(Instant.parse("2026-07-03T10:15:30Z"))
                .setCmdType(uk.gov.ho.dacc.fdp.cmd.object.CmdType.MAP_OBJECT_CMD)
                .setAdaptorName(ADAPTOR_NAME)
                .setAdaptorVersion(ADAPTOR_VERSION)
                .setObjectRecord(objectRecord)
                .build();
    }

    private CmdLocationPoleRecord buildLocationCommand() {
        PoleV2IdRecord poleV2IdRecord = PoleV2IdRecord.newBuilder().setId("SNSENS:P=123,L=123").build();

        IdentityRecord identityRecord = IdentityRecord.newBuilder()
                .setPoleId(PoleIdRecord.newBuilder().setV2(poleV2IdRecord).build())
                .build();

        LocationRecord locationRecord = LocationRecord.newBuilder()
                .setMetadata(createMetadataRecord(poleV2IdRecord))
                .setParty(identityRecord)
                .build();

        return CmdLocationPoleRecord.newBuilder()
                .setCmdCreationTimestamp(Instant.parse("2026-07-03T10:15:30Z"))
                .setCmdType(uk.gov.ho.dacc.fdp.cmd.location.CmdType.MAP_LOCATION_CMD)
                .setAdaptorName(ADAPTOR_NAME)
                .setAdaptorVersion(ADAPTOR_VERSION)
                .setLocationRecord(locationRecord)
                .build();
    }

    private CmdEventPoleRecord buildEventCommand() {
        PoleV2IdRecord poleV2IdRecord = PoleV2IdRecord.newBuilder().setId("SNSENS:E=123").build();

        EventRecord eventRecord = EventRecord.newBuilder()
                .setMetadata(createMetadataRecord(poleV2IdRecord))
                .build();

        return CmdEventPoleRecord.newBuilder()
                .setCmdCreationTimestamp(Instant.parse("2026-07-03T10:15:30Z"))
                .setCmdType(uk.gov.ho.dacc.fdp.cmd.event.CmdType.MAP_EVENT_CMD)
                .setAdaptorName(ADAPTOR_NAME)
                .setAdaptorVersion(ADAPTOR_VERSION)
                .setEventRecord(eventRecord)
                .build();
    }

    private CmdServicePoleRecord buildServiceCommand() {
        PoleV2IdRecord poleV2IdRecord = PoleV2IdRecord.newBuilder().setId("SNSENS:S=123").build();

        ServiceRecord serviceRecord = ServiceRecord.newBuilder()
                .setMetadata(createMetadataRecord(poleV2IdRecord))
                .setType("CONSIGNMENT")
                .build();

        return CmdServicePoleRecord.newBuilder()
                .setCmdCreationTimestamp(Instant.parse("2026-07-03T10:15:30Z"))
                .setCmdType(uk.gov.ho.dacc.fdp.cmd.service.CmdType.MAP_SERVICE_CMD)
                .setAdaptorName(ADAPTOR_NAME)
                .setAdaptorVersion(ADAPTOR_VERSION)
                .setServiceRecord(serviceRecord)
                .build();
    }

    private MetadataRecord createMetadataRecord(PoleV2IdRecord poleV2IdRecord) {
        return MetadataRecord.newBuilder()
                .setIdentityRecord(IdentityRecord.newBuilder()
                        .setPoleId(PoleIdRecord.newBuilder().setV2(poleV2IdRecord).build())
                        .build())
                .setSourceRecord(SourceRecord.newBuilder()
                        .setName("SNSENS")
                        .setShortName("SNS")
                        .setLocation("UK")
                        .setId(TRACE_ID)
                        .setAudit(SourceAuditRecord.newBuilder()
                                .setCreatedBy("test")
                                .setCreatedTimestamp(Instant.parse("2026-07-03T10:15:30Z"))
                                .setUpdatedBy("test")
                                .setUpdatedTimestamp(Instant.parse("2026-07-03T10:15:30Z"))
                                .setDeletedBy(null)
                                .setDeletedTimestamp(null)
                                .build())
                        .build())
                .setMappingRecord(MappingRecord.newBuilder()
                        .setName(MAPPING_NAME)
                        .setVersion(MAPPING_VERSION)
                        .build())
                .build();
    }
}
