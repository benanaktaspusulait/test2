package uk.gov.ho.dacc.fdp.builder.event;

import org.apache.kafka.streams.KeyValue;
import org.junit.Test;
import org.springframework.boot.info.BuildProperties;
import org.springframework.test.util.ReflectionTestUtils;
import uk.gov.ho.dacc.fdp.avro.AvroMutator;
import uk.gov.ho.dacc.fdp.builder.CommonBuilder;
import uk.gov.ho.dacc.fdp.cmd.event.CmdEventPoleRecord;
import uk.gov.ho.dacc.fdp.cmd.event.CmdType;
import uk.gov.ho.dacc.fdp.transform.ITransform;
import uk.gov.ho.dacc.pole.event.EventRecord;
import uk.gov.ho.dacc.pole.identity.IdentityRecord;
import uk.gov.ho.dacc.pole.identity.PoleIdRecord;
import uk.gov.ho.dacc.pole.identity.PoleV2IdRecord;
import uk.gov.ho.dacc.pole.metadata.ComplianceRecord;
import uk.gov.ho.dacc.pole.metadata.MetadataRecord;

import java.time.Instant;
import java.util.Properties;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertNull;
import static uk.gov.ho.dacc.fdp.CmdAdaptorConstants.ADAPTOR_NAME;
import static uk.gov.ho.dacc.fdp.CmdAdaptorConstants.COMPLIANCE_GSC_MARKER;
import static uk.gov.ho.dacc.fdp.CmdAdaptorConstants.COMPLIANCE_RETENTION_MARKER_DAYS;
import static uk.gov.ho.dacc.fdp.CmdAdaptorConstants.COMPLIANCE_VISIBILITY;

public class BaseEventBuilderTest {

    @Test
    public void buildCommand_shouldBuildKeyAndCommandWithExpectedMetadata() throws Exception {
        Instant fixedNow = Instant.parse("2026-07-03T10:15:30Z");
        String adaptorVersion = "9.9.9";

        PoleV2IdRecord expectedPoleV2Id = PoleV2IdRecord.newBuilder().setId("SNSENS:E=123").build();
        EventRecord eventRecord = EventRecord.newBuilder()
                .setMetadata(MetadataRecord.newBuilder()
                        .setIdentityRecord(IdentityRecord.newBuilder()
                                .setPoleId(PoleIdRecord.newBuilder().setV2(expectedPoleV2Id).build())
                                .build())
                        .build())
                .build();

        TestBaseEventBuilder builder = new TestBaseEventBuilder(input -> new AvroMutator<>(eventRecord));
        ReflectionTestUtils.setField(builder, "commonBuilder", new FixedCommonBuilder(fixedNow));
        ReflectionTestUtils.setField(builder, "buildProperties", buildProperties(adaptorVersion));

        KeyValue<PoleV2IdRecord, CmdEventPoleRecord> result = builder.buildCommand(new Object());

        assertEquals(expectedPoleV2Id, result.key);
        assertEquals(CmdType.MAP_EVENT_CMD, result.value.getCmdType());
        assertEquals(fixedNow, result.value.getCmdCreationTimestamp());
        assertEquals(ADAPTOR_NAME, result.value.getAdaptorName().toString());
        assertEquals(adaptorVersion, result.value.getAdaptorVersion().toString());
        assertEquals(expectedPoleV2Id, result.value.getEventRecord().getMetadata().getIdentityRecord().getPoleId().getV2());

        ComplianceRecord compliance = result.value.getEventRecord().getMetadata().getComplianceRecord();
        assertEquals(COMPLIANCE_VISIBILITY, compliance.getVisibility().toString());
        assertEquals(COMPLIANCE_RETENTION_MARKER_DAYS, compliance.getRetentionMarkerDays());
        assertNull(COMPLIANCE_GSC_MARKER);
        assertNull(compliance.getGscMarker());
    }

    private static BuildProperties buildProperties(String version) {
        Properties properties = new Properties();
        properties.setProperty("version", version);
        return new BuildProperties(properties);
    }

    private static class FixedCommonBuilder extends CommonBuilder {
        private final Instant now;

        private FixedCommonBuilder(Instant now) {
            this.now = now;
        }

        @Override
        public Instant getNow() {
            return now;
        }
    }

    private static class TestBaseEventBuilder extends BaseEventBuilder {
        private final ITransform<Object, AvroMutator<EventRecord>> transformer;

        private TestBaseEventBuilder(ITransform<Object, AvroMutator<EventRecord>> transformer) {
            this.transformer = transformer;
        }

        @Override
        protected String getCommandBuilderNameForMetrics() {
            return "test_event_builder";
        }

        @Override
        @SuppressWarnings("unchecked")
        protected <S> ITransform<S, AvroMutator<EventRecord>> getTransformer() {
            return (ITransform<S, AvroMutator<EventRecord>>) transformer;
        }
    }
}

