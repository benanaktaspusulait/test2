package uk.gov.ho.dacc.fdp.custom;

import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Component;
import uk.gov.ho.dacc.fdp.transform.ICustomMapping;
import uk.gov.ho.dsa.cdl.hmrc.snsens.DocumentRecord;

import java.util.List;

@Component("ConsignmentNumber")
public class ConsignmentNumber implements ICustomMapping {

    private static final String[] docTypePriorityList = {"N705","705","N704","704","N730","730","741","N741","N703","703","714","N714","N740","740","N380","380","N935","N830","830","ZZZ"};

    @Override
    public String apply(List<Object> list)  {
        String consignmentNumber = null;
        String modeOfTransportAtBorder = (!list.isEmpty() && list.get(0) != null) ? list.get(0).toString() : null;
        String itineraryCRN = (list.size() > 1 && list.get(1) != null) ? list.get(1).toString() : null;
        String goodsItemsCRN = (list.size() > 2 && list.get(2) != null) ? list.get(2).toString() : null;

        List<DocumentRecord> documentRecords = null;
        if (list.size() > 3 && list.get(3) instanceof List<?> rawList) {
            if (!rawList.isEmpty() && rawList.get(0) instanceof DocumentRecord) {
                @SuppressWarnings("unchecked")
                List<DocumentRecord> tmp = (List<DocumentRecord>) list.get(3);
                documentRecords = tmp;
            }
        }

        if ("11".equals(modeOfTransportAtBorder)) {
            if (!StringUtils.isEmpty(itineraryCRN)) {
                consignmentNumber = itineraryCRN;
            } else if (!StringUtils.isEmpty(goodsItemsCRN)) {
                consignmentNumber = goodsItemsCRN;
            } else {
                consignmentNumber = getConsignmentNumberFromDocuments(documentRecords);
            }
        } else {
            if (!StringUtils.isEmpty(goodsItemsCRN)) {
                consignmentNumber = goodsItemsCRN;
            } else if (!StringUtils.isEmpty(itineraryCRN)) {
                consignmentNumber = itineraryCRN;
            } else {
                consignmentNumber = getConsignmentNumberFromDocuments(documentRecords);
            }
        }

        return consignmentNumber;
    }

    private String getConsignmentNumberFromDocuments(List<DocumentRecord> documentRecords) {
        String consignmentNumber = null;
        if (documentRecords != null && !documentRecords.isEmpty()) {
            for (String docType : docTypePriorityList) {
                for (DocumentRecord documentRecord : documentRecords) {
                    if (docType.equals(String.valueOf(documentRecord.getType()))) {
                        consignmentNumber = String.valueOf(documentRecord.getReference());
                        return consignmentNumber;
                    }
                }
            }
            consignmentNumber = String.valueOf(documentRecords.get(0).getReference());
        }
        return consignmentNumber;
    }
}