package uk.gov.ho.dacc.fdp.custom;

import org.springframework.stereotype.Component;
import uk.gov.ho.dacc.fdp.transform.ICustomMapping;

import java.util.List;

@Component("OfficeOfSubsequentEntryArray")
public class OfficeOfSubsequentEntryArray implements ICustomMapping {
    @Override
    public String apply(List<Object> list)  {
        if (list != null && list.get(0) instanceof List && !((List) list.get(0)).isEmpty()) {

            List officeOfSubsequentEntry = (List) list.get(0);
            return officeOfSubsequentEntry.isEmpty() ? null : String.join(";", officeOfSubsequentEntry);
        }
        return null;
    }
}
