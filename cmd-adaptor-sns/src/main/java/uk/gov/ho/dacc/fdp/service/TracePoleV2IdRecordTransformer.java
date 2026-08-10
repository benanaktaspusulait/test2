package uk.gov.ho.dacc.fdp.service;

import lombok.extern.slf4j.Slf4j;
import org.apache.kafka.streams.KeyValue;
import org.apache.kafka.streams.kstream.Transformer;
import org.apache.kafka.streams.processor.ProcessorContext;
import uk.gov.ho.dacc.fdp.cmd.event.CmdEventPoleRecord;
import uk.gov.ho.dacc.fdp.cmd.location.CmdLocationPoleRecord;
import uk.gov.ho.dacc.fdp.cmd.object.CmdObjectPoleRecord;
import uk.gov.ho.dacc.fdp.cmd.party.CmdPartyPoleRecord;
import uk.gov.ho.dacc.fdp.cmd.service.CmdServicePoleRecord;
import uk.gov.ho.dacc.fdp.tracing.TraceSpanCreator;
import uk.gov.ho.dacc.pole.identity.PoleV2IdRecord;
import uk.gov.ho.dacc.pole.metadata.MetadataRecord;

import java.util.Map;

@Slf4j
public class TracePoleV2IdRecordTransformer<T> implements Transformer<PoleV2IdRecord, T, KeyValue<PoleV2IdRecord, T>> {
    public static final String TRACE_ACTION = "create-poles-command";
    public static final String ADAPTOR_NAME = "adaptorName";
    public static final String ADAPTOR_VERSION = "adaptorVersion";
    public static final String CMD_TYPE = "cmdType";
    public static final String MAPPING_NAME = "mappingName";
    public static final String MAPPING_VERSION = "mappingVersion";
    public static final String POLE_V2_ID = "poleV2Id";
    private static final String FDP_TRACE_ID = "fdpTraceId";
    private ProcessorContext context;
    private TraceSpanCreator traceSpanCreator;

    public TracePoleV2IdRecordTransformer(TraceSpanCreator traceSpanCreator) {
        this.traceSpanCreator = traceSpanCreator;
    }

    @Override
    public void init(ProcessorContext context) {
        this.context = context;
    }

    @Override
    public KeyValue<PoleV2IdRecord, T> transform(PoleV2IdRecord key, T value) {
        if (key != null) {
            Map<String, String> commandMetadata = extractCommandMetadata(value);
            traceSpanCreator.createSpan(commandMetadata.get(MAPPING_NAME), commandMetadata);
            return KeyValue.pair(key, value);
        }
        return null;
    }

    private Map<String, String> extractCommandMetadata(T value) {
        Map<String, String> commandMetadata = Map.of();
        if (value instanceof CmdPartyPoleRecord cmdPartyPoleRecord) {
            commandMetadata = createCommandMetadata(
                    cmdPartyPoleRecord.getAdaptorName(),
                    cmdPartyPoleRecord.getAdaptorVersion(),
                    cmdPartyPoleRecord.getCmdType().name(),
                    cmdPartyPoleRecord.getPartyRecord().getMetadata());
        } else if (value instanceof CmdObjectPoleRecord cmdObjectPoleRecord) {
            commandMetadata = createCommandMetadata(
                    cmdObjectPoleRecord.getAdaptorName(),
                    cmdObjectPoleRecord.getAdaptorVersion(),
                    cmdObjectPoleRecord.getCmdType().name(),
                    cmdObjectPoleRecord.getObjectRecord().getMetadata());
        } else if (value instanceof CmdLocationPoleRecord cmdLocationPoleRecord) {
            commandMetadata = createCommandMetadata(
                    cmdLocationPoleRecord.getAdaptorName(),
                    cmdLocationPoleRecord.getAdaptorVersion(),
                    cmdLocationPoleRecord.getCmdType().name(),
                    cmdLocationPoleRecord.getLocationRecord().getMetadata());
        } else if (value instanceof CmdEventPoleRecord cmdEventPoleRecord) {
            commandMetadata = createCommandMetadata(
                    cmdEventPoleRecord.getAdaptorName(),
                    cmdEventPoleRecord.getAdaptorVersion(),
                    cmdEventPoleRecord.getCmdType().name(),
                    cmdEventPoleRecord.getEventRecord().getMetadata());
        } else if (value instanceof CmdServicePoleRecord cmdServicePoleRecord) {
            commandMetadata = createCommandMetadata(
                    cmdServicePoleRecord.getAdaptorName(),
                    cmdServicePoleRecord.getAdaptorVersion(),
                    cmdServicePoleRecord.getCmdType().name(),
                    cmdServicePoleRecord.getServiceRecord().getMetadata());
        }
        return commandMetadata;
    }

    private Map<String, String> createCommandMetadata(CharSequence adaptorName, CharSequence adaptorVersion,
                                                      CharSequence cmdType, MetadataRecord metadata) {
        return Map.of(
                FDP_TRACE_ID, String.valueOf(metadata.getSourceRecord().getId()),
                ADAPTOR_NAME, String.valueOf(adaptorName),
                ADAPTOR_VERSION, String.valueOf(adaptorVersion),
                CMD_TYPE, String.valueOf(cmdType),
                MAPPING_NAME, String.valueOf(metadata.getMappingRecord().getName()),
                MAPPING_VERSION, String.valueOf(metadata.getMappingRecord().getVersion()),
                POLE_V2_ID, String.valueOf(metadata.getIdentityRecord().getPoleId().getV2().getId()));
    }

    @Override
    public void close() {
        // no need to implement
    }
}
