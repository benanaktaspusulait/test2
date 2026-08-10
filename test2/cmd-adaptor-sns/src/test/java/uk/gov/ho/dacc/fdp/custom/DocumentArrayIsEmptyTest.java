package uk.gov.ho.dacc.fdp.custom;

import lombok.extern.slf4j.Slf4j;
import org.junit.Test;

import java.util.Collections;
import java.util.List;

import static org.junit.Assert.assertEquals;


@Slf4j
public class DocumentArrayIsEmptyTest {

    @Test
    public void documentArrayIsEmptyTrueTest() throws Exception {
        log.info("Document Array is empty true test");

        List<Object> inputList = Collections.singletonList(Collections.EMPTY_LIST);

        assertEquals("true", new DocumentsArrayIsEmpty().apply(inputList));
    }

    @Test
    public void documentArrayIsEmptyFalseTest() throws Exception {
        log.info("Document Array is empty false test");

        List<Object> inputList = Collections.singletonList(Collections.singletonList("test1"));

        assertEquals("false", new DocumentsArrayIsEmpty().apply(inputList));
    }
}
