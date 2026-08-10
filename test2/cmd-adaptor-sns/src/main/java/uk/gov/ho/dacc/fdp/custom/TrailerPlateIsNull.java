package uk.gov.ho.dacc.fdp.custom;

import org.springframework.stereotype.Component;
import uk.gov.ho.dacc.fdp.factory.Utils;
import uk.gov.ho.dacc.fdp.transform.ICustomMapping;

import java.util.List;

@Component("TrailerPlateIsNull")
public class TrailerPlateIsNull implements ICustomMapping {
    @Override
    public Boolean apply(List<Object> list) {
        String vehicleTrailerPlate = (String) list.get(0);
        return Utils.getTrailerPlate(vehicleTrailerPlate) == null;
    }
}
