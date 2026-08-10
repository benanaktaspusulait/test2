package uk.gov.ho.dacc.fdp;

import lombok.experimental.UtilityClass;

@UtilityClass
public class CmdAdaptorConstants {

    public static final String ADAPTOR_NAME = "Sns Command Adaptor";
    public static final String ADAPTOR_VERSION = "1.0.0";
    public static final String ADAPTOR_CODE = "SNSENS";
    public static final String ADAPTOR_SHORT_NAME = "SNS";

    public static final String METRICS_PREFIX = "fdp_cmd_sns_";
    public static final String METRICS_FROM_INPUT = "from_input";
    public static final String METRICS_SUFFIX_TO_EVENT = "to_event_cmd";
    public static final String METRICS_SUFFIX_TO_PARTY = "to_party_cmd";
    public static final String METRICS_SUFFIX_TO_LOCATION = "to_location_cmd";
    public static final String METRICS_SUFFIX_TO_SERVICE = "to_service_cmd";
    public static final String METRICS_SUFFIX_TO_OBJECT = "to_object_cmd";
    public static final String METRICS_SUFFIX_TO_RUNLOG = "to_runlog_cmd";

    // Compliance Record
    public static final String COMPLIANCE_VISIBILITY = "UNKNOWN";
    public static final String COMPLIANCE_GSC_MARKER = null;
    public static final int COMPLIANCE_RETENTION_MARKER_DAYS = -1;
}
