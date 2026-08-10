package uk.gov.ho.dacc.fdp.runlog;

import org.junit.Test;
import uk.gov.ho.dacc.fdp.factory.SnsFactory;
import uk.gov.ho.dsa.cdl.hmrc.snsens.MetadataRecord;
import uk.gov.ho.dsa.cdl.hmrc.snsens.SnsEnsRecord;
import uk.gov.ho.dsa.cdl.hmrc.snsens.StreamIngestHeader;
import uk.gov.ho.dsa.cdl.hmrc.snsens.StreamIngestRecord;

import java.nio.charset.StandardCharsets;
import java.time.Instant;
import java.util.Base64;

import static org.junit.Assert.assertEquals;

public class SnsRunLogInputTest {

    @Test
    public void determineLocation_shouldReturnSubmissionIdAndMessageIdentification() {
        StreamIngestRecord input = createInput("hash-1", Instant.parse("2026-07-03T11:15:30Z"), "submission-123", "message-456");

        SnsRunLogInput runLogInput = new SnsRunLogInput(input);

        assertEquals("submission-123-message-456", runLogInput.determineLocation().toString());
    }

    @Test
    public void calculateIdHash_shouldEncodeRecordHashAndApplyRunLogFormat() {
        String recordHash = "abc-123";
        StreamIngestRecord input = createInput(recordHash, Instant.parse("2026-07-03T11:15:30Z"), "submission-123", "message-456");

        SnsRunLogInput runLogInput = new SnsRunLogInput(input);

        String expectedHash = String.format("[%s][CONTEXT]",
                Base64.getEncoder().encodeToString(recordHash.getBytes(StandardCharsets.UTF_8)));

        assertEquals(expectedHash, runLogInput.calculateIdHash());
    }

    @Test
    public void determineIngestTimestamp_shouldReturnHeaderIngestDateTime() {
        Instant expectedIngestTimestamp = Instant.parse("2026-07-03T11:15:30Z");
        StreamIngestRecord input = createInput("hash-1", expectedIngestTimestamp, "submission-123", "message-456");

        SnsRunLogInput runLogInput = new SnsRunLogInput(input);

        assertEquals(expectedIngestTimestamp, runLogInput.determineIngestTimestamp());
    }

    private StreamIngestRecord createInput(String recordHash, Instant ingestDateTime,
                                           String submissionId, String messageIdentification) {
        StreamIngestHeader header = StreamIngestHeader.newBuilder()
                .setRecordHash(recordHash)
                .setCorrelationId("correlation-id")
                .setRecordCreationTime(Instant.parse("2026-07-03T10:00:00Z"))
                .setIngestDateTime(ingestDateTime)
                .setDataFormat("snsens")
                .setEndpoint("sns")
                .setCarrierInteractiveIndicator("N")
                .build();

        SnsEnsRecord body = SnsFactory.getDefaultRecord();
        body.setSubmissionId(submissionId);

        MetadataRecord metadata = MetadataRecord.newBuilder(body.getMetadata())
                .setMessageIdentification(messageIdentification)
                .build();
        body.setMetadata(metadata);

        return StreamIngestRecord.newBuilder()
                .setHeader(header)
                .setBody(body)
                .build();
    }
}

