package uk.gov.ho.dacc.fdp.custom;

import org.springframework.stereotype.Component;
import uk.gov.ho.dacc.fdp.transform.ICustomMapping;

import java.util.List;
import java.util.Objects;
import java.util.stream.Collectors;

@Component("GetContainerNumbers")
/**
 * The code is expecting the first element of the input list to also contain another List of containerNumbers. These are concatenated with a pipe delimiter
 */
public class GetContainerNumbers implements ICustomMapping {
    @Override
    public String apply(List<Object> list) {
        if (list == null || list.isEmpty()) {
            return null;
        }

        Object containerNumbers = list.get(0);
        if (!(containerNumbers instanceof List<?>)) {
            return null;
        }

        String output = ((List<?>) containerNumbers).stream()
                .filter(Objects::nonNull)
                .map(Object::toString)
                .map(String::trim)
                .filter(value -> !value.isBlank())
                .filter(value -> !"NONE".equalsIgnoreCase(value))
                .collect(Collectors.joining("|"));

        return output.isEmpty() ? null : output;
    }
}
