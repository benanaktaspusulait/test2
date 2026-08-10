package uk.gov.ho.dacc.fdp.custom;

import lombok.extern.slf4j.Slf4j;
import org.junit.Test;
import uk.gov.ho.dsa.cdl.hmrc.snsens.DocumentRecord;

import java.util.ArrayList;
import java.util.List;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertNull;


@Slf4j
public class ShipmentReferenceTest {

    @Test
    public void shipmentReferenceNoDocumentsTest() throws Exception {
        log.info("Shipment Reference no documents test");

        List<DocumentRecord> documents = new ArrayList<>();

                List<Object> inputList = List.of(documents, "ABC");

        assertNull(new ShipmentReference().apply(inputList));
    }

    @Test
    public void shipmentReferenceFirstDocumentTest() throws Exception {
        log.info("Shipment Reference take first document test");

        List<DocumentRecord> documents = List.of(
                        DocumentRecord.newBuilder()
                                .setReference("YYY")
                                .setType("N999")
                                .build(),
                        DocumentRecord.newBuilder()
                                .setReference("ZZZ")
                                .setType("N777")
                                .build()
                );

        List<Object> inputList = List.of(documents, "ABC");

        assertEquals("YYY", new ShipmentReference().apply(inputList));
    }

    @Test
    public void shipmentReferenceSecondDocumentTest() throws Exception {
        log.info("Shipment Reference take second document test");

        List<DocumentRecord> documents = List.of(
                        DocumentRecord.newBuilder()
                                .setReference("YYY")
                                .setType("N704")
                                .build(),
                        DocumentRecord.newBuilder()
                                .setReference("ZZZ")
                                .setType("N999")
                                .build()
                );

        List<Object> inputList = List.of(documents, "ABC");

        assertEquals("ZZZ", new ShipmentReference().apply(inputList));
    }

    @Test
    public void shipmentReferenceOnlyDocumentTest() throws Exception {
        log.info("Shipment Reference take only document test");

        List<DocumentRecord> documents = List.of(
                        DocumentRecord.newBuilder()
                                .setReference("ZZZ")
                                .setType("N999")
                                .build()
                );

        List<Object> inputList = List.of(documents, "ABC");

        assertEquals("ZZZ", new ShipmentReference().apply(inputList));
    }

    @Test
    public void shipmentReferenceNotEnoughInputsTest() throws Exception {
        log.info("Shipment Reference wrong number of inputs test");

        List<Object> inputList = List.of("ABC");

        assertNull(new ShipmentReference().apply(inputList));
    }

    @Test
    public void shipmentReferenceNullInputTest() throws Exception {
        log.info("Shipment Reference null input test");

        assertNull(new ShipmentReference().apply(null));
    }

    @Test
    public void shipmentReferenceNotListTest() throws Exception {
        log.info("Shipment Reference first input not list test");

        List<Object> inputList = List.of("ABC", "DEF");

        assertNull(new ShipmentReference().apply(inputList));
    }
}
