package uk.gov.ho.dacc.fdp.custom;

import lombok.extern.slf4j.Slf4j;
import org.junit.Test;
import uk.gov.ho.dsa.cdl.hmrc.snsens.PackageRecord;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

import static org.junit.Assert.assertEquals;


@Slf4j
public class PackageValueConcatTest {

    @Test
    public void packageValueConcatTest() throws Exception {
        log.info("Package Value Concat happy path test");

        PackageRecord packageRecord1 = PackageRecord.newBuilder()
                .setKindOfPackages("abc")
                .setNumberOfPackages(1)
                .setNumberOfPieces(2)
                .setMarks("mark1")
                .setMarksLanguage("English")
                .build();

        PackageRecord packageRecord2 = PackageRecord.newBuilder()
                .setKindOfPackages("def")
                .setNumberOfPackages(3)
                .setNumberOfPieces(4)
                .setMarks("mark2")
                .setMarksLanguage("Spanish")
                .build();

        List<Object> inputList = Collections.singletonList(List.of(packageRecord1, packageRecord2));
        String expectedString = "abc|1|2|mark1|English,def|3|4|mark2|Spanish";

        assertEquals(expectedString, new PackageValueConcat().apply(inputList));

    }

    @Test
    public void packageValueConcatEmptyTest() throws Exception {
        log.info("Package Value Concat no input values test");

        List<Object> inputList = Collections.singletonList(Collections.EMPTY_LIST);

        assertEquals(null, new PackageValueConcat().apply(inputList));
    }

    @Test
    public void packageValueConcatNullInputTest() throws Exception {
        log.info("Package Value Concat null input test");

        assertEquals(null, new PackageValueConcat().apply(null));
    }

    @Test
    public void PackageValueConcatEmptyListTest() throws Exception {
        log.info("Package Value Concat empty input test");

        assertEquals(null, new PackageValueConcat().apply(new ArrayList<>()));
    }

    @Test
    public void PackageValueConcatNotListTest() throws Exception {
        log.info("Package Value Concat not list test");

        List<Object> inputList = Collections.singletonList("test1");

        assertEquals(null, new PackageValueConcat().apply(inputList));
    }
}
