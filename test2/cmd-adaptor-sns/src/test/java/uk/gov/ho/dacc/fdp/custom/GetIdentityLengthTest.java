package uk.gov.ho.dacc.fdp.custom;

import lombok.extern.slf4j.Slf4j;
import org.junit.Test;

import java.util.Collections;
import java.util.List;

import static org.junit.Assert.assertEquals;


@Slf4j
public class GetIdentityLengthTest {

    @Test
    public void getIdentityLengthTest() {
        log.info("Get Identity Length happy path test");

        List<Object> inputList = Collections.singletonList("hello");

        assertEquals("5", new GetIdentityLength().apply(inputList));
    }

    @Test
    public void getIdentityLengthNullTest() {
        log.info("Get Identity Length null test");

        List<Object> inputList = Collections.singletonList(null);

        assertEquals("0", new GetIdentityLength().apply(inputList));
    }

    @Test
    public void getIdentityLengthNullListTest() {
        log.info("Get Identity Length null list test");

        assertEquals("0", new GetIdentityLength().apply(null));
    }

    @Test
    public void getIdentityLengthEmptyListTest() {
        log.info("Get Identity Length empty list test");

        assertEquals("0", new GetIdentityLength().apply(Collections.emptyList()));
    }

    @Test
    public void getIdentityLengthEmptyStringTest() {
        log.info("Get Identity Length empty string test");

        assertEquals("0", new GetIdentityLength().apply(Collections.singletonList("")));
    }

    @Test
    public void getIdentityLengthNonStringValueTest() {
        log.info("Get Identity Length non-string value test");

        assertEquals("5", new GetIdentityLength().apply(Collections.singletonList(12345)));
    }
}
