package uk.gov.ho.dacc.fdp.custom;

import lombok.extern.slf4j.Slf4j;
import org.junit.Test;
import uk.gov.ho.dsa.cdl.hmrc.snsens.SealRecord;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

import static org.junit.Assert.assertEquals;

@Slf4j
public class SealValueConcatTest {

    @Test
    public void sealValueConcatTest() throws Exception {
        log.info("Seal Value Concat happy path test");

        SealRecord sealRecord1 = SealRecord.newBuilder()
                .setIdentity("abc")
                .setIdentityLanguage("English")
                .build();

        SealRecord sealRecord2 = SealRecord.newBuilder()
                .setIdentity("def")
                .setIdentityLanguage("Spanish")
                .build();

        List<Object> inputList = Collections.singletonList(List.of(sealRecord1, sealRecord2));
        String expectedString = "abc|English,def|Spanish";

        assertEquals(expectedString, new SealValueConcat().apply(inputList));
    }

    @Test
    public void sealValueConcatNullLanguageTest() throws Exception {
        log.info("Seal Value Concat null language test");

        SealRecord sealRecord = SealRecord.newBuilder()
                .setIdentity("abc")
                .build();

        List<Object> inputList = Collections.singletonList(Collections.singletonList(sealRecord));
        String expectedString = "abc|null";

        assertEquals(expectedString, new SealValueConcat().apply(inputList));
    }

    @Test
    public void sealValueConcatEmptyTest() throws Exception {
        log.info("Seal Value Concat no input values test");

        List<Object> inputList = Collections.singletonList(Collections.EMPTY_LIST);

        assertEquals(null ,new SealValueConcat().apply(inputList));
    }

    @Test
    public void sealValueConcatNullInputTest() throws Exception {
        log.info("Seal Value Concat null input test");

        assertEquals(null, new SealValueConcat().apply(null));
    }

    @Test
    public void sealValueConcatEmptyListTest() throws Exception {
        log.info("Seal Value Concat empty input test");

        assertEquals(null, new SealValueConcat().apply(new ArrayList<>()));
    }

    @Test
    public void sealValueConcatNotListTest() throws Exception {
        log.info("Seal Value Concat not list test");

        List<Object> inputList = Collections.singletonList("test1");

        assertEquals(null, new SealValueConcat().apply(inputList));
    }
}
