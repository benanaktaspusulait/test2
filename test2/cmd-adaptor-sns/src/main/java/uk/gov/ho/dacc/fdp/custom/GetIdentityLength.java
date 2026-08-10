package uk.gov.ho.dacc.fdp.custom;

import org.springframework.stereotype.Component;
import uk.gov.ho.dacc.fdp.transform.ICustomMapping;

import java.util.List;

@Component("GetIdentityLength")
public class GetIdentityLength implements ICustomMapping {
    @Override
    public String apply(List<Object> list) {
        if (list == null || list.isEmpty()) {
            return "0";
        }

        Object identity = list.get(0);
        if (identity == null) {
            return "0";
        }

        return String.valueOf(identity.toString().length());
    }
}
