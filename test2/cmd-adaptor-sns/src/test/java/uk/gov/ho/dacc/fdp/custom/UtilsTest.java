package uk.gov.ho.dacc.fdp.custom;

import lombok.extern.slf4j.Slf4j;
import org.junit.Test;
import uk.gov.ho.dacc.fdp.factory.Utils;

import java.util.ArrayList;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertNull;


@Slf4j
public class UtilsTest {

    @Test
    public void getVehiclePlateTest() {
        log.info("Get Vehicle Plate Happy Path Test");
        // edge case where vehicle plate is shorter than 5 characters. Trailer will be lost
        assertEquals("Thisisatest", Utils.getVehiclePlate("This isatest"));
    }

    @Test
    public void getVehiclePlateShortStringTest() {
        log.info("Get Vehicle Plate Short String Input Test");
        assertEquals("Short", Utils.getVehiclePlate("Short s"));
    }

    @Test
    public void getVehiclePlateAmpersandTest() {
        log.info("Get Vehicle Plate Happy Path With Ampersand Test");
        assertEquals("Thisisa", Utils.getVehiclePlate("Thisisa#test"));
    }

    @Test
    public void getVehiclePlateSpaceAndAmpersandTest() {
        log.info("Get Vehicle Plate Happy Path With Space And Ampersand Test");
        assertEquals("Thisisa", Utils.getVehiclePlate("This isa#test"));
    }

    @Test
    public void getVehiclePlateAmpersandAndSpaceTest() {
        log.info("Get Vehicle Plate Happy Path With Ampersand And Space Test");
        assertEquals("Thisis", Utils.getVehiclePlate("Thisis#a test"));
    }

    @Test
    public void getVehiclePlateLongStringNoSeparatorTest() {
        log.info("Get Vehicle Plate Happy Path With Long String Input No Separator Test");
        assertEquals("Thisisatest", Utils.getVehiclePlate("Thisisatest"));
    }

    @Test
    public void getVehiclePlateSpaceAtBeginningTest() {
        log.info("Get Vehicle Plate Happy Path With Space At Beginning Of String Test");
        assertEquals("Thisisatest", Utils.getVehiclePlate(" Thisisatest"));
    }

    @Test
    public void getTrailerPlateTest() {
        log.info("Get Trailer Plate No Trailer Test");
        // edge case where vehicle plate is shorter than 5 characters. Trailer will be lost
        assertNull(Utils.getTrailerPlate("This isatest"));
    }

    @Test
    public void getTrailerPlateShortStringTest() {
        log.info("Get Trailer Plate Short String Input Test");
        assertEquals("s", Utils.getTrailerPlate("Short s"));
    }

    @Test
    public void getTrailerPlateAmpersandTest() {
        log.info("Get Trailer Plate Happy Path With Ampersand Test");
        assertEquals("test", Utils.getTrailerPlate("Thisisa#test"));
    }

    @Test
    public void getTrailerPlateSpaceAndAmpersandTest() {
        log.info("Get Trailer Plate Happy Path With Space And Ampersand Test");
        assertEquals("test", Utils.getTrailerPlate("This isa#test"));
    }

    @Test
    public void getTrailerPlateAmpersandAndSpaceTest() {
        log.info("Get Trailer Plate Happy Path With Ampersand And Space Test, Words Combined");
        assertEquals("atest", Utils.getTrailerPlate("Thisis#a test"));
    }

    @Test
    public void getTrailerPlateLongStringNoSeparatorTest() {
        log.info("Get Trailer Plate Happy Path With Long String Input No Separator Test, No Trailer");
        assertNull(Utils.getTrailerPlate("Thisisatest"));
    }

    @Test
    public void getTrailerPlateSpaceAtBeginningTest() {
        log.info("Get Trailer Plate Happy Path With Space At Beginning Of String Test, No Trailer");
        assertNull(Utils.getTrailerPlate(" Thisisatest"));
    }

    @Test
    public void getTrailerPlatesTest() {
        log.info("Get Trailer Plates Happy Path Test");
        assertEquals("atest", Utils.getTrailerPlates("This is a test").get(0));
    }

    @Test
    public void getTrailerPlatesShortStringTest() {
        log.info("Get Trailer Plates Short String Input Test");
        assertEquals("s", Utils.getTrailerPlates("Short s").get(0));
    }

    @Test
    public void getTrailerPlatesAmpersandTest() {
        log.info("Get Trailer Plates Happy Path With Ampersand Test");
        assertEquals("test", Utils.getTrailerPlates("Thisisa#test").get(0));
    }

    @Test
    public void getTrailerPlatesLongStringNoSeparatorTest() {
        log.info("Get Trailer Plates Happy Path With Long String Input No Separator Test");
        assertEquals(new ArrayList<>(), Utils.getTrailerPlates("Thisisatest"));
    }

    @Test
    public void getTrailerPlatesSpaceAtBeginningTest() {
        log.info("Get Trailer Plates Happy Path With Space At Beginning Of String Test");
        assertEquals(new ArrayList<>(), Utils.getTrailerPlates(" Thisisatest"));
    }

    @Test
    public void plateWithSpaces() {
        log.info("Get Trailer Plates Happy Path With Short Strings Test");
        assertEquals("11AA11", Utils.getTrailerPlates("AA1111AA 11 AA 11").get(0));
    }

    @Test
    public void plateWithSpacesAndDashes() {
        log.info("Get Trailer Plates Happy Path With Short Strings Test");
        assertEquals("11AA11", Utils.getTrailerPlates("AA1111AA 11-AA 11").get(0));
    }

    @Test
    public void plateWithThreeElements() {
        log.info("Get Trailer Plates Happy Path With Short Strings Test");
        assertEquals("BBB222", Utils.getTrailerPlates("AAA111 BBB222 CCC333").get(0));
        assertEquals("CCC333", Utils.getTrailerPlates("AAA111 BBB222 CCC333").get(1));
    }

    @Test
    public void getTrailerPlatesSpaceAndAmpersandTest() {
        log.info("Get Trailer Plates Happy Path With Space And Ampersand Test");
        assertEquals("test", Utils.getTrailerPlates("This isa#test").get(0));
    }

    @Test
    public void getTrailerPlatesAmpersandAndSpaceTest() {
        log.info("Get Trailer Plates Happy Path With Ampersand And Space Test");
        assertEquals("atest", Utils.getTrailerPlates("Thisis#a test").get(0));
    }

    @Test
    public void semicolonUsedAsSeparatorTest() {
        log.info("Semicolon used as a separator Test");
        assertEquals("SIGT8822", Utils.getVehiclePlate("SIGT8822; SIJG489"));
        assertEquals("SIJG489", Utils.getTrailerPlates("SIGT8822; SIJG489").get(0));
    }

    @Test
    public void colonUsedAsSeparatorTest() {
        log.info("Colon used as a separator Test");
        assertEquals("DS64481", Utils.getVehiclePlate("DS64481: SIGT526"));
        assertEquals("SIGT526", Utils.getTrailerPlates("DS64481: SIGT526").get(0));
    }

    @Test
    public void backslashUsedAsSeparatorTest() {
        log.info("Backslash used as a separator Test");
        assertEquals("LH7728B", Utils.getVehiclePlate("LH7728B/25072021"));
        assertEquals("25072021", Utils.getTrailerPlates("LH7728B/25072021").get(0));
    }
}
