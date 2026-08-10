package uk.gov.ho.dacc.fdp.custom;

import org.springframework.stereotype.Component;
import uk.gov.ho.dacc.fdp.transform.ICustomMapping;
import uk.gov.ho.dsa.cdl.hmrc.snsens.SealRecord;

import java.util.ArrayList;
import java.util.List;

@Component("SealValueConcat")
public class SealValueConcat implements ICustomMapping {

    @Override
    public Object apply(List<Object> list) {
        List<String> sealValuesList  = new ArrayList<String>();
        String sealValues = null;

        if (list != null && !list.isEmpty() && list.get(0) instanceof List) {
            for (SealRecord sealRecord : (List<SealRecord>) list.get(0)) {
                sealValuesList.add(sealRecord.getIdentity() + "|" + sealRecord.getIdentityLanguage());
            }
            if (!sealValuesList.isEmpty()){
                sealValues = sealValuesList.toString().replace("[", "").replace("]", "").replace(", ",",");
            }

        }
        return sealValues;
    }
}
