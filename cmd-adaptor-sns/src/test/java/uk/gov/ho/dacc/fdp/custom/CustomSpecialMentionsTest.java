package uk.gov.ho.dacc.fdp.custom;

import lombok.extern.slf4j.Slf4j;
import org.junit.Test;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

import static org.junit.Assert.assertEquals;


@Slf4j
public class CustomSpecialMentionsTest {

    @Test
    public void CustomSpecialMentionsTestNotNull() throws Exception {
        log.info("CustomSpecialMentionsTestNotNull : happy path test");

        List<CharSequence> testVals = new ArrayList<CharSequence>();
        testVals.add("100");
        testVals.add("DG1");

        List<Object> inputList = Collections.singletonList(testVals);
        assertEquals("100;DG1", new CustomSpecialMentions().apply(inputList));
    }

    @Test
    public void CustomSpecialMentionsTestDefault() throws Exception {
        log.info("CustomSpecialMentionsTestDefault : default value test i.e. default value test i.e. empty [ ]  (defined in AVRO)");

        List<CharSequence> testVals = new ArrayList<CharSequence>();
        List<Object> inputList = Collections.singletonList(testVals);
        assertEquals(null, new CustomSpecialMentions().apply(inputList));
    }

}
