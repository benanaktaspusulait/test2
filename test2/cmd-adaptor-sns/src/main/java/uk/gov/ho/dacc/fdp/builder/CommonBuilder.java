package uk.gov.ho.dacc.fdp.builder;

import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Component;
import uk.gov.ho.dacc.pole.metadata.ComplianceRecord;

import java.time.Instant;
import java.time.LocalDateTime;
import java.time.ZoneOffset;

import static uk.gov.ho.dacc.fdp.CmdAdaptorConstants.*;

@Slf4j
@Component
public class CommonBuilder {

    public static ComplianceRecord getComplianceRecord() {
        return ComplianceRecord.newBuilder()
                .setVisibility(COMPLIANCE_VISIBILITY)
                .setGscMarker(COMPLIANCE_GSC_MARKER)
                .setRetentionMarkerDays(COMPLIANCE_RETENTION_MARKER_DAYS)
                .build();
    }

    public Instant getNow() {
        return LocalDateTime.now().toInstant(ZoneOffset.UTC);
    }
}
