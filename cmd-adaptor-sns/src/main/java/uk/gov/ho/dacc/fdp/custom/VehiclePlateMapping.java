package uk.gov.ho.dacc.fdp.custom;

import org.springframework.stereotype.Component;
import uk.gov.ho.dacc.fdp.factory.Utils;
import uk.gov.ho.dacc.fdp.transform.ICustomMapping;

import java.util.List;

@Component("VehiclePlateMapping")
public class VehiclePlateMapping implements ICustomMapping {
    @Override
    public String apply(List<Object> list) {
        String vehicleTrailerPlate = (String) list.get(0);
        return Utils.getVehiclePlate(vehicleTrailerPlate);
    }
}
