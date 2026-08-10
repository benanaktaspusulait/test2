package uk.gov.ho.dacc.fdp.custom;

import lombok.extern.slf4j.Slf4j;
import org.junit.Test;

import java.util.Collections;
import java.util.List;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertNull;

@Slf4j
public class GetImoNumberTest {

    @Test
    public void getImoNumberTest_case1() {
        //IF length = 7 AND regex \d+  THEN output value
        String input = "1234567";
        List<Object> inputList = Collections.singletonList(input);
        String result = new GetImoNumber().apply(inputList);
        assertEquals("1234567", result);
    }

    @Test
    public void getImoNumberTest_case2() {
        // ELSEIF regex IMO\d{7} THEN output value
        String input = "IMO1234567";
        List<Object> inputList = Collections.singletonList(input);
        String result = new GetImoNumber().apply(inputList);
        assertEquals("IMO1234567", result);
    }

    @Test
    public void getImoNumberTest_case3() {
        //              ELSEIF left split on [whitespace][/][//][:][;][#] has length = 7
        //                                AND regex \d+ THEN output value
        String input = "1234567// / : ; #";
        List<Object> inputList = Collections.singletonList(input);
        String result = new GetImoNumber().apply(inputList);
        assertEquals("1234567", result);
    }

    @Test
    public void getImoNumberTest_case4() {
        //ELSEIF right split on [whitespace][/][//][:][;][#] has length = 7 AND regex \d+ THEN output value

        String input = "// / : ; # 1234567";
        List<Object> inputList = Collections.singletonList(input);
        String result = new GetImoNumber().apply(inputList);
        assertEquals("1234567", result);
    }

    @Test
    public void getImoNumberTest_nullList() {
        assertNull(new GetImoNumber().apply(null));
    }

    @Test
    public void getImoNumberTest_emptyList() {
        assertNull(new GetImoNumber().apply(Collections.emptyList()));
    }

    @Test
    public void getImoNumberTest_nullValue() {
        assertNull(new GetImoNumber().apply(Collections.singletonList(null)));
    }

    @Test
    public void getImoNumberTest_blankValue() {
        assertNull(new GetImoNumber().apply(Collections.singletonList("   ")));
    }

    @Test
    public void getImoNumberTest_nonStringValue() {
        assertEquals("1234567", new GetImoNumber().apply(Collections.singletonList(1234567)));
    }
}
