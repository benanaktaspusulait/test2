package uk.gov.ho.dacc.fdp.custom;

import lombok.extern.slf4j.Slf4j;
import org.junit.Test;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

import static org.junit.Assert.assertEquals;


@Slf4j
public class OfficeOfSubsequentEntryArrayTest {

    @Test
    public void OfficeOfSubsequentEntryArrayTestNotNull() throws Exception {
        log.info("OfficeOfSubsequentEntryArrayTestNotNull : happy path test");

        List<CharSequence> testVals = new ArrayList<CharSequence>();
        testVals.add("GB000101");
        testVals.add("GB000040");

        List<Object> inputList = Collections.singletonList(testVals);
        assertEquals("GB000101;GB000040", new OfficeOfSubsequentEntryArray().apply(inputList));
    }

    @Test
    public void OfficeOfSubsequentEntryArrayTestDefault() throws Exception {
        log.info("OfficeOfSubsequentEntryArrayTestDefault : default value test i.e. empty [ ] (defined in AVRO)");

        List<CharSequence> testVals = new ArrayList<CharSequence>();
        List<Object> inputList = Collections.singletonList(testVals);
        assertEquals(null, new OfficeOfSubsequentEntryArray().apply(inputList));
    }

}
