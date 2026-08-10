package uk.gov.ho.dacc.fdp.runlog;

import uk.gov.ho.dsa.cdl.hmrc.snsens.SnsEnsRecord;
import uk.gov.ho.dsa.cdl.hmrc.snsens.StreamIngestRecord;

import java.nio.charset.StandardCharsets;
import java.time.Instant;
import java.util.Base64;

public class SnsRunLogInput extends RunLogInput<StreamIngestRecord> {

    public SnsRunLogInput(StreamIngestRecord input) {
        super(input);
    }

    @Override
    public CharSequence determineLocation() {
        return getSourceLocation(input.getBody());
    }

    @Override
    public String calculateIdHash() {
        return String.format(HASH_FORMAT,
                Base64.getEncoder().encodeToString(input.getHeader().getRecordHash().toString().getBytes(StandardCharsets.UTF_8)));

    }

    @Override
    public Instant determineIngestTimestamp() {
        return input.getHeader().getIngestDateTime();
    }

    private String getSourceLocation(SnsEnsRecord body) {
        return body.getSubmissionId() + "-" + body.getMetadata().getMessageIdentification();
    }

}
