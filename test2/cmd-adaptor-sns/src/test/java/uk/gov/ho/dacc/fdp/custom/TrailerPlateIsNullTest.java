package uk.gov.ho.dacc.fdp.custom;

import lombok.extern.slf4j.Slf4j;
import org.junit.Test;

import java.util.Collections;
import java.util.List;

import static org.junit.Assert.assertEquals;


@Slf4j
public class TrailerPlateIsNullTest {

    @Test
    // "desc": "split on \" \" OR \"#\" is < 1"
    public void trailerPlateIsNullTest() throws Exception {
        log.info("Trailer Plate is null happy path test");

        List<Object> inputList = Collections.singletonList("VehicleRefTrailerRef");

        assertEquals(true, new TrailerPlateIsNull().apply(inputList));
    }

    @Test
    public void trailerPlateIsNotNullTest() throws Exception {
        log.info("Trailer Plate is not null test");

        List<Object> inputList = Collections.singletonList("VehicleRef TrailerRef");

        assertEquals(false, new TrailerPlateIsNull().apply(inputList));
    }

}
