package uk.gov.ho.dacc.fdp.custom;

import org.springframework.stereotype.Component;
import uk.gov.ho.dacc.fdp.transform.ICustomMapping;
import uk.gov.ho.dsa.cdl.hmrc.snsens.PackageRecord;

import java.util.ArrayList;
import java.util.List;

@Component("PackageValueConcat")
public class PackageValueConcat implements ICustomMapping {

    @Override
    public String apply(List<Object> list) {
        List<String> packageValuesList  = new ArrayList<String>();
        String packageValues = null;

        if (list != null && !list.isEmpty() && list.get(0) instanceof List) {
            for (PackageRecord packageRecord : (List<PackageRecord>) list.get(0)) {
                packageValuesList.add(packageRecord.getKindOfPackages() + "|" + packageRecord.getNumberOfPackages() + "|" + packageRecord.getNumberOfPieces() + "|" + packageRecord.getMarks() + "|" + packageRecord.getMarksLanguage());
            }
            if (!packageValuesList.isEmpty()){
                packageValues = packageValuesList.toString().replace("[", "").replace("]", "").replace(", ",",");
            }
        }
        return packageValues;
    }
}
