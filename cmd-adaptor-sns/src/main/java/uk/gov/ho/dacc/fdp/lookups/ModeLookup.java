package uk.gov.ho.dacc.fdp.lookups;

import org.springframework.stereotype.Component;
import uk.gov.ho.dacc.fdp.lookup.ILookup;

import java.util.Map;

/**
 * Lookup for transport modes.
 * Mapping description says:
 *     Reference as follows:
 *     1 - Maritime,
 *     2 - Rail,
 *     3 - Road,
 *     4 - Air Freight,
 *     8 - Inland Water Transport,
 *     10 - RoRo Accompanied Freight,
 *     11 - RoRo Unaccompanied Freight
 */
@Component("modeLookup")
public class ModeLookup implements ILookup {

    private static final Map<String, String> modeLookups = Map.of("1", "Maritime",
            "2", "Rail",
            "3", "Road",
            "4", "Air Freight",
            "8", "Inland Water Transport",
            "10", "RORO Accompanied Freight",
            "11", "RORO Unaccompanied Freight");

    @Override
    public CharSequence lookup(CharSequence key) {
        return modeLookups.get(key.toString());
    }
}
