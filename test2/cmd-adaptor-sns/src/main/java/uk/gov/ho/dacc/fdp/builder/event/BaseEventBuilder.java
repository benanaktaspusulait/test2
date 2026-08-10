package uk.gov.ho.dacc.fdp.builder.event;

import io.micrometer.core.instrument.Metrics;
import io.micrometer.core.instrument.Timer;
import lombok.extern.slf4j.Slf4j;
import org.apache.kafka.streams.KeyValue;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.info.BuildProperties;
import org.springframework.stereotype.Component;
import uk.gov.ho.dacc.fdp.CmdAdaptorConstants;
import uk.gov.ho.dacc.fdp.builder.CommandBuilder;
import uk.gov.ho.dacc.fdp.cmd.event.CmdEventPoleRecord;
import uk.gov.ho.dacc.fdp.cmd.event.CmdType;
import uk.gov.ho.dacc.fdp.transform.TransformationException;
import uk.gov.ho.dacc.pole.event.EventRecord;
import uk.gov.ho.dacc.pole.identity.PoleV2IdRecord;

import static uk.gov.ho.dacc.fdp.CmdAdaptorConstants.ADAPTOR_NAME;
import static uk.gov.ho.dacc.fdp.builder.CommonBuilder.getComplianceRecord;

@Slf4j
@Component
public abstract class BaseEventBuilder extends CommandBuilder<CmdEventPoleRecord, EventRecord> {

    @Autowired
    BuildProperties buildProperties;

    @Override
    public <S> KeyValue<PoleV2IdRecord, CmdEventPoleRecord> buildCommand(final S streamIngestRecord) throws TransformationException, NoSuchMethodException, ClassNotFoundException {
        log.debug("buildCommand {}", this.getClass().getName());
        Timer.Sample sample = Timer.start();
        Timer timer = Metrics.timer(CmdAdaptorConstants.METRICS_PREFIX + getCommandBuilderNameForMetrics());

        EventRecord.Builder eventRecordBuilder =
                (EventRecord.Builder) getTransformer().transform(streamIngestRecord).getBuilder();

        eventRecordBuilder.getMetadata().setComplianceRecord(getComplianceRecord());
        EventRecord eventRecord = eventRecordBuilder.build();
        sample.stop(timer);

        return KeyValue.pair(
                eventRecord
                        .getMetadata()
                        .getIdentityRecord()
                        .getPoleId()
                        .getV2(),
                CmdEventPoleRecord.newBuilder()
                        .setCmdCreationTimestamp(commonBuilder.getNow())
                        .setCmdType(CmdType.MAP_EVENT_CMD)
                        .setAdaptorName(ADAPTOR_NAME)
                        .setAdaptorVersion(buildProperties.getVersion())
                        .setEventRecord(eventRecord)
                        .build());
    }
}
