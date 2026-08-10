package uk.gov.ho.dacc.fdp.custom;

import org.springframework.stereotype.Component;
import uk.gov.ho.dacc.fdp.transform.ICustomMapping;

import java.util.List;

@Component("AeoLookup")
public class AeoLookup implements ICustomMapping {
    @Override
    public Object apply(List<Object> list) {
        String aeolookup = null;
        return aeolookup;
    }
}