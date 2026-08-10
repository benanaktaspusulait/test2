package uk.gov.ho.dacc.fdp.builder.service;

import io.micrometer.core.instrument.Metrics;
import io.micrometer.core.instrument.Timer;
import lombok.extern.slf4j.Slf4j;
import org.apache.kafka.streams.KeyValue;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.info.BuildProperties;
import org.springframework.stereotype.Component;
import uk.gov.ho.dacc.fdp.CmdAdaptorConstants;
import uk.gov.ho.dacc.fdp.builder.CommandBuilder;
import uk.gov.ho.dacc.fdp.cmd.service.CmdServicePoleRecord;
import uk.gov.ho.dacc.fdp.cmd.service.CmdType;
import uk.gov.ho.dacc.fdp.transform.TransformationException;
import uk.gov.ho.dacc.pole.identity.PoleV2IdRecord;
import uk.gov.ho.dacc.pole.service.ServiceRecord;

import static uk.gov.ho.dacc.fdp.CmdAdaptorConstants.ADAPTOR_NAME;
import static uk.gov.ho.dacc.fdp.builder.CommonBuilder.getComplianceRecord;

@Slf4j
@Component
public abstract class BaseServiceBuilder extends CommandBuilder<CmdServicePoleRecord, ServiceRecord> {

    @Autowired
    BuildProperties buildProperties;

    @Override
    public <S> KeyValue<PoleV2IdRecord, CmdServicePoleRecord> buildCommand(final S streamIngestRecord) throws TransformationException, NoSuchMethodException, ClassNotFoundException {
        log.debug("buildCommand {}", this.getClass().getName());
        Timer.Sample sample = Timer.start();
        Timer timer = Metrics.timer(CmdAdaptorConstants.METRICS_PREFIX + getCommandBuilderNameForMetrics());

        ServiceRecord.Builder serviceRecordBuilder =
                (ServiceRecord.Builder) getTransformer().transform(streamIngestRecord).getBuilder();

        serviceRecordBuilder.getMetadata().setComplianceRecord(getComplianceRecord());
        ServiceRecord serviceRecord = serviceRecordBuilder.build();
        sample.stop(timer);

        return KeyValue.pair(
                serviceRecord
                        .getMetadata()
                        .getIdentityRecord()
                        .getPoleId()
                        .getV2(),
                CmdServicePoleRecord.newBuilder()
                        .setCmdCreationTimestamp(commonBuilder.getNow())
                        .setCmdType(CmdType.MAP_SERVICE_CMD)
                        .setAdaptorName(ADAPTOR_NAME)
                        .setAdaptorVersion(buildProperties.getVersion())
                        .setServiceRecord(serviceRecord)
                        .build());
    }
}
