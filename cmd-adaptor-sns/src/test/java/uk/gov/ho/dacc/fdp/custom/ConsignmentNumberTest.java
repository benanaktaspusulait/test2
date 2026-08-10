package uk.gov.ho.dacc.fdp.custom;

import org.junit.Test;
import uk.gov.ho.dsa.cdl.hmrc.snsens.DocumentRecord;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertNull;

public class ConsignmentNumberTest {

    private DocumentRecord doc(String type, String ref) {
        return DocumentRecord.newBuilder()
                .setType(type)
                .setReference(ref)
                .setLanguage("EN")
                .build();
    }

    @Test
    public void testItineraryCRNWhenMode11() {
        List<Object> input = Arrays.asList("11", "ITIN-CRN", "GOODS-CRN", List.of(doc("704", "REF1")));
        assertEquals("ITIN-CRN", new ConsignmentNumber().apply(input));
    }

    @Test
    public void testGoodsItemsCRNWhenMode11AndItineraryNull() {
        List<Object> input = Arrays.asList("11", null, "GOODS-CRN", List.of(doc("704", "REF1")));
        assertEquals("GOODS-CRN", new ConsignmentNumber().apply(input));
    }

    @Test
    public void testDocumentPriorityWhenMode11AndCRNsNull() {
        List<Object> input = Arrays.asList("11", null, null, List.of(
                doc("N704", "REF-N704"),
                doc("705", "REF-705"),
                doc("714", "REF-714")
        ));
        // 705 is higher priority than N704 and 714
        assertEquals("REF-705", new ConsignmentNumber().apply(input));
    }

    @Test
    public void testFirstDocumentReferenceWhenNoPriorityMatch() {
        List<Object> input = Arrays.asList("11", null, null, List.of(
                doc("X", "REF-X"),
                doc("Y", "REF-Y")
        ));
        assertEquals("REF-X", new ConsignmentNumber().apply(input));
    }

    @Test
    public void testGoodsItemsCRNWhenModeNot11() {
        List<Object> input = Arrays.asList("10", "ITIN-CRN", "GOODS-CRN", List.of(doc("704", "REF1")));
        assertEquals("GOODS-CRN", new ConsignmentNumber().apply(input));
    }

    @Test
    public void testItineraryCRNWhenModeNot11AndGoodsNull() {
        List<Object> input = Arrays.asList("10", "ITIN-CRN", null, List.of(doc("704", "REF1")));
        assertEquals("ITIN-CRN", new ConsignmentNumber().apply(input));
    }

    @Test
    public void testDocumentPriorityWhenModeNot11AndCRNsNull() {
        List<Object> input = Arrays.asList("10", null, null, List.of(
                doc("N705", "REF-N705"),
                doc("N704", "REF-N704")
        ));
        assertEquals("REF-N705", new ConsignmentNumber().apply(input));
    }

    @Test
    public void testNullDocumentRecords() {
        List<Object> input = Arrays.asList("11", null, null, null);
        assertNull(new ConsignmentNumber().apply(input));
    }

    @Test
    public void testEmptyDocumentRecords() {
        List<Object> input = Arrays.asList("11", null, null, new ArrayList<>());
        assertNull(new ConsignmentNumber().apply(input));
    }
}
