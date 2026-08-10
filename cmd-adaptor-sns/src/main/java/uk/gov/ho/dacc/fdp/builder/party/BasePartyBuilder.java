package uk.gov.ho.dacc.fdp.builder.party;

import io.micrometer.core.instrument.Metrics;
import io.micrometer.core.instrument.Timer;
import lombok.extern.slf4j.Slf4j;
import org.apache.kafka.streams.KeyValue;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.info.BuildProperties;
import org.springframework.stereotype.Component;
import uk.gov.ho.dacc.fdp.CmdAdaptorConstants;
import uk.gov.ho.dacc.fdp.builder.CommandBuilder;
import uk.gov.ho.dacc.fdp.cmd.party.CmdPartyPoleRecord;
import uk.gov.ho.dacc.fdp.cmd.party.CmdType;
import uk.gov.ho.dacc.fdp.transform.TransformationException;
import uk.gov.ho.dacc.pole.identity.PoleV2IdRecord;
import uk.gov.ho.dacc.pole.party.PartyRecord;

import static uk.gov.ho.dacc.fdp.CmdAdaptorConstants.ADAPTOR_NAME;
import static uk.gov.ho.dacc.fdp.builder.CommonBuilder.getComplianceRecord;

@Slf4j
@Component
public abstract class BasePartyBuilder extends CommandBuilder<CmdPartyPoleRecord, PartyRecord> {

    @Autowired
    BuildProperties buildProperties;

    @Override
    public <S> KeyValue<PoleV2IdRecord, CmdPartyPoleRecord> buildCommand(final S streamIngestRecord) throws TransformationException, NoSuchMethodException, ClassNotFoundException {
        log.debug("buildCommand {}", this.getClass().getName());
        Timer.Sample sample = Timer.start();
        Timer timer = Metrics.timer(CmdAdaptorConstants.METRICS_PREFIX + getCommandBuilderNameForMetrics());

        PartyRecord.Builder partyRecordBuilder =
                (PartyRecord.Builder) getTransformer().transform(streamIngestRecord).getBuilder();

        partyRecordBuilder.getMetadata().setComplianceRecord(getComplianceRecord());
        PartyRecord partyRecord = partyRecordBuilder.build();
        sample.stop(timer);

        return KeyValue.pair(
                partyRecord
                        .getMetadata()
                        .getIdentityRecord()
                        .getPoleId()
                        .getV2(),
                CmdPartyPoleRecord.newBuilder()
                        .setCmdCreationTimestamp(commonBuilder.getNow())
                        .setCmdType(CmdType.MAP_PARTY_CMD)
                        .setAdaptorName(ADAPTOR_NAME)
                        .setAdaptorVersion(buildProperties.getVersion())
                        .setPartyRecord(partyRecord)
                        .build());
    }
}
