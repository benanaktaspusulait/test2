package uk.gov.ho.dacc.fdp.custom;

import org.springframework.stereotype.Component;
import uk.gov.ho.dacc.fdp.transform.ICustomMapping;

import java.util.List;

@Component("CustomSpecialMentions")
public class CustomSpecialMentions implements ICustomMapping {
    @Override
    public String apply(List<Object> list)  {
        if (list != null && list.get(0) instanceof List && !((List) list.get(0)).isEmpty()) {
            List specialMentions = (List) list.get(0);
            return specialMentions.isEmpty() ? null : String.join(";", specialMentions);
        }
        return null;
    }
}
