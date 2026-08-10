package uk.gov.ho.dacc.fdp.custom;

import lombok.extern.slf4j.Slf4j;
import org.junit.Test;
import uk.gov.ho.dsa.cdl.hmrc.snsens.DocumentRecord;

import java.util.ArrayList;
import java.util.List;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertNull;


@Slf4j
public class ParentShipmentReferenceTest {

    @Test
    public void parentShipmentReferenceNoDocumentsTest() throws Exception {
        log.info("Parent Shipment Reference use movement reference test");

        List<DocumentRecord> documents = new ArrayList<>();

                List<Object> inputList = List.of(documents, "ABC");

        assertEquals("ABC", new ParentShipmentReference().apply(inputList));
    }

    @Test
    public void parentShipmentReferenceFirstDocumentTest() throws Exception {
        log.info("Parent Shipment Reference take first document test");

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

        assertEquals("YYY", new ParentShipmentReference().apply(inputList));
    }

    @Test
    public void parentShipmentReferenceSecondDocumentTest() throws Exception {
        log.info("Parent Shipment Reference take second document test");

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

        assertEquals("ZZZ", new ParentShipmentReference().apply(inputList));
    }

    @Test
    public void parentShipmentReferenceOnlyDocumentTest() throws Exception {
        log.info("Parent Shipment Reference take only document test");

        List<DocumentRecord> documents = List.of(
                        DocumentRecord.newBuilder()
                                .setReference("ZZZ")
                                .setType("N999")
                                .build()
                );

        List<Object> inputList = List.of(documents, "ABC");

        assertEquals("ZZZ", new ParentShipmentReference().apply(inputList));
    }

    @Test
    public void parentShipmentReferenceNotEnoughInputsTest() throws Exception {
        log.info("Parent Shipment Reference wrong number of inputs test");

        List<Object> inputList = List.of("ABC");

        assertNull(new ParentShipmentReference().apply(inputList));
    }

    @Test
    public void parentShipmentReferenceNullInputTest() throws Exception {
        log.info("Parent Shipment Reference null input test");

        assertNull(new ParentShipmentReference().apply(null));
    }

    @Test
    public void parentShipmentReferenceNotListTest() throws Exception {
        log.info("Parent Shipment Reference first input not list test");

        List<Object> inputList = List.of("ABC", "DEF");

        assertNull(new ParentShipmentReference().apply(inputList));
    }
}
