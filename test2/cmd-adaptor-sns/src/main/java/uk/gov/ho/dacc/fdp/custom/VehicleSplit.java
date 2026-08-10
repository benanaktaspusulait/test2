package uk.gov.ho.dacc.fdp.custom;

import org.springframework.stereotype.Component;
import uk.gov.ho.dacc.fdp.transform.ICustomMapping;

import java.util.List;

@Component("VehicleSplit")
public class VehicleSplit implements ICustomMapping {
    @Override
    public String apply(List<Object> list) {
        String registrationIdentity = (String) list.get(0);

        return Commons.getRegistration(registrationIdentity,"VEHICLE");

    }

}
