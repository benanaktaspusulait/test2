package uk.gov.ho.dacc.fdp.custom;

import lombok.extern.slf4j.Slf4j;
import org.junit.Test;

import java.util.Collections;
import java.util.List;

import static org.junit.Assert.assertEquals;


@Slf4j
public class VehiclePlateMappingTest {

    @Test
    public void vehiclePlateMappingTest() throws Exception {
        log.info("Vehicle Plate Mapping happy path test");

        List<Object> inputList = Collections.singletonList("This isatest");

        assertEquals("Thisisatest", new VehiclePlateMapping().apply(inputList));
    }
}
