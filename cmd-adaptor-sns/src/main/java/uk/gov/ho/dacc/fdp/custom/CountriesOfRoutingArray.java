package uk.gov.ho.dacc.fdp.custom;

import org.springframework.stereotype.Component;
import uk.gov.ho.dacc.fdp.transform.ICustomMapping;

import java.util.List;

@Component("CountriesOfRoutingArray")
public class CountriesOfRoutingArray implements ICustomMapping {
    @Override
    public String apply(List<Object> list)  {;
        if (list != null && list.get(0) instanceof List && !((List) list.get(0)).isEmpty()) {
            List countriesOfRouting = (List) list.get(0);
            return String.join(";", countriesOfRouting);
        }
        return null;
    }
}
