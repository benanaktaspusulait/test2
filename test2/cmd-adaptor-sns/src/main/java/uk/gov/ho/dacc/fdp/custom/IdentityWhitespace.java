package uk.gov.ho.dacc.fdp.custom;

import org.springframework.stereotype.Component;
import uk.gov.ho.dacc.fdp.transform.ICustomMapping;

import java.util.List;

@Component("IdentityWhitespace")
public class IdentityWhitespace implements ICustomMapping {
    @Override
    public String apply(List<Object> list) {
        if (list == null || list.isEmpty()) {
            return "true";
        }

        Object identity = list.get(0);
        if (identity == null) {
            return "true";
        }

        return String.valueOf(identity.toString().isBlank());
    }
}
