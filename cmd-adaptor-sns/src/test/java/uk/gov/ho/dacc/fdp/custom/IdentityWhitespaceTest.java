package uk.gov.ho.dacc.fdp.custom;

import lombok.extern.slf4j.Slf4j;
import org.junit.Test;

import java.util.Collections;
import java.util.List;

import static org.junit.Assert.assertEquals;


@Slf4j
public class IdentityWhitespaceTest {

    @Test
    public void IdentityWhitespaceTestFalse() {
        log.info("IdentityWhiteSpace happy path test: output true if identity = whitespace ELSE false");

        List<Object> inputList = Collections.singletonList("123");
        assertEquals("false", new IdentityWhitespace().apply(inputList));
    }

    @Test
    public void IdentityWhitespaceTestTrue() {
        log.info("IdentityWhiteSpace fail path test: output true if identity = whitespace ELSE false");

        List<Object> inputList = Collections.singletonList(" ");
        assertEquals("true", new IdentityWhitespace().apply(inputList));
    }

    @Test
    public void IdentityWhitespaceTestNull() {
        log.info("IdentityWhiteSpace fail path test: output true if identity = null ELSE false");

        List<Object> inputList = Collections.singletonList(null);
        assertEquals("true", new IdentityWhitespace().apply(inputList));
    }

    @Test
    public void identityWhitespaceNullList() {
        assertEquals("true", new IdentityWhitespace().apply(null));
    }

    @Test
    public void identityWhitespaceEmptyList() {
        assertEquals("true", new IdentityWhitespace().apply(Collections.emptyList()));
    }

    @Test
    public void identityWhitespaceNonStringValue() {
        assertEquals("false", new IdentityWhitespace().apply(Collections.singletonList(123)));
    }


}
