package uk.gov.ho.dacc.fdp.custom;

import org.springframework.stereotype.Component;
import uk.gov.ho.dacc.fdp.transform.ICustomMapping;

import java.nio.ByteBuffer;
import java.nio.charset.StandardCharsets;
import java.util.Base64;
import java.util.List;

import static java.nio.charset.StandardCharsets.ISO_8859_1;
import static org.apache.commons.lang3.StringUtils.isNotBlank;

@Component("Base64Encoder")
public class Base64Encoder implements ICustomMapping {

    @Override
    public String apply(List<Object> list) {

        if (list == null || list.isEmpty()) {
            return null;
        }
        ByteBuffer recordHashBytes = ByteBuffer.wrap(list.get(0).toString().getBytes(ISO_8859_1));
        return base64Encode(recordHashBytes);
    }

    private String base64Encode(final ByteBuffer field) {
        if (isNotBlank(field.duplicate().toString())) {
            String toEncode = StandardCharsets.ISO_8859_1.decode(field.duplicate()).toString();
            return Base64.getEncoder().encodeToString(toEncode.getBytes());
        }
        return null;
    }
}
