package uk.gov.ho.dacc.fdp.custom;

import lombok.extern.slf4j.Slf4j;
import org.junit.Test;

import java.util.ArrayList;
import java.util.List;

import static org.junit.Assert.assertNotNull;
import static org.junit.Assert.assertNull;


@Slf4j
public class Base64EncoderTest {

    @Test
    public void base64EncoderTest() throws Exception {
        log.info("Base64 Encoder happy path test");

        assertNotNull(new Base64Encoder().apply(List.of("test1")));
    }

    @Test
    public void base64EncoderNullTest() throws Exception {
        log.info("Base64 Encoder null input test");

        assertNull(new Base64Encoder().apply(null));
    }

    @Test
    public void base64EncoderEmptyTest() throws Exception {
        log.info("Base64 Encoder null input test");

        assertNull(new Base64Encoder().apply(new ArrayList<>()));
    }
}
