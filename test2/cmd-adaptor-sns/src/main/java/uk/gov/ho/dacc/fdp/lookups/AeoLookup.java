package uk.gov.ho.dacc.fdp.lookups;

import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Component;
import uk.gov.ho.dacc.fdp.lookup.ILookup;

@Component("aeoLookup")
public class AeoLookup implements ILookup {
    @Override
    public CharSequence lookup(CharSequence key) {
        String aeo = null;
        if (StringUtils.isNotBlank(key)) {
            //lookup code
        }
        return aeo;
    }
}