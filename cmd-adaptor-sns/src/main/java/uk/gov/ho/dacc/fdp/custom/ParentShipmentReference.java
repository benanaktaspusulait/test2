package uk.gov.ho.dacc.fdp.custom;

import org.springframework.stereotype.Component;
import uk.gov.ho.dacc.fdp.transform.ICustomMapping;
import uk.gov.ho.dsa.cdl.hmrc.snsens.DocumentRecord;

import java.util.Arrays;
import java.util.List;

import static java.util.Objects.isNull;

@Component("ParentShipmentReference")
public class ParentShipmentReference implements ICustomMapping {

    @Override
    public String apply(List<Object> list) {

        if (list == null || list.size() < 2 || (!isNull(list.get(0)) && !(list.get(0) instanceof List))) {
            return null;
        }

        List<DocumentRecord> documents = (List<DocumentRecord>) list.get(0);
        String  movementReferenceNumber = (String) list.get(1);

        if (isNull(documents) || documents.isEmpty()) {
            return movementReferenceNumber;
        } else if (documents.size() > 1) {
            String[] types = {"N704", "N740", "N741", "N785", "N821"};
            if (Arrays.asList(types).contains(documents.get(0).getType().toString())) {
                return documents.get(0).getReference().toString();
            } else {
                return documents.get(1).getReference().toString();
            }
        } else {
            return documents.get(0).getReference().toString();
        }
    }
}
