package uk.gov.ho.dacc.fdp.custom;

import lombok.extern.slf4j.Slf4j;
import org.junit.Test;

import java.util.Collections;
import java.util.List;

import static org.junit.Assert.assertEquals;


@Slf4j
public class TrailerPlateMappingTest {

    @Test
    public void trailerPlateMappingTest() throws Exception {
        log.info("Trailer Plate Mapping happy path test");

        List<Object> inputList = Collections.singletonList("This is a test");

        assertEquals("atest", new TrailerPlateMapping().apply(inputList));
    }
}
