package uk.gov.ho.dacc.fdp.custom;

import lombok.extern.slf4j.Slf4j;
import org.junit.Test;

import java.util.Collections;
import java.util.List;

import static org.junit.Assert.assertEquals;

@Slf4j
public class VehicleSplitTest {



    @Test
    public void VehicleSplitTestR1a() throws Exception {
        log.info("R1a test: single colon");
        List<Object> inputList = Collections.singletonList("Vehicle1:Trailer1");
        assertEquals("Vehicle1", new VehicleSplit().apply(inputList));
    }

    @Test
    public void VehicleSplitTestR1b() throws Exception {
        log.info("R1b test: single semicolon");
        List<Object> inputList = Collections.singletonList("Vehicle1;Trailer1");
        assertEquals("Vehicle1", new VehicleSplit().apply(inputList));
    }

    @Test
    public void VehicleSplitTestR1c() throws Exception {
        log.info("R1c test: single hash");
        List<Object> inputList = Collections.singletonList("Vehicle1#Trailer1");
        assertEquals("Vehicle1", new VehicleSplit().apply(inputList));
    }

    @Test
    public void VehicleSplitTestR1d() throws Exception {
        log.info("R1d test: double hash");
        List<Object> inputList = Collections.singletonList("Vehicle1##Trailer1");
        assertEquals("Vehicle1", new VehicleSplit().apply(inputList));
    }

    @Test
    public void VehicleSplitTestR1e() throws Exception {
        log.info("R1e test: single dash");
        List<Object> inputList = Collections.singletonList("Vehicle1-Trailer1");
        assertEquals("Vehicle1", new VehicleSplit().apply(inputList));
    }

    @Test
    public void VehicleSplitTestR1f() throws Exception {
        log.info("R1f test: single plus");
        List<Object> inputList = Collections.singletonList("Vehicle1+Trailer1");
        assertEquals("Vehicle1", new VehicleSplit().apply(inputList));
    }

    @Test
    public void VehicleSplitTestR2a() throws Exception {
        log.info("R2a test: single / separator");
        List<Object> inputList = Collections.singletonList("Vehicle1/ Trailer1");
        assertEquals("Vehicle1", new VehicleSplit().apply(inputList));
    }

    @Test
    public void VehicleSplitTestR2b() throws Exception {
        log.info("R2b test: single // separator");
        List<Object> inputList = Collections.singletonList("Vehicle1//Trailer1");
        assertEquals("Vehicle1", new VehicleSplit().apply(inputList));
    }

    @Test
    public void VehicleSplitTestR2c() throws Exception {
        log.info("R2c test: single / separator");
        List<Object> inputList = Collections.singletonList("ABC123/XYZ999");
        assertEquals("ABC123", new VehicleSplit().apply(inputList));
    }

    @Test
    public void VehicleSplitTestR2d() throws Exception {
        log.info("R2d test: single / separator with extra whitespace");
        List<Object> inputList = Collections.singletonList("  ABC123 /   XYZ999  ");
        assertEquals("ABC123", new VehicleSplit().apply(inputList));
    }

    @Test
    public void VehicleSplitTestR2e() throws Exception {
        log.info("R2e test: mixed / and - separators");
        List<Object> inputList = Collections.singletonList("ABC123/XYZ-999");
        assertEquals("ABC123", new VehicleSplit().apply(inputList));
    }


    @Test
    public void VehicleSplitTestR3() throws Exception {
        log.info("R3 test - multiple / ");
        List<Object> inputList = Collections.singletonList("Bike1/Car1/Vehicle1");
        assertEquals("Bike1", new VehicleSplit().apply(inputList));
    }

    @Test
    public void VehicleSplitTestR4() throws Exception {
        log.info("R4 test - single whitespace");
        List<Object> inputList = Collections.singletonList("Vehicle1 Trailer1");
        assertEquals("Vehicle1", new VehicleSplit().apply(inputList));
    }


    @Test
    public void VehicleSplitTestR5() throws Exception {
        log.info("R5 test: multiple hash");
        List<Object> inputList = Collections.singletonList("Vehicle1#Vehicle2#Trailer1");
        assertEquals("Vehicle2", new VehicleSplit().apply(inputList));
    }

    @Test
    public void VehicleSplitTestR6() throws Exception {
        log.info("R6 test :no separator < 13 char");
        List<Object> inputList = Collections.singletonList("Vehicle1");
        assertEquals("Vehicle1", new VehicleSplit().apply(inputList));
    }

    @Test
    public void VehicleSplitTestR7() throws Exception {
        log.info("R7 test: default null return value if no separator and > 13 char");
        List<Object> inputList = Collections.singletonList("Vehicle1Trailer1");
        assertEquals(null, new VehicleSplit().apply(inputList));
    }

    @Test
    public void VehicleSplitTestNullInput() throws Exception {
        log.info("Null input test");
        List<Object> inputList = Collections.singletonList(null);
        assertEquals(null, new VehicleSplit().apply(inputList));
    }

}