package uk.gov.ho.dacc.fdp.custom;

import lombok.extern.slf4j.Slf4j;
import org.junit.Test;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

import static org.junit.Assert.assertEquals;


@Slf4j
public class CountriesOfRoutingArrayTest {


    @Test
    public void CountriesOfRoutingArrayTestNotNullSingle() throws Exception {
        log.info("CountriesOfRoutingArrayTestNotNullSingle : happy path test");

        List<CharSequence> testVals = new ArrayList<CharSequence>();
        testVals.add("NL");

        List<Object> inputList = Collections.singletonList(testVals);
        assertEquals("NL", new CountriesOfRoutingArray().apply(inputList));
    }


    @Test
    public void CountriesOfRoutingArrayTestNotNull() throws Exception {
        log.info("CountriesOfRoutingArrayTestNotNull : happy path test");

        List<CharSequence> testVals = new ArrayList<CharSequence>();
        testVals.add("NL");
        testVals.add("GB");

        List<Object> inputList = Collections.singletonList(testVals);
        assertEquals("NL;GB", new CountriesOfRoutingArray().apply(inputList));
    }



    @Test
    public void CountriesOfRoutingArrayTestDefault() throws Exception {
        log.info("CountriesOfRoutingArrayTestDefault : default value test i.e. default value test i.e. empty [ ]  (defined in AVRO)");

        List<CharSequence> testVals = new ArrayList<CharSequence>();
        List<Object> inputList = Collections.singletonList(Collections.EMPTY_LIST);
        assertEquals(null, new CountriesOfRoutingArray().apply(inputList));
    }

}
