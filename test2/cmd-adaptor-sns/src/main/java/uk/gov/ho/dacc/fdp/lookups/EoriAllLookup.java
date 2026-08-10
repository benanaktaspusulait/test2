package uk.gov.ho.dacc.fdp.lookups;

import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Component;
import uk.gov.ho.dacc.fdp.lookup.ILookup;

@Component("eoriAllLookup")
public class EoriAllLookup implements ILookup {
    @Override
    public CharSequence lookup(CharSequence key) {
        String eori = null;
        if (StringUtils.isNotBlank(key)) {
            //lookup code
            eori = key.toString();
        }
        return eori;
    }
}