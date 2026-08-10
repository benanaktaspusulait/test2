package uk.gov.ho.dacc.fdp.factory.cdlz;

import lombok.experimental.UtilityClass;

@UtilityClass
public final class CdlzConstants {
    // Metadata
    public static final String METADATA_IDENTITY_RECORD_POLE_ID_V2_ID_KEY = "metadata.identityRecord.poleId.v2.id";
    public static final String METADATA_IDENTITY_RECORD_POLE_ID_KEY = "metadata.identityRecord.poleId.id";
    public static final String METADATA_IDENTITY_RECORD_TYPE_KEY = "metadata.identityRecord.type";

    public static final String METADATA_SOURCE_RECORD_ID_KEY = "metadata.sourceRecord.id";
    public static final String METADATA_SOURCE_RECORD_SHORT_NAME_KEY = "metadata.sourceRecord.shortName";
    public static final String METADATA_SOURCE_RECORD_NAME_KEY = "metadata.sourceRecord.name";
    public static final String METADATA_SOURCE_RECORD_LOCATION_KEY = "metadata.sourceRecord.location";

    public static final String METADATA_SOURCE_RECORD_AUDIT_CREATED_BY_KEY = "metadata.sourceRecord.audit.createdBy";
    public static final String METADATA_SOURCE_RECORD_AUDIT_CREATED_TIMESTAMP_KEY = "metadata.sourceRecord.audit.createdTimestamp";
    public static final String METADATA_SOURCE_RECORD_AUDIT_UPDATED_BY_KEY = "metadata.sourceRecord.audit.updatedBy";
    public static final String METADATA_SOURCE_RECORD_AUDIT_UPDATED_TIMESTAMP_KEY = "metadata.sourceRecord.audit.updatedTimestamp";
    public static final String METADATA_SOURCE_RECORD_AUDIT_DELETED_BY_KEY = "metadata.sourceRecord.audit.deletedBy";
    public static final String METADATA_SOURCE_RECORD_AUDIT_DELETED_TIMESTAMP_KEY = "metadata.sourceRecord.audit.deletedTimestamp";

    public static final String METADATA_MAPPING_RECORD_NAME_KEY = "metadata.mappingRecord.name";
    public static final String METADATA_MAPPING_RECORD_VERSION_KEY = "metadata.mappingRecord.version";

    public static final String METADATA_COMPLIANCE_RECORD_VISIBILITY_KEY = "metadata.complianceRecord.visibility";
    public static final String METADATA_COMPLIANCE_RECORD_GSC_MARKER_KEY = "metadata.complianceRecord.gscMarker";
    public static final String METADATA_COMPLIANCE_RECORD_RETENTION_MARKER_DAYS_KEY = "metadata.complianceRecord.retentionMarkerDays";

    // Header
    public static final String CDLZ_HEADER_HASH_KEY = "header.recordHash";
    public static final String CDLZ_HEADER_DATA_FEED_ID_KEY = "header.cdlzHeaderDataFeedIdKey";
    public static final String CDLZ_HEADER_SOURCE_FILENAME_KEY = "header.sourceFilename";
    public static final String CDLZ_HEADER_SOURCE_ZIP_ARCHIVE_KEY = "header.sourceZipArchive";
    public static final String CDLZ_HEADER_INGEST_DATE_TIME_KEY = "header.ingestDateTime";
    public static final String CDLZ_HEADER_COLLECTION_DATE_KEY = "header.collectionDate";
    public static final String CDLZ_HEADER_COLLECT_DATA_FEED_TASK_ID_KEY = "header.collectDataFeedTaskId";
    public static final String CDLZ_HEADER_INGEST_DATA_FEED_TASK_ID_KEY = "header.ingestDataFeedTaskId";
    public static final String CDLZ_HEADER_DATA_FORMAT_KEY = "header.dataFormat";

    // Data
    public static final String FIELD_NAME_TODO_KEY = "body.field";


}
