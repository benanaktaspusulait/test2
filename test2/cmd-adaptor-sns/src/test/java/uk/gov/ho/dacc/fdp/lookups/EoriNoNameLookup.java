package uk.gov.ho.dacc.fdp.lookups;

import org.springframework.context.annotation.Profile;
import org.springframework.stereotype.Component;
import uk.gov.ho.dacc.fdp.lookup.ILookup;

@Component("eoriNoNameLookup")
@Profile("test")
public class EoriNoNameLookup implements ILookup {

    @Override
    public CharSequence lookup(CharSequence key) {
        return key;
    }
}