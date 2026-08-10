package uk.gov.ho.dacc.fdp.custom;

import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class Commons {
    private static final String VEHICLE = "VEHICLE";
    private static final String ALPHA413PATTERN = "^(?!^IMO)(?=.*[a-zA-Z])(?=.*\\d)[a-zA-Z0-9\\s-]{4,13}$";


    private Commons() {
    }

    private static String trimValue(String value) {
        return value == null ? null : value.trim();
    }

    private static String getSplitValue(String regIdentity, String regType, Pattern groupPattern, int vehicleGroup, int trailerGroup) {
        Matcher matcher = groupPattern.matcher(regIdentity);
        if (matcher.find()) {
            return trimValue(regType.equalsIgnoreCase(VEHICLE) ? matcher.group(vehicleGroup) : matcher.group(trailerGroup));
        }
        return null;
    }

    private static String getMatchingSplitValue(String regIdentity, String regType, boolean isRuleMatch,
                                                boolean isPlusNineChars, Pattern groupPattern) {
        return getMatchingSplitValue(regIdentity, regType, isRuleMatch, isPlusNineChars, groupPattern, 1, 3);
    }

    private static String getMatchingSplitValue(String regIdentity, String regType, boolean isRuleMatch,
                                                boolean isPlusNineChars, Pattern groupPattern,
                                                int vehicleGroup, int trailerGroup) {
        String splitValue = getSplitValue(regIdentity, regType, groupPattern, vehicleGroup, trailerGroup);
        if (isRuleMatch && isPlusNineChars && splitValue != null && Pattern.matches(ALPHA413PATTERN, splitValue)) {
            return splitValue;
        }
        return null;
    }

    private static String getSingleOccurrenceSplitValue(String regIdentity, String regType, boolean isPlusNineChars,
                                                        String countPattern, String groupPattern) {
        Pattern separatorCountPattern = Pattern.compile(countPattern);
        Pattern separatorGroupPattern = Pattern.compile(groupPattern);
        boolean isSingleOccurrence = separatorCountPattern.matcher(regIdentity).results().count() == 1;
        return getMatchingSplitValue(regIdentity, regType, isSingleOccurrence, isPlusNineChars, separatorGroupPattern);
    }

    public static String getRegistration(String regIdentity, String regType) {

        if (regIdentity == null || regType == null) {
            return null;
        }

        regIdentity = regIdentity.trim();
        regIdentity = regIdentity.replaceAll("\\s*/\\s*", "/");
        boolean isPlusNineChars = regIdentity.length() > 9;

        //Logic follows hierarchical rule set as defined by Cerberus in custom description - below
        // note 1: Vehicle and Trailer logic are largely the same (Vehicle = left split / Trailer = right-split of x separator/s)
        // so these are grouped and handled together with regType parameter passed from function to determine correct return value
        //note 2: rules are split into 1a, 1b etc. where required to handle variants of the rule e.g. single OR double ##
        //This can potentially be refactored later



        /* Rule 1
        Vehicle:
        When (single instance of [:|;|#|-|+] is present
        OR single instance of [##] is present)
        And length > 9
        AND Left_Split on [:|;|-|+|#{2}] = regex ^(?!^IMO)(?=.*[a-zA-Z])(?=.*\d)[a-zA-Z0-9\s-]{4,13}$
        AND
        Ignore all other special chars
        Split on [:|;|#|-|+] and output Left_Split

        Trailer:
        When (single instance of [:|;|#|-|+] is present
        OR single instance of [##] is present)
        And length > 9
        AND Right_Split on [:|;|-||+|#{2}] = regex ^(?!^IMO)(?=.*[a-zA-Z])(?=.*\d)[a-zA-Z0-9\s-]{4,13}$
        Ignore all other special chars
        Split on [:|;|-||+|#{2}] and output Right_Split

        */

        //R1a (:)
        String singleColonGroupPatternVal;
        Pattern singleColonCountPattern = Pattern.compile(":");
        Pattern singleColonGroupPattern = Pattern.compile("(.*)(:)(.*)");
        boolean isSingleColon = singleColonCountPattern.matcher(regIdentity).results().count() == 1;
        singleColonGroupPatternVal = getMatchingSplitValue(regIdentity, regType, isSingleColon, isPlusNineChars, singleColonGroupPattern);
        if (singleColonGroupPatternVal != null) {
            return singleColonGroupPatternVal;
        }

        //R1b (;)
        String singleSemicolonGroupPatternVal;
        Pattern singleSemicolonCountPattern = Pattern.compile(";");
        Pattern singleSemicolonGroupPattern = Pattern.compile("(.*)(;)(.*)");
        boolean isSingleSemicolon = singleSemicolonCountPattern.matcher(regIdentity).results().count() == 1;
        singleSemicolonGroupPatternVal = getMatchingSplitValue(regIdentity, regType, isSingleSemicolon, isPlusNineChars, singleSemicolonGroupPattern);
        if (singleSemicolonGroupPatternVal != null) {
            return singleSemicolonGroupPatternVal;
        }

        //R1c (#)
        String singleHashGroupPatternVal;
        Pattern singleHashCountPattern = Pattern.compile("#");
        Pattern singleHashGroupPattern = Pattern.compile("(.*)(#)(.*)");
        boolean isSingleHash = singleHashCountPattern.matcher(regIdentity).results().count() == 1;
        singleHashGroupPatternVal = getMatchingSplitValue(regIdentity, regType, isSingleHash, isPlusNineChars, singleHashGroupPattern);
        if (singleHashGroupPatternVal != null) {
            return singleHashGroupPatternVal;
        }

        //R1d (##)
        String doubleHashGroupPatternVal;
        Pattern doubleHashCountPattern = Pattern.compile("##");
        Pattern doubleHashGroupPattern = Pattern.compile("(.*)(##)(.*)");
        boolean isDoubleHash = doubleHashCountPattern.matcher(regIdentity).results().count() == 1;
        doubleHashGroupPatternVal = getMatchingSplitValue(regIdentity, regType, isDoubleHash, isPlusNineChars, doubleHashGroupPattern);
        if (doubleHashGroupPatternVal != null) {
            return doubleHashGroupPatternVal;
        }

        //R1e (-)
        String singleDashGroupPatternVal;
        Pattern singleDashCountPattern = Pattern.compile("\\-");
        Pattern singleDashGroupPattern = Pattern.compile("(.*)(\\-)(.*)");
        boolean isSingleDash = singleDashCountPattern.matcher(regIdentity).results().count() == 1;
        singleDashGroupPatternVal = getMatchingSplitValue(regIdentity, regType, isSingleDash, isPlusNineChars, singleDashGroupPattern);
        if (singleDashGroupPatternVal != null) {
            return singleDashGroupPatternVal;
        }

        //R1f (+)
        String singlePlusGroupPatternVal;
        Pattern singlePlusCountPattern = Pattern.compile("\\+");
        Pattern singlePlusGroupPattern = Pattern.compile("(.*)(\\+)(.*)");
        boolean isSinglePlus = singlePlusCountPattern.matcher(regIdentity).results().count() == 1;
        singlePlusGroupPatternVal = getMatchingSplitValue(regIdentity, regType, isSinglePlus, isPlusNineChars, singlePlusGroupPattern);
        if (singlePlusGroupPatternVal != null) {
            return singlePlusGroupPatternVal;
        }


        /*Rule 2

        Vehicle:
        When (single instance of '/ ' is present
        OR single instance of '/' is present
        OR single instance of '//' is present)
        And length > 9
        AND Left_Split on SEPARATOR = regex ^(?!^IMO)(?=.*[a-zA-Z])(?=.*\d)[a-zA-Z0-9\s-]{4,13}$
        Ignore all other separators and output Left_Split

        Trailer :
        When (single instance of '/ ' is present
        OR single instance of '/' is present
        OR single instance of '//' is present)
        And length > 9
        AND Right_Split on SEPARATOR = regex ^(?!^IMO)(?=.*[a-zA-Z])(?=.*\d)[a-zA-Z0-9\s-]{4,13}$
        Ignore all other separators and output Right_Split
         */

        //R2a - single instance of '/ ' is present
        String singleSlashSpaceGroupPatternVal = getSingleOccurrenceSplitValue(
                regIdentity, regType, isPlusNineChars, "\\/ ", "(.*)(\\/ )(.*)");
        if (singleSlashSpaceGroupPatternVal != null) {
            return singleSlashSpaceGroupPatternVal;
        }

        //R2b - single instance of '//' is present
        String singleSlashSlashGroupPatternVal = getSingleOccurrenceSplitValue(
                regIdentity, regType, isPlusNineChars, "\\/\\/", "(.*)(\\/\\/)(.*)");
        if (singleSlashSlashGroupPatternVal != null) {
            return singleSlashSlashGroupPatternVal;
        }

        //R2c - single instance of '/' is present
        String singleSlashGroupPatternVal = getSingleOccurrenceSplitValue(
                regIdentity, regType, isPlusNineChars, "\\/", "(.*)(\\/)(.*)");
        if (singleSlashGroupPatternVal != null) {
            return singleSlashGroupPatternVal;
        }

        /*Rule 3

        Vehicle:
        When multiple instances of '/' are present
        And length > 9
        AND Left_Split on first '/'  = regex ^(?!^IMO)(?=.*[a-zA-Z])(?=.*\d)[a-zA-Z0-9\s-]{4,13}$
        Split on first '/' and output Left_Split

        Trailer:
        When multiple instances of '/' are present
        And length > 9
        AND Right_Split on first '/'  = regex ^(?!^IMO)(?=.*[a-zA-Z])(?=.*\d)[a-zA-Z0-9\s-]{4,13}$
        Split on first '/' and output Right_Split

         */


        String multipleSlashGroupPatternVal;

        Pattern multipleSlashCountPattern = Pattern.compile(".*\\/.+\\/.*");
        Pattern multipleSlashGroupPattern = Pattern.compile("^([^\\/]*)(\\/)(.*)");
        boolean isMultipleSlash = multipleSlashCountPattern.matcher(regIdentity).results().findAny().isPresent();
        multipleSlashGroupPatternVal = getMatchingSplitValue(regIdentity, regType, isMultipleSlash, isPlusNineChars, multipleSlashGroupPattern);
        if (multipleSlashGroupPatternVal != null) {
            return multipleSlashGroupPatternVal;
        }


        /* Rule 4

        Vehicle:
        When single instance of 'whitespace' is present
        And length > 9
        AND Left_Split on 'whitespace' = regex ^(?!^IMO)(?=.*[a-zA-Z])(?=.*\d)[a-zA-Z0-9\s-]{4,13}$
        Ignore all other special chars
        Split on 'whitespace' and output Left_Split

        Trailer:
        When single instance of 'whitespace' is present
        And length > 9
        AND Right_Split on 'whitespace' = regex ^(?!^IMO)(?=.*[a-zA-Z])(?=.*\d)[a-zA-Z0-9\s-]{4,13}$
        Ignore all other special chars
        Split on 'whitespace' and output Right_Split

        */

        String singleWhitespaceGroupPatternVal;
        Pattern singleWhitespaceCountPattern = Pattern.compile("\\s");
        Pattern singleWhitespaceGroupPattern = Pattern.compile("(.*)(\\s)(.*)");
        boolean isSingleWhitespace = singleWhitespaceCountPattern.matcher(regIdentity).results().count() == 1;
        singleWhitespaceGroupPatternVal = getMatchingSplitValue(regIdentity, regType, isSingleWhitespace, isPlusNineChars, singleWhitespaceGroupPattern);
        if (singleWhitespaceGroupPatternVal != null) {
            return singleWhitespaceGroupPatternVal;
        }


        /* Rule 5

        Vehicle:
        When multiple instance of [#] is present
        And length > 9
        Ignore all other special chars
        Split on 2nd instance of [#] and output left split ^#.*#$


        Trailer:
        When multiple instance of [#] is present
        And length > 9
        Ignore all other special chars
        Split on 2nd instance of [#] and output Right_Split ^#.*#$

         */
        String multipleHashGroupPatternVal;
        Pattern multipleHashCountPattern = Pattern.compile("[^#]*#[^#]+#");
        Pattern multipleHashGroupPattern = Pattern.compile("^([^#]*)(#)([^#]+)(#)(.*)");
        boolean isMultipleHash = multipleHashCountPattern.matcher(regIdentity).results().findAny().isPresent();
        multipleHashGroupPatternVal = getMatchingSplitValue(regIdentity, regType, isMultipleHash, isPlusNineChars, multipleHashGroupPattern, 3, 5);
        if (multipleHashGroupPatternVal != null) {
            return multipleHashGroupPatternVal;
        }


        /*
        Rule 6

        Vehicle:
        IF no separator is present AND
        Regex = ^(?!^IMO)(?=.*[a-zA-Z])(?=.*\d)[a-zA-Z0-9\s-]{4,13}$
        do not split and output value
        ELSE output NULL

        Trailer:
        ELSE do not split and output null
         */

        if (regType.equalsIgnoreCase(VEHICLE) && Pattern.matches(ALPHA413PATTERN, regIdentity)) {
            return regIdentity;
        }

        //Rule 7 - default return null if no other return value before this point

        //ELSE do not split and output NULL
        return null;
    }


}