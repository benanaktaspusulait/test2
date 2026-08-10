package uk.gov.ho.dacc.fdp.builder.location;

import io.micrometer.core.instrument.Metrics;
import io.micrometer.core.instrument.Timer;
import lombok.extern.slf4j.Slf4j;
import org.apache.kafka.streams.KeyValue;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.info.BuildProperties;
import org.springframework.stereotype.Component;
import uk.gov.ho.dacc.fdp.CmdAdaptorConstants;
import uk.gov.ho.dacc.fdp.builder.CommandBuilder;
import uk.gov.ho.dacc.fdp.cmd.location.CmdLocationPoleRecord;
import uk.gov.ho.dacc.fdp.cmd.location.CmdType;
import uk.gov.ho.dacc.fdp.transform.TransformationException;
import uk.gov.ho.dacc.pole.identity.PoleV2IdRecord;
import uk.gov.ho.dacc.pole.location.LocationRecord;

import static uk.gov.ho.dacc.fdp.CmdAdaptorConstants.ADAPTOR_NAME;
import static uk.gov.ho.dacc.fdp.builder.CommonBuilder.getComplianceRecord;

@Slf4j
@Component
public abstract class BaseLocationBuilder extends CommandBuilder<CmdLocationPoleRecord, LocationRecord> {

    @Autowired
    BuildProperties buildProperties;

    @Override
    public <S> KeyValue<PoleV2IdRecord, CmdLocationPoleRecord> buildCommand(final S streamIngestRecord) throws TransformationException, NoSuchMethodException, ClassNotFoundException {
        log.debug("buildCommand {}", this.getClass().getName());
        Timer.Sample sample = Timer.start();
        Timer timer = Metrics.timer(CmdAdaptorConstants.METRICS_PREFIX + getCommandBuilderNameForMetrics());

        LocationRecord.Builder locationRecordBuilder =
                (LocationRecord.Builder) getTransformer().transform(streamIngestRecord).getBuilder();

        locationRecordBuilder.getMetadata().setComplianceRecord(getComplianceRecord());
        LocationRecord locationRecord = locationRecordBuilder.build();
        sample.stop(timer);

        return KeyValue.pair(
                locationRecord
                        .getMetadata()
                        .getIdentityRecord()
                        .getPoleId()
                        .getV2(),
                CmdLocationPoleRecord.newBuilder()
                        .setCmdCreationTimestamp(commonBuilder.getNow())
                        .setCmdType(CmdType.MAP_LOCATION_CMD)
                        .setAdaptorName(ADAPTOR_NAME)
                        .setAdaptorVersion(buildProperties.getVersion())
                        .setLocationRecord(locationRecord)
                        .build());
    }
}
