package uk.gov.ho.dacc.fdp.util;

import uk.gov.ho.dacc.pole.metadata.MetadataRecord;

import java.util.Map;

import static uk.gov.ho.dacc.fdp.factory.cdlz.CdlzConstants.METADATA_IDENTITY_RECORD_POLE_ID_V2_ID_KEY;

public class TestUtils {

    public static boolean matchExpectedPoleV2Id(Map<String, String> targetDataTableMap, MetadataRecord metadataRecord) {
        return targetDataTableMap.get(METADATA_IDENTITY_RECORD_POLE_ID_V2_ID_KEY).contentEquals(metadataRecord.getIdentityRecord().getPoleId().getV2().getId());
    }
}
