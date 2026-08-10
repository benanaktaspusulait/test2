package uk.gov.ho.dacc.fdp.builder.object;

import io.micrometer.core.instrument.Metrics;
import io.micrometer.core.instrument.Timer;
import lombok.extern.slf4j.Slf4j;
import org.apache.kafka.streams.KeyValue;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.info.BuildProperties;
import org.springframework.stereotype.Component;
import uk.gov.ho.dacc.fdp.CmdAdaptorConstants;
import uk.gov.ho.dacc.fdp.builder.CommandBuilder;
import uk.gov.ho.dacc.fdp.cmd.object.CmdObjectPoleRecord;
import uk.gov.ho.dacc.fdp.cmd.object.CmdType;
import uk.gov.ho.dacc.fdp.transform.TransformationException;
import uk.gov.ho.dacc.pole.identity.PoleV2IdRecord;
import uk.gov.ho.dacc.pole.object.ObjectRecord;

import static uk.gov.ho.dacc.fdp.CmdAdaptorConstants.ADAPTOR_NAME;
import static uk.gov.ho.dacc.fdp.builder.CommonBuilder.getComplianceRecord;

@Slf4j
@Component
public abstract class BaseObjectBuilder extends CommandBuilder<CmdObjectPoleRecord, ObjectRecord> {

    @Autowired
    BuildProperties buildProperties;

    @Override
    public <S> KeyValue<PoleV2IdRecord, CmdObjectPoleRecord> buildCommand(final S streamIngestRecord) throws TransformationException, NoSuchMethodException, ClassNotFoundException {
        log.debug("buildCommand {}", this.getClass().getName());
        Timer.Sample sample = Timer.start();
        Timer timer = Metrics.timer(CmdAdaptorConstants.METRICS_PREFIX + getCommandBuilderNameForMetrics());

        ObjectRecord.Builder objectRecordBuilder =
                (ObjectRecord.Builder) getTransformer().transform(streamIngestRecord).getBuilder();

        objectRecordBuilder.getMetadata().setComplianceRecord(getComplianceRecord());
        ObjectRecord objectRecord = objectRecordBuilder.build();
        sample.stop(timer);

        return KeyValue.pair(
                objectRecord
                        .getMetadata()
                        .getIdentityRecord()
                        .getPoleId()
                        .getV2(),
                CmdObjectPoleRecord.newBuilder()
                        .setCmdCreationTimestamp(commonBuilder.getNow())
                        .setCmdType(CmdType.MAP_OBJECT_CMD)
                        .setAdaptorName(ADAPTOR_NAME)
                        .setAdaptorVersion(buildProperties.getVersion())
                        .setObjectRecord(objectRecord)
                        .build());
    }
}
