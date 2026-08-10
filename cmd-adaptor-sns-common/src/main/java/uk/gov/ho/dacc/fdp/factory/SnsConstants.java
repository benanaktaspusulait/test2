package uk.gov.ho.dacc.fdp.factory;

/**
 * Constants that are shared across the Command Adaptor modules
 */
public final class SnsConstants {
    public static final String ADDRESS_LINE_1 = "addressLine1";
    public static final String ADDRESS_LINE_ONE = "addressLine1";
    public static final String CARRIER_EORI = "parties.carrier.eori";
    public static final String COMMERCIAL_REFERENCE_NUMBER = "goodsItems.commercialReferenceNumber";
    public static final String COMMODITY_CODE = "goodsItems.commodityCode";
    public static final String CONTAINERS_CONTAINER_NUMBER = "goodsItems.containers.%s.containerNumber";
    public static final String DOCUMENT_TYPE = "documents.%s.documentType";
    public static final String DOCUMENT_VALUE = "documents.%s.documentValue";
    public static final String EORI_NUMBER = "eoriNumber";
    public static final String GOODS_DESCRIPTION_LANGUAGE = "goodsDescriptionLanguage";
    public static final String GROSS_MASS = "goods.grossMass";
    public static final int IDENTITY_CONTAINER_LENGTH = 10;
    public static final String LANGUAGE = "language";
    public static final String LOADING_LANGUAGE = "loadingLanguage";
    public static final CharSequence MAPPING_VERSION = "1.0";
    public static final String MARITIME_MODE_OF_TRANSFER = "1";
    public static final String NATIONALITY = "nationality";
    public static final String NUMBER_OF_ITEMS = "goods.numberOfItems";
    public static final String NUMBER_OF_PACKAGES = "goods.numberOfPackages";
    public static final String OFFICE_OF_FIRST_ENTRY_ARRIVAL = "itinerary.officeOfFirstEntry.expectedDateTimeOfArrival";
    public static final String OFFICE_OF_FIRST_ENTRY_REFERENCE = "itinerary.officeOfFirstEntry.reference";
    public static final String OFFICES_OF_SUBSEQUENT_ENTRY = "itinerary.officesOfSubsequentEntry";
    public static final String PACKAGES_KIND_OF_PACKAGES = "goodsItems.packages.%s.kindOfPackages";
    public static final String PACKAGES_MARKS = "goodsItems.packages.%s.marks";
    public static final String PACKAGES_MARKS_LANGUAGE = "goodsItems.packages.%s.marksLanguage";
    public static final String PACKAGES_NUMBER_OF_PACKAGES = "goodsItems.packages.%s.numberOfPackages";
    public static final String PACKAGES_NUMBER_OF_PIECES = "goodsItems.packages.%s.numberOfPieces";
    public static final String REGISTRATIONS = "itinerary.identityOfMeansOfCrossingBorder.identity";
    public static final String SEALS_CONTAINERS_CONTAINER_NUMBER = "goodsItems.%s.containers.%s.containerNumber";
    public static final String SEALS_VALUE = "goods.seal.%s.value";
    public static final String SPECIAL_MENTIONS = "goodsItems.specialMentions.%s";
    public static final String SPECIFIC_CIRCUMSTANCES_INDICATOR = "specificCircumstancesIndicator";
    public static final String TRANSPORT_CHARGES_METHOD_OF_PAYMENT = "goodsItems.transportChargesMethodOfPayment";
    public static final String UN_DANGEROUS_GOODS_CODE = "goodsItems.unDangerousGoodsCode";
    public static final String UNLOADING_LANGUAGE = "unloadingLanguage";

    SnsConstants() {
        // constructor is empty
    }
}
