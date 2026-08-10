package uk.gov.ho.dacc.fdp.custom;

import org.springframework.stereotype.Component;
import uk.gov.ho.dacc.fdp.transform.ICustomMapping;

import java.util.List;
import java.util.regex.Pattern;

@Component("GetImoNumber")
public class GetImoNumber implements ICustomMapping {
    private static final Pattern SEPARATOR_PATTERN = Pattern.compile("[\\s/:;#]+");
    private static final Pattern SEVEN_DIGIT_PATTERN = Pattern.compile("\\d{7}");
    private static final Pattern IMO_PATTERN = Pattern.compile("IMO\\d{7}");

    @Override
    public String apply(List<Object> list) {
        /* Rule
        IF length = 7 AND regex \d+  THEN output value
        ELSEIF regex IMO\d{7} THEN output value
        ELSEIF left split on [whitespace][/][//][:][;][#] has length = 7
                            AND regex \d+ THEN output value
        ELSEIF right split on [whitespace][/][//][:][;][#] has length = 7
                            AND regex \d+ THEN output value
        ELSE output NULL
        */

        if (list == null || list.isEmpty()) {
            return null;
        }

        Object value = list.get(0);
        if (value == null) {
            return null;
        }

        String imoNumber = value.toString();
        if (imoNumber.isBlank()) {
            return null;
        }

        // Step 1: IF length = 7 AND regex \d+  THEN output value
        if (SEVEN_DIGIT_PATTERN.matcher(imoNumber).matches()) {
            return imoNumber;
        }

        // Step 2: ELSEIF regex IMO\d{7} THEN output value
        if (IMO_PATTERN.matcher(imoNumber).matches()) {
            return imoNumber;
        }

        String[] splitValues = SEPARATOR_PATTERN.split(imoNumber);

        // Step 3:  ELSEIF left split on [whitespace][/][//][:][;][#] has length = 7
        //                                AND regex \d+ THEN output value
        String leftSplit = firstNonBlank(splitValues);
        if (leftSplit != null && SEVEN_DIGIT_PATTERN.matcher(leftSplit).matches()) {
            return leftSplit;
        }

        // Step 4:  ELSEIF right split on [whitespace][/][//][:][;][#] has length = 7
        //                                AND regex \d+ THEN output value
        String rightSplit = lastNonBlank(splitValues);
        if (rightSplit != null && SEVEN_DIGIT_PATTERN.matcher(rightSplit).matches()) {
            return rightSplit;  // Output the right split value
        }

        // Step 5:  ELSE output NULL
        return null;
    }

    private String firstNonBlank(String[] values) {
        for (String value : values) {
            if (!value.isBlank()) {
                return value;
            }
        }

        return null;
    }

    private String lastNonBlank(String[] values) {
        for (int i = values.length - 1; i >= 0; i--) {
            if (!values[i].isBlank()) {
                return values[i];
            }
        }

        return null;
    }
}
