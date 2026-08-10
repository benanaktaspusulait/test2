package uk.gov.ho.dacc.fdp.custom;

import org.junit.Test;

import java.util.Arrays;
import java.util.Collections;
import java.util.List;

import static org.junit.Assert.assertEquals;

public class GetContainerNumbersTest {

    @Test
    public void returnsPipeDelimitedValuesAfterFilteringWhitespaceAndNone() {
        List<Object> input = Collections.singletonList(Arrays.asList(" ABC123 ", "   ", "NONE", "none", "XYZ789", null, "  DEF456  "));

        assertEquals("ABC123|XYZ789|DEF456", new GetContainerNumbers().apply(input));
    }

    @Test
    public void returnsNullWhenOuterListIsNull() {
        assertEquals(null, new GetContainerNumbers().apply(null));
    }

    @Test
    public void returnsNullWhenOuterListIsEmpty() {
        assertEquals(null, new GetContainerNumbers().apply(Collections.emptyList()));
    }

    @Test
    public void returnsNullWhenFirstElementIsNull() {
        assertEquals(null, new GetContainerNumbers().apply(Collections.singletonList(null)));
    }

    @Test
    public void returnsNullWhenFirstElementIsNotAList() {
        assertEquals(null, new GetContainerNumbers().apply(Collections.singletonList("ABC123")));
    }

    @Test
    public void returnsNullWhenAllNestedValuesAreFilteredOut() {
        List<Object> input = Collections.singletonList(Arrays.asList(" ", "NONE", "none", null, "   "));

        assertEquals(null, new GetContainerNumbers().apply(input));
    }
}

