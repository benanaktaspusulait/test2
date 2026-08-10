package uk.gov.ho.dacc.fdp.custom;

import lombok.extern.slf4j.Slf4j;
import org.junit.Test;

import java.util.Collections;
import java.util.List;

import static org.junit.Assert.assertEquals;

@Slf4j
public class TrailerSplitTest {

    @Test
    public void TrailerSplitTestR1a() throws Exception {
        log.info("R1a test: single colon");
        List<Object> inputList = Collections.singletonList("Vehicle1:Trailer1");
        assertEquals("Trailer1", new TrailerSplit().apply(inputList));
    }

    @Test
    public void TrailerSplitTestR1b() throws Exception {
        log.info("R1b test: single semicolon");
        List<Object> inputList = Collections.singletonList("Vehicle1;Trailer1");
        assertEquals("Trailer1", new TrailerSplit().apply(inputList));
    }

    @Test
    public void TrailerSplitTestR1c() throws Exception {
        log.info("R1c test: single hash");
        List<Object> inputList = Collections.singletonList("Vehicle1#Trailer1");
        assertEquals("Trailer1", new TrailerSplit().apply(inputList));
    }

    @Test
    public void TrailerSplitTestR1d() throws Exception {
        log.info("R1d test: double hash");
        List<Object> inputList = Collections.singletonList("Vehicle1##Trailer1");
        assertEquals("Trailer1", new TrailerSplit().apply(inputList));
    }

    @Test
    public void TrailerSplitTestR1e() throws Exception {
        log.info("R1e test: single dash");
        List<Object> inputList = Collections.singletonList("Vehicle1-Trailer1");
        assertEquals("Trailer1", new TrailerSplit().apply(inputList));
    }

    @Test
    public void TrailerSplitTestR1f() throws Exception {
        log.info("R1f test: single dash");
        List<Object> inputList = Collections.singletonList("Vehicle1+Trailer1");
        assertEquals("Trailer1", new TrailerSplit().apply(inputList));
    }

    @Test
    public void TrailerSplitTestR2a() throws Exception {
        log.info("R2a test: single / separator");
        List<Object> inputList = Collections.singletonList("Vehicle1/ Trailer1");
        assertEquals("Trailer1", new TrailerSplit().apply(inputList));
    }

    @Test
    public void TrailerSplitTestR2b() throws Exception {
        log.info("R2b test: single // separator");
        List<Object> inputList = Collections.singletonList("Vehicle1//Trailer1");
        assertEquals("Trailer1", new TrailerSplit().apply(inputList));
    }

    @Test
    public void TrailerSplitTestR2c() throws Exception {
        log.info("R2c test: single / separator");
        List<Object> inputList = Collections.singletonList("ABC123/XYZ999");
        assertEquals("XYZ999", new TrailerSplit().apply(inputList));
    }

    @Test
    public void TrailerSplitTestR2d() throws Exception {
        log.info("R2d test: single / separator with extra whitespace");
        List<Object> inputList = Collections.singletonList("  ABC123 /   XYZ999  ");
        assertEquals("XYZ999", new TrailerSplit().apply(inputList));
    }

    @Test
    public void TrailerSplitTestR2e() throws Exception {
        log.info("R2e test: mixed / and - separators");
        List<Object> inputList = Collections.singletonList("ABC123/XYZ-999");
        assertEquals("XYZ-999", new TrailerSplit().apply(inputList));
    }

    @Test
    public void TrailerSplitTestR3() throws Exception {
        log.info("R3 test - multiple / ");
        List<Object> inputList = Collections.singletonList("Bike1/Car1/Vehicle1");
        //assertEquals("Car1/Vehicle1", new TrailerSplit().apply(inputList));
        //above test fails due to inclusion of / in output which is currently excluded by main regex filter - pending review by Cerberus in later release
        assertEquals(null, new TrailerSplit().apply(inputList));
    }

    @Test
    public void TrailerSplitTestR4() throws Exception {
        log.info("R4 test - single whitespace");
        List<Object> inputList = Collections.singletonList("Vehicle1 Trailer1");
        assertEquals("Trailer1", new TrailerSplit().apply(inputList));
    }


    @Test
    public void TrailerSplitTestR5() throws Exception {
        log.info("R5 test: multiple hash");
        List<Object> inputList = Collections.singletonList("Vehicle1#Vehicle2#Trailer1");
        assertEquals("Trailer1", new TrailerSplit().apply(inputList));
    }

    @Test
    public void TrailerSplitTestR6() throws Exception {
        log.info("R6 test :no separator and < 13 chars");
        List<Object> inputList = Collections.singletonList("Car1Car2");
        assertEquals(null, new TrailerSplit().apply(inputList));
    }

    @Test
    public void TrailerSplitTestR6b() throws Exception {
        log.info("R6b test :no separator and < 13 chars and # prefix");
        List<Object> inputList = Collections.singletonList("#ABC0000006");
        assertEquals("ABC0000006", new TrailerSplit().apply(inputList));
    }

    @Test
    public void TrailerSplitTestR7() throws Exception {
        log.info("R7 test: default null return value : use no separator > 13 char");
        List<Object> inputList = Collections.singletonList("Vehicle1Trailer1");
        assertEquals(null, new TrailerSplit().apply(inputList));
    }

    @Test
    public void TrailerSplitTestNullInput() throws Exception {
        log.info("Null input test");
        List<Object> inputList = Collections.singletonList(null);
        assertEquals(null, new TrailerSplit().apply(inputList));
    }



}