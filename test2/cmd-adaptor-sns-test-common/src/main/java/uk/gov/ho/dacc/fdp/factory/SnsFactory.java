package uk.gov.ho.dacc.fdp.factory;

import lombok.extern.slf4j.Slf4j;
import uk.gov.ho.dsa.cdl.hmrc.snsens.*;

import java.time.Instant;

@Slf4j
public final class SnsFactory {

    private SnsFactory() {
        // empty
    }

    public static SnsEnsRecord getDefaultRecord() {
        Instant now = Instant.now();
        TraderRecord trader = TraderRecord.newBuilder()
                .setName("name")
                .setAddress(AddressRecord.newBuilder()
                        .setStreetAndNumber("street")
                        .setCity("city")
                        .setPostalCode("postcode")
                        .setCountryCode("country")
                        .build())
                .setLanguage(null)
                .setEori("eori")
                .build();
        return SnsEnsRecord.newBuilder()
                .setXCorrelationId("null")
                .setHeaderDate(now)
                .setMovementReferenceNumber("123")
                .setSubmissionId("sId")
                .setMetadata(MetadataRecord.newBuilder()
                        .setSenderEORI("eori")
                        .setSenderBranch("branch")
                        .setMessageType(MessageTypeCode.IE313)
                        .setMessageIdentification("mId")
                        .setPreparationDateTime(now)
                        .setReceivedDateTime(now)
                        .setAcceptedDateTime(now)
                        .setCorrelationId("cId")
                        .setCnitDispatchDateTime(now)
                        .build())
                .setDeclaration(DeclarationRecord.newBuilder()
                        .setLocalReferenceNumber("234")
                        .setPlace("place")
                        .setDateTime(now)
                        .setOfficeOfLodgement("o")
                        .build())
                .setAmendment(null)
                .setParties(PartiesRecord.newBuilder()
                        .setDeclarant(trader)
                        .setRepresentative(trader)
                        .setCarrier(trader)
                        .setConsignor(trader)
                        .setConsignee(trader)
                        .setNotifyParty(trader)
                        .build())
                .setGoods(GoodsRecord.newBuilder()
                        .setNumberOfItems(1)
                        .build())
                .setItinerary(ItineraryRecord.newBuilder()
                        .setModeOfTransportAtBorder("1")
                        .setOfficeOfFirstEntry(OfficeOfFirstEntryRecord.newBuilder()
                                .setReference("ref")
                                .setExpectedDateTimeOfArrival(now)
                                .build())
                        .build())
                .setSpecificCircumstancesIndicator(SpecificCircumstancesIndicatorCode.A)
                .build();
    }
}
