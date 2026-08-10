package uk.gov.ho.dacc.fdp.factory.cdlz;

import uk.gov.ho.dsa.cdl.hmrc.snsens.StreamIngestHeader;

import java.nio.ByteBuffer;
import java.time.Instant;

public class CdlzHeaderFactory {

    private CdlzHeaderFactory() {
        //empty
    }

    public static final String RECORD_STRING_TO_HASH = "RECORD_STRING_TO_HASH";
    public static final String CORRELATION_ID = "CORRELATION_ID";
    public static final String INGEST_DATE_TIME = "2021-03-17T14:39:39.945Z";
    public static final String DATA_FORMAT = "DATA_FORMAT";
    public static final String ENDPOINT = "ENDPOINT";
    public static final String INDICATOR = "INDICATOR";


    public static StreamIngestHeader buildCdlzHeader() {
        return buildCdlzHeader(
                RECORD_STRING_TO_HASH,
                CORRELATION_ID,
                INGEST_DATE_TIME,
                DATA_FORMAT,
                ENDPOINT,
                INDICATOR
        );
    }

    public static StreamIngestHeader buildCdlzHeader(final String recordStringToHash,
            final String correlationId,
            final String ingestDateTime,
            final String dataFormat,
            final String endpoint,
            final String indicator
            ) {

        return StreamIngestHeader.newBuilder()
                .setRecordHash(createRecordHash(recordStringToHash).toString())
                .setCorrelationId(correlationId)
                .setIngestDateTime(Instant.parse(ingestDateTime))
                .setDataFormat(dataFormat)
                .setEndpoint(endpoint)
                .setCarrierInteractiveIndicator(indicator)
                .build();
    }

    public static ByteBuffer createRecordHash(final String recordStringToHash) {
        final byte[] recordBytes = recordStringToHash.getBytes();
        return ByteBuffer.wrap(recordBytes);
    }
}
